library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IF_Fetch is
    Port (clk: in STD_LOGIC;
          rst : in STD_LOGIC;
          en : in STD_LOGIC;
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0));
end IF_Fetch;

architecture Behavioral of IF_FETCH is

signal pc_out : STD_LOGIC_VECTOR (15 DOWNTO 0) := X"0000";
signal sum_out : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
signal mux1_out : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
signal mux2_out : STD_LOGIC_VECTOR (15 downto 0) := X"0000";
type rom_array is array (0 to 255) of std_logic_vector(15 downto 0);
signal rom256x16: rom_array := (
    B"000_000_000_001_0_000", -- add $1, $0, $0     #0010
    B"001_000_100_0010100",   -- addi $4, $0, 20    #2214
    B"000_000_000_101_0_000", -- add $5, $0, $0     #0050
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"100_001_100_0001101",   -- beq $1, $4, 13     #860D
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_000_000_011_0_000", -- add $3, $0, $0     #0030
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_001_011_011_0_000", -- add $3, $3, $1     #05B0
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"000_011_101_101_0_000", -- add $5, $5, $3     #0ED0
    B"001_001_001_0000010",   -- addi $1, $1, 2     #2482
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"111_0000000000100",     -- j 4                #E004
    B"000_000_000_000_0_000", -- NO_OP              #0000
    B"011_000_101_0000001",   -- sw $5, 1($0)#6281  #6281
    others => x"1111"
);

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal PCA, NextAddr, AuxSgn, AuxSgn1: STD_LOGIC_VECTOR(15 downto 0);

begin

    -- Program Counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- Instruction OUT
    Instruction <= rom256x16(conv_integer(PC(7 downto 0)));

    -- PC
    PCA <= PC + 1;
    PCinc <= PCA;

    --Branch
    process(PCSrc, PCA, BranchAddress)
    begin
        case PCSrc is 
            when '1' => AuxSgn <= BranchAddress;
            when others => AuxSgn <= PCA;
        end case;
    end process;	

     --Jump
    process(Jump, AuxSgn, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= AuxSgn;
        end case;
    end process;
end Behavioral;