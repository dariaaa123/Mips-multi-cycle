
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity MEM is
    Port ( ALUResin : in STD_LOGIC_VECTOR (31 downto 0);
    RD2 : in std_logic_vector( 31 downto 0);
    MemWrite: in std_logic;
    MemData : out std_logic_vector(31 downto 0);
    ALUResout: out std_logic_vector( 31 downto 0);
    clk : in std_logic;
    en: in std_logic
    );
end MEM;

architecture Behavioral of MEM is
component debouncer is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal ram : ram_type := (
4  => "00000000000000000000000000000100", 
     8  => "00000000000000000000000000000010",
     12  => "00000000000000000000000000000011",
     16 => "00000000000000000000000000000100",
     20 => "10000000000000000000000000000111",
     24 => "10000000000000000000000000000011",
     others => "00000000000000000000000000000000"
);
begin
MemData<=ram(conv_integer(ALUResin));
ALUResout<=ALUResin;
process(clk,MemWrite,en)
  begin
  if clk'event and clk='1' and MemWrite='1' and en='1'then
  ram(conv_integer(ALUResin))<=RD2;
  end if;

end process;


end Behavioral;
