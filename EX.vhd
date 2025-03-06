
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity EX is
    Port ( RD1 : in STD_LOGIC_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2 : in std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector( 4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(1 downto 0);
    PCplus4:in std_logic_vector(31 downto 0);
    Zero1: out std_logic;--pt beq
    Zero2: out std_logic;--pt bgtz
    ALURes: out std_logic_vector (31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)
     
    );
end EX;

architecture Behavioral of EX is
signal ALUControl: std_logic_vector(3 downto 0);
signal operator: std_logic_vector(31 downto 0);
signal rez: std_logic_vector(31 downto 0);

begin
process(ALUOp)
begin
case ALUOp is
when "01" => 
case func is 
when "100000" =>ALUControl<="0000"; --adunare
when "100010" =>ALUControl<="0001"; --scadere
when "000000"=>ALUControl<="0010"; --shiftare stanga
when "000010"=>ALUControl<="0011"; --shiftare dreapta
when "100100"=>ALUControl<="0100"; -- si logic
when "100101"=>ALUControl<="0101"; -- sau logic
when others=>ALUControl<="0110"; -- xor logic

end case;
when "10"=>ALUControl<="0111";  --lw ws si addi
when "11"=>ALUControl<="1000"; -- andi
when others=>ALUControl<="1001"; -- beq si bgtz
end case;
end process;

process(ALUSrc)
begin
if ALUSrc='1' then
operator<=Ext_Imm;
else
operator<=RD2;
end if;
end process;
Zero1<='0';
Zero2<='0';
process(ALUControl)
begin 
case ALUControl is
when "0000"=> AluRes<=RD1+operator;
when "0001"=> AluRes<=RD1-operator;
when "0010"=> AluRes<=to_stdlogicvector(to_bitvector(RD1)sll conv_integer(sa));
when "0011"=> AluRes<=to_stdlogicvector(to_bitvector(RD1)srl conv_integer(sa));
when "0100"=> AluRes<=RD1 and operator;
when "0101"=> AluRes<=RD1 or operator;
when "0110"=> AluRes<=RD1 xor operator;
when "0111"=> AluRes<=RD1+operator;
when "1000"=> AluRes<=RD1 and operator;
when others=>BranchAddress<=PCplus4+(operator(29 downto 0) & "00");
AluRes<=RD1-operator;
rez<=RD1-operator;
if rez=0 then
 Zero1<='1';
 else if rez>0 then
 Zero2<='1';
 end if;
end if;
end case;

end process;


end Behavioral;
