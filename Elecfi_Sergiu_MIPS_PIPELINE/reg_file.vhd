library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_file is
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
end reg_file;

architecture Behavioral of reg_file is

type reg_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal reg_file : reg_array := ( X"0000", X"0000", X"0000", X"0000", X"0000", X"0011", X"0101", others => X"0000");

begin

process(clk)
begin
    if rising_edge(clk) then
        if enable = '1' then
            reg_file(conv_integer(WA)) <= WD;
        end if;
    end if;
end process;
-- RegFile read
RD1 <= reg_file(conv_integer(RA1)); --rs
RD2 <= reg_file(conv_integer(RA2)); --rt
end Behavioral;