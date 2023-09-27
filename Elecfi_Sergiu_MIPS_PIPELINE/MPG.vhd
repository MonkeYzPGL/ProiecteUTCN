library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port ( clk : in STD_LOGIC;
           input : in STD_LOGIC;
           en : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is

signal Q1, Q2, Q3 : STD_LOGIC;
signal count : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

begin
    en <= Q2 and (not Q3);
    
    process(clk)
    begin
        if clk = '1' and clk'event then
            count <= count + 1;
        end if;
    end process;
    
    process(clk)
    begin
        if clk = '1' and clk'event then
            if count(15 downto 0) =  "1111111111111111" then
                Q1 <= input;
            end if;
         end if;
    end process;
    
    process(clk)
    begin
        if clk = '1' and clk'event then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
end Behavioral;
