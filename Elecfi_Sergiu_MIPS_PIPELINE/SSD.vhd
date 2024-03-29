library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SSD is
    Port ( clk : in STD_LOGIC;
           digit3 : in STD_LOGIC_VECTOR (3 downto 0);
           digit2 : in STD_LOGIC_VECTOR (3 downto 0);
           digit1 : in STD_LOGIC_VECTOR (3 downto 0);
           digit0 : in STD_LOGIC_VECTOR (3 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal counter_out : STD_LOGIC_VECTOR (1 downto 0);
signal mux_1_out : STD_LOGIC_VECTOR (3 downto 0);
signal counter : STD_LOGIC_VECTOR (15 downto 0);

begin
    process(counter_out)
    begin
        case counter_out is 
            when "00" => mux_1_out <= digit3;
            when "01" => mux_1_out <= digit2;
            when "10" => mux_1_out <= digit1;
            when "11" => mux_1_out <= digit0;
        end case;
        
        case counter_out is
            when "00" => an <= "0111";
            when "01" => an <= "1011";
            when "10" => an <= "1101";
            when "11" => an <= "1110";
        end case;
    end process;
    
    process(clk)
    begin
        if clk = '1' and clk'event then
            counter <= counter + 1;
        end if;
        counter_out <= counter(15 downto 14);
    end process;

    


        with mux_1_out SELect
   cat <= "1111001" when "0001",   --1
          "0100100" when "0010",   --2
          "0110000" when "0011",   --3
          "0011001" when "0100",   --4
          "0010010" when "0101",   --5
          "0000010" when "0110",   --6
          "1111000" when "0111",   --7
          "0000000" when "1000",   --8
          "0010000" when "1001",   --9
          "0001000" when "1010",   --A
          "0000011" when "1011",   --b
          "1000110" when "1100",   --C
          "0100001" when "1101",   --d
          "0000110" when "1110",   --E
          "0001110" when "1111",   --F
          "1000000" when others;   --0
          
end Behavioral;
