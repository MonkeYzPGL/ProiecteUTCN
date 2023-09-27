library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component mpg 
    port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD
    Port ( clk : in STD_LOGIC;
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component reg_file 
port (
    clk: in std_logic;
        enable: in std_logic;
        RegWr: in std_logic;
        RA1: in std_logic_vector(2 downto 0);
        RA2: in std_logic_vector(2 downto 0);
        WA: in std_logic_vector(2 downto 0);
        WD: in std_logic_vector(15 downto 0);
        RD1: out std_logic_vector(15 downto 0);
        RD2: out std_logic_vector(15 downto 0));
end component;

component IF_Fetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end component;

component IDecode is
    Port (
       clk: in std_logic;
       enable: in std_logic;
       Instr: in std_logic_vector(12 downto 0);
       WriteData: in std_logic_vector(15 downto 0);
       RegWrite: in std_logic;
       WA : in STD_LOGIC_VECTOR(2 downto 0);
       ExtOp: in std_logic;
       ReadData1: out std_logic_vector(15 downto 0);
       ReadData2: out std_logic_vector(15 downto 0);
       Ext_Imm: out std_logic_vector(15 downto 0);
       Func: out std_logic_vector(2 downto 0);
       SA: out std_logic;
       rt : out std_logic_vector(2 downto 0);
       rd : out std_logic_vector(2 downto 0)
    );
end component;
    
component MainControl
    Port (
        OpCode: in std_logic_vector(2 downto 0);
        RegDst: out std_logic;
        ExtOp: out std_logic;
        ALUSrc: out std_logic;
        Branch: out std_logic;
        Jump: out std_logic;
        ALUOp: out std_logic_vector(2 downto 0);
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        RegWrite: out std_logic
    );
end component;

component EX is
    Port ( PCinc : in STD_LOGIC_VECTOR(15 downto 0);
           RD1 : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR(15 downto 0);
           func : in STD_LOGIC_VECTOR(2 downto 0);
           sa : in STD_LOGIC;
           rt : in std_logic_vector(2 downto 0);
           rd : in std_logic_vector(2 downto 0);
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           RegDst : in std_logic;
           BranchAddress : out STD_LOGIC_VECTOR(15 downto 0);
           ALURes : out STD_LOGIC_VECTOR(15 downto 0);
           Zero : out STD_LOGIC;
           rWA : out std_logic_vector(2 downto 0)
           );
end component;


component MEM 
    Port( clk: in std_logic;
          en: in std_logic;
          AluResIn: in std_logic_vector(15 downto 0);
          RD2: in std_logic_vector(15 downto 0);
          MemWrite: in std_logic;
          MemData: out std_logic_vector(15 downto 0);
          AluResOut: out std_logic_vector(15 downto 0));
end component;

signal enable, rst, PCSrc : STD_LOGIC;
signal digits : STD_LOGIC_VECTOR (15 downto 0);
signal Instruction, PCinc,sum, RD1, RD2, Ext_imm, WD : std_logic_vector(15 downto 0);
signal JumpAddress, BranchAddress, ALURes, ALURes1, MemData: std_logic_vector(15 downto 0);
signal func,rt,rd,rWA: STD_LOGIC_VECTOR(2 downto 0);
signal sa, zero: std_logic;
-- main controls 
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);

--pipeline registers
--IF_ID
signal PCInc_IF_ID, Instruction_IF_ID: STD_LOGIC_VECTOR(15 downto 0);
--ID_EX
signal PCInc_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX: STD_LOGIC_VECTOR(15 downto 0);
signal func_ID_EX, rt_ID_EX, rd_ID_EX, ALUOp_ID_EX : STD_LOGIC_VECTOR(2 downto 0);
signal sa_ID_EX, MemtoReg_ID_EX, RegWrite_ID_EX, MemWrite_ID_EX, Branch_ID_EX, ALUSrc_ID_EX, RegDst_ID_EX : STD_LOGIC;
--EX_MEM
signal BranchAddress_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM : STD_LOGIC_VECTOR(15 downto 0);
signal rd_EX_MEM: STD_LOGIC_VECTOR(2 downto 0);
signal zero_EX_MEM, MemtoReg_EX_MEM, RegWrite_EX_MEM, MemWrite_EX_MEM, Branch_EX_MEM : STD_LOGIC;
--MEM_WB
signal MemData_MEM_WB, ALURes_MEM_WB : STD_LOGIC_VECTOR(15 downto 0);
signal rd_MEM_WB : STD_LOGIC_VECTOR(2 downto 0);
signal MemtoReg_MEM_WB, RegWrite_MEM_WB : std_logic;

