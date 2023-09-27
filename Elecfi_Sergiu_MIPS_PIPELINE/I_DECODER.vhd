library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IDecode is
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
end IDecode;

architecture Behavioral of IDecode is

-- RegFile
type reg_array is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
signal reg_file : reg_array := (others => X"0000");

signal RegAddress: STD_LOGIC_VECTOR(2 downto 0);

begin

    process(clk)			
    begin
        if falling_edge(clk) then
            if enable = '1' and RegWrite = '1' then
                reg_file(conv_integer(WA)) <= WriteData;		
            end if;
        end if;
    end process;		
    -- RegFile read
    ReadData1 <= reg_file(conv_integer(Instr(12 downto 10))); -- RD1
    ReadData2 <= reg_file(conv_integer(Instr(9 downto 7))); -- RD2
    
    -- immediate extend
    Ext_Imm(6 downto 0) <= Instr(6 downto 0); 
    with ExtOp select
        Ext_Imm(15 downto 7) <= (others => Instr(6)) when '1',
                                (others => '0') when '0',
                                (others => '0') when others;

    -- other outputs
    sa <= Instr(3);
    func <= Instr(2 downto 0);
    rt <= Instr(9 downto 7);
    rd <= Instr(6 downto 4);

end Behavioral;
