library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is

begin

process(OpCode)
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        ALUOp <= "000";
        MemWrite <= '0';
        MemToReg <= '0';
        RegWrite <= '0';
        case OpCode is
            -- Instructiuni de tip R
            when "000" => RegDst <= '1'; RegWrite <= '1'; ALUOp <= "000";
            -- Instructiunea ADDI
            when "001" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUOp <= "001";
            -- Instructiunea LW
            when "010" => RegWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; MemToReg <= '1'; ALUOp <= "010";
            -- Instructiunea SW
            when "011" => MemWrite <= '1'; ALUSrc <= '1'; ExtOp <= '1'; ALUOp <= "011";
            -- Instructiunea BEQ (Branch)
            when "100" => ExtOp <= '1'; Branch <= '1'; ALUOp <= "100";
            -- Instructiunea ORI
            when "101" => RegWrite <= '1'; ALUSrc <= '1'; ALUOp <= "101";
            -- Instructiunea ANDI
            when "110" => RegWrite <= '1'; ALUSrc <= '1'; ALUOp <= "110";
            -- Instructiunea Jump
            when "111" => Jump <= '1'; ALUOp <= "111";
        end case;
    end process;

end Behavioral;