begin
    -- buttons: reset, enable
    debouncer : mpg port map (clk, btn(0), enable);
    debouncer2 : mpg port map(clk, btn(1), rst);
    
    --main  units
    inst_IF: IF_FETCH port map(clk, rst,enable, BranchAddress_EX_MEM, JumpAddress, Jump, PCSrc, Instruction, PCinc);
    inst_ID: IDecode port map(clk, enable, Instruction_IF_ID(12 downto 0), WD, RegWrite_MEM_WB, rd_MEM_WB, ExtOp, RD1, RD2,Ext_imm, func, sa,rt,rd);
    inst_MC: MainControl port map(Instruction_IF_ID(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
    inst_EX: EX port map(PCInc_ID_EX, RD1_ID_EX, RD2_ID_EX, Ext_imm_ID_EX, func_ID_EX,sa_ID_EX, rt_ID_EX, rd_ID_EX, ALUSrc_ID_EX,ALUOp_ID_EX, RegDst_ID_EX,BranchAddress,ALURes,Zero, rWA);
    inst_MEM: mem port map(clk, enable, ALURes_EX_MEM, RD2_EX_MEM, MemWrite_EX_MEM, MemData, ALURes1);
    
    with MemtoReg_MEM_WB select
        WD <= MemData_MEM_WB when '1',
              ALURes_MEM_WB when '0',
              (others => 'X') when others;
    
    --branch
    PCSrc <= Zero_EX_MEM and Branch_EX_MEM;
    
    --jump address
    JumpAddress <= PCInc_IF_ID(15 downto 13) & Instruction_IF_ID(12 downto 0);
    
    --pipeline registers
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                -- IF_ID
                   PCInc_IF_ID <= PCInc;
                   Instruction_IF_ID <= Instruction;
                -- ID_EX
                    PCInc_ID_EX <= PCinc_IF_ID;
                    RD1_ID_EX <= RD1;
                    RD2_ID_EX <= RD2;
                    Ext_imm_ID_EX <= Ext_imm;
                    sa_ID_EX <= sa;
                    func_ID_EX <= func;
                    rt_ID_EX <= rt;
                    rd_ID_EX <= rd;
                    MemtoReg_ID_EX <= MemtoReg;
                    RegWrite_ID_EX <= RegWrite;
                    MemWrite_ID_EX <= MemWrite;
                    Branch_ID_EX <= Branch;
                    ALUSrc_ID_EX <= ALUSrc;
                    ALUOp_ID_EX <= ALUOp;
                    RegDst_ID_EX <= RegDst;
                -- EX_MEM
                    BranchAddress_EX_MEM <= BranchAddress;
                    Zero_EX_MEM <= Zero;
                    ALURes_EX_MEM <= ALURes;
                    RD2_EX_MEM <= RD2_ID_EX;
                    rd_EX_MEM <= rWA;
                    MemtoReg_EX_MEM <= MemtoReg_ID_EX;
                    RegWrite_EX_MEM <= RegWrite_ID_EX;
                    MemWrite_EX_MEM <= MemWrite_ID_EX;
                    Branch_EX_MEM <= Branch_ID_EX;
                -- MEM_WB
                    MemData_MEM_WB <= MemData;
                    ALURes_MEM_WB <= ALURes1;
                    rd_MEM_WB <= rd_EX_MEM;
                    MemtoReg_MEM_WB <= MemtoReg_EX_MEM;
                    RegWrite_MEM_WB <= RegWrite_EX_MEM;
            end if;
        end if;
  end process;
                    
    
    --SSD display
    with sw(7 downto 5) select
     digits <= Instruction when "000",
               PCinc when "001",
               RD1 when "010",
               RD2 when "011",
               Ext_Imm when "100",
               ALURes when "101",
               MemData when "110",
               WD when "111",
               (others => 'X') when others;
                   
    display: SSD port map(clk => clk,
                       digit3 => digits(15 downto 12),
                       digit2 => digits(11 downto 8),
                       digit1 => digits(7 downto 4),
                       digit0 => digits(3 downto 0),
                       an => an,
                       cat => cat);
     
     --controls of the leds
     led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite &MemtoReg & RegWrite;
end Behavioral;