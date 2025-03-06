

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity test_env is
    Port ( clk : in STD_LOGIC;          
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0); 
            btn: in STD_LOGIC_VECTOR (4 downto 0);
           sw: in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));                  
end test_env;

architecture Behavioral of test_env is
component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component UC is
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
end component;

component ID is
    Port ( RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_vector(31 downto 0 );
           RD2 : out STD_LOGIC_vector(31 downto 0);
           instruction: in std_logic_vector(25 downto 0);
           Ext_Imm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0);
           WD : in std_logic_vector(31 downto 0);
           btn: in std_logic;
           en: in std_logic;
           sa: out std_logic_vector(4 downto 0));
end component;

component SSD is
Port(signal clk:in std_logic;
signal data:in std_logic_vector(31 downto 0);
signal cat:out std_logic_vector(6 downto 0);
signal an:out std_logic_vector(7 downto 0)
 );
end component;

component insfetch is
Port(clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           pcplus4 : out STD_LOGIC_VEcTOR(31 downto 0);
           JumpAddress: in std_logic_vector (31 downto 0);
           BranchAdress: in std_logic_vector(31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component  EX is
    Port ( RD1 : in STD_LOGIC_vector(31 downto 0);
    ALUSrc: in std_logic;
    RD2 : in std_logic_vector(31 downto 0);
    Ext_Imm: in std_logic_vector(31 downto 0);
    sa: in std_logic_vector( 4 downto 0);
    func: in std_logic_vector(5 downto 0);
    ALUOp: in std_logic_vector(1 downto 0);
    PCplus4:in std_logic_vector(31 downto 0);
    Zero1: out std_logic;
    Zero2: out std_logic;
    ALURes: out std_logic_vector (31 downto 0);
    BranchAddress: out std_logic_vector(31 downto 0)     
    );
end component;

component MEM is
    Port ( ALUResin : in STD_LOGIC_VECTOR (31 downto 0);
    RD2 : in std_logic_vector( 31 downto 0);
    MemWrite: in std_logic;
    MemData : out std_logic_vector(31 downto 0);
    ALUResout: out std_logic_vector( 31 downto 0);
    clk : in std_logic;
    en: in std_logic
    );
end component;

signal pcplus4 : STD_LOGIC_VEcTOR(31 downto 0);
signal JumpAddress : STD_LOGIC_VEcTOR(31 downto 0);
signal BranchAddress : STD_LOGIC_VEcTOR(31 downto 0);
signal jump : STD_LOGIC;
signal pcsrc :  STD_LOGIC;
--signal pc_nou : STD_LOGIC_VEcTOR(31 downto 0);
signal instruction :STD_LOGIC_VECTOR (31 downto 0);
signal en : std_logic;
signal data : std_logic_vector(31 downto 0);
signal RegDst:  std_logic;
signal ExtOp:  std_logic;
signal ALUSrc:  std_logic;
signal Branch:  std_logic;
signal ALUOp:  std_logic_vector(1 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite:  std_logic;
signal RD1 :  STD_LOGIC_vector(31 downto 0 );
signal RD2 :  STD_LOGIC_vector(31 downto 0);
signal WD :  STD_LOGIC_vector(31 downto 0);
signal ALUResin :  STD_LOGIC_VECTOR (31 downto 0);
signal MemData :  std_logic_vector(31 downto 0);
signal ALUResout:  std_logic_vector( 31 downto 0);
signal Ext_Imm: std_logic_vector(31 downto 0);
signal sa:std_logic_vector( 4 downto 0);
signal func:std_logic_vector(5 downto 0);
signal Zero1: std_logic;
signal Zero2: std_logic;
signal ALURes: std_logic_vector (31 downto 0);
    
begin

btn1: debouncer port map(clk=>clk, btn=>btn(0), en=>en);

fetch: insfetch port map(pcplus4=>pcplus4,BranchAdress=>BranchAddress,
JumpAddress=>JumpAddress,clk=>clk, btn=>btn,jump=>jump,
 pcsrc=>pcsrc,instruction=>instruction);
 
unitate_decoding:ID port map(btn=>btn(0),instruction=>instruction(25 downto 0),
 RegDst=>RegDst,RegWrite=>RegWrite,ExtOp=>ExtOp,func=>func,sa=>sa,
 RD1=>RD1,RD2=>RD2,WD=>WD,en=>en);
 
ssd1: ssd port map(clk=>clk, data=>data, an=>an, cat=>cat); 
unitate_control: UC port map(instruction=>instruction(31 downto 26),
 RegDst=>RegDst,ExtOp=>ExtOp,ALUSrc=>ALUSrc, Branch=>Branch,Jump=>jump,
ALUOp=>ALUOp,MemWrite=>MemWrite,MemtoReg=>MemtoReg,RegWrite=>RegWrite);

ram: MEM port map(RD2=>rd2,MemWrite=>MemWrite,ALUResin=>ALUResin,
MemData=>MemData,ALUResout=>ALUResout,clk=>clk,en=>en);

exec: EX port map(RD1=>RD1,ALUSrc=>ALUSrc,RD2=>RD2,Ext_Imm=>Ext_Imm,
sa=>sa,func=>func,ALUOp=>ALUOp,PCplus4=>PCplus4,Zero1=>Zero1,Zero2=>Zero2,
ALURes=>ALURes,BranchAddress=>BranchAddress);

JumpAddress<=pcplus4(31 downto 28)&instruction(25 downto 0)&"00";
pcsrc<=(Branch and Zero1) or (Branch and Zero2)  ;
process(sw)
begin
case sw is
when "000"=>data<=instruction;
when "001"=>data<=pcplus4;
when "010"=>data<=RD1;
when "011"=>data<=RD2;
when "100"=>data<=Ext_Imm;
when "101"=>data<=ALURes;
when "110"=>data<=MemData;
when others=>data<=WD;
end case;
end process;

led(1 downto 0)<=ALUOp;led(2)<=RegDst; 
led(3)<=ExtOp; led(4)<=ALUSrc; 
led(5)<=Branch; led(6)<=Zero1;
led(7)<=Zero2;
led(8)<=jump; led(9)<=MemWrite; 
led(10)<=MemtoReg; led(11)<=RegWrite;


process(MemtoReg)
begin
if MemtoReg='1' then WD<=MemData;
else WD<=ALUresout;
end if;
end process;


end Behavioral;
