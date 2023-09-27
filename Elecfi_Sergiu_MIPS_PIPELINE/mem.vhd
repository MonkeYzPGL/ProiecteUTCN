library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity MEM is
  Port ( clk: in std_logic;
          en: in std_logic;
          AluResIn: in std_logic_vector(15 downto 0);
          RD2: in std_logic_vector(15 downto 0);
          MemWrite: in std_logic;
          MemData: out std_logic_vector(15 downto 0);
          AluResOut: out std_logic_vector(15 downto 0)
            );
end MEM;

architecture Behavioral of MEM is
type mem is array (0 to 31) of std_logic_vector(15 downto 0);

signal RAM : mem := (x"0000",
    x"0001",
    x"0002",
    x"0003",
    x"0004",
    x"0005",
    x"0006",
    x"0007",
    others => x"0000");

begin
    ALUResOut <= ALUResIn;
    process (clk)
    begin
        if clk'event and clk = '1' then
            if MemWrite = '1' then
                RAM(conv_integer(ALUResIn(4 downto 0))) <= RD2;
            end if;
        end if;
        MemData <= RAM( conv_integer(ALUResIn(4 downto 0)));
    end process;

end Behavioral;
