

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity UC is
    Port ( instruction : in STD_LOGIC_VECTOR (5 downto 0);
    RegDst: out std_logic;
     ExtOp: out std_logic;
      ALUSrc: out std_logic;
       Branch: out std_logic;
        Jump: out std_logic;
        ALUOp: out std_logic_vector(1 downto 0);
         MemWrite: out std_logic;
          MemtoReg: out std_logic;
           RegWrite: out std_logic );
end UC;

architecture Behavioral of UC is

begin
process(instruction)
begin

 RegDst<='0';
 ExtOp<='0';
 ALUSrc<='0';
 Branch<='0';
 Jump<='0';
 ALUOp<="00";
 MemWrite<='0';
 MemtoReg<='0';
 RegWrite<='0';

case instruction is
when "000000"=>RegDst<='1';ExtOp<='1';ALUOp<="01";RegWrite<='1';--R
when "001000"=>ExtOp<='1';ALUSrc<='1';ALUOp<="10";RegWrite<='1';--addi
when "101011"=>ExtOp<='1';ALUSrc<='1';ALUOp<="10";MemWrite<='1';--sw
when "100011"=>ExtOp<='1';ALUSrc<='1';ALUOp<="10";RegWrite<='1';--lw
MemtoReg<='1';
when "001100"=>ExtOp<='1';ALUSrc<='1';ALUOp<="11";RegWrite<='1';--andi
when "000100"=>ExtOp<='1';Branch<='1';ALUOp<="00";--beq
when "000111"=>RegDst<='1';ExtOp<='1';Branch<='1';ALUOp<="00";--bgtz
when others=>Jump<='1';--jump

end case;
end process;
end Behavioral;
