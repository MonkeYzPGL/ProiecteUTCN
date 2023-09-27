library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX is
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
end EX;

architecture Behavioral of EX is

component ALU is
    Port ( PCinc : in std_logic_vector(15 downto 0);
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
end component;

signal B : STD_LOGIC_VECTOR(15 downto 0);

begin

process(AluSrc, RD2, Ext_Imm)
    begin
       case AluSrc is
	   when '0' => B <= RD2;
           when '1' => B <= Ext_Imm;
       end case; 
    end process;
    
    --MUX pentru rWA
process(RegDst, rt, rd)
    begin
        case RegDst is
        when '0' => rWA <= rt;
        when '1' => rWA <= rd;
        end case;
    end process;

    
    a: ALU port map (PCinc, RD1, B, Ext_Imm, func, sa, AluSrc, AluOp, BranchAddress, AluRes, Zero);
    
end Behavioral;
