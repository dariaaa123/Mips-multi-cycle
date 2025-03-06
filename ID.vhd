
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ID is
    Port ( RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_vector(31 downto 0 );
           RD2 : out STD_LOGIC_vector(31 downto 0);
           instruction: in std_logic_vector(25 downto 0);
           Ext_Imm: out std_logic_vector(31 downto 0);
           func: out std_logic_vector(5 downto 0);
           WD : in std_logic_vector(31 downto 0);
           clk:in std_logic;
           btn: in std_logic;
           en: in std_logic;
           sa: out std_logic_vector(4 downto 0));
           
           
end ID;

architecture Behavioral of ID is
component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component;
--signal en: std_logic;

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file : reg_array:= (
others => X"00000000");
signal wa: std_logic_vector(4 downto 0);

begin
--btnn: debouncer port map(clk=>clk, btn=>btn, en=>en);
RD1<=reg_file(conv_integer(instruction(25 downto 21)));
RD2<=reg_file(conv_integer(instruction(20 downto 16)));
 
 process(Regwrite,RegDst,clk,en)
 begin
 if Regwrite='1'and clk'event and clk='1' and en='1' and btn='1' then
 if  RegDst='1' then 
 wa<=instruction(15 downto 11);
 reg_file(conv_integer(wa))<=WD;
 else if RegDst='0' then 
 wa<=instruction(20 downto 16);
 reg_file(conv_integer(wa))<=WD;
 end if;
 end if;
 end if;
  end process;
  
process(ExtOp)
begin
if ExtOp='0' then
Ext_Imm<=X"0000"&instruction( 15 downto 0);
else
if ExtOP='1' then
Ext_imm(15 downto 0)<= instruction(15 downto 0);
Ext_imm(31 downto 16)<=(others => instruction(15));
end if;end if;
end process;

func<=instruction(5 downto 0);
sa<=instruction(10 downto 6);

end Behavioral;

