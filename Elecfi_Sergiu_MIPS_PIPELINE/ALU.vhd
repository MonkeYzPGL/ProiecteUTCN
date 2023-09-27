library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is  
    Port( PCinc : in std_logic_vector(15 downto 0);
            RD1 : in std_logic_vector(15 downto 0);
            RD2 : in std_logic_vector(15 downto 0);
            Ext_Imm : in std_logic_vector(15 downto 0);
            func : in std_logic_vector(2 downto 0);
            sa : in std_logic;
            ALUsrc : in std_logic;
            ALUop : in std_logic_vector(2 downto 0);
            BranchAddress : out std_logic_vector(15 downto 0);
            ALUres : out std_logic_vector(15 downto 0);
            Zero : out std_logic);
end ALU;

architecture Behavioral of ALU is
signal ALUCtrl : std_logic_vector(2 downto 0);
signal BA : std_logic_vector(15 downto 0);
signal dif : std_logic_vector(15 downto 0);
begin
--activare Zero 
dif <= RD1 - RD2;
Zero <= '1' when dif = x"0000" else '0';
BranchAddress <= PCinc + Ext_imm;

--control ALU
process(ALUop, func)
begin
    case ALUop is
        when "000" => --Tip R
            case func is
                when "000" => ALUCtrl <= "000"; --add
                when "001" => ALUCtrl <= "001"; --sub
                when "010" => ALUCtrl <= "010"; --sll
                when "011" => ALUCtrl <= "011"; --slr
                when "100" => ALUCtrl <= "100"; --and
                when "101" => ALUCtrl <= "101"; --or
                when "110" => ALUCtrl <= "110"; --xor
                when "111" => ALUCtrl <= "111"; --slt
                when others => ALUCtrl <= (others => 'X'); --inafara memoriei
            end case;
         when "001" => ALUCtrl <= "000"; --addi
         when "010" => ALUCtrl <= "000"; --lw
         when "011" => ALUCtrl <= "000"; --sw
         when "100" => ALUCtrl <= "001"; --beq
         when "101" => ALUCtrl <= "101"; --ori
         when "110" => ALUCtrl <= "100"; --and
         when others => ALUCtrl <= (others => 'X'); --unknown
        end case;
end process;

----ALU
process(ALUCtrl, RD1, RD2)
begin
    case ALUCtrl is
        when "000" => ALURes <= RD1 + RD2;
        when "001" => ALURes <= RD1 - RD2;
        when "010" => ALURes <= RD1(14 downto 0) & '0';
        when "011" => ALURes <= '0' & RD1(15 downto 1);
        when "100" => ALURes <= RD1 and RD2;
        when "101" => ALURes <= RD1 or RD2;
        when "110" => ALURes <= RD1 xor RD2;
        when "111" => if (signed(RD1) < signed(RD2)) then ALURes <= "0000000000000001"; else ALURes <= "0000000000000000";
        end if;
    end case;
end process;
end Behavioral;