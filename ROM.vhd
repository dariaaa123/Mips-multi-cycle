----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 03:21:56 PM
-- Design Name: 
-- Module Name: ROM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM is
    Port ( PC : in STD_LOGIC;
           PCplus4 : out STD_LOGIC_VECTOR (5 downto 0);
           instruction: in STD_LOGIC_VECTOR(31 downto 0);
           
end ROM;


architecture Behavioral of ROM is
type rom_type is array (0 to 63) of std_logic_vector(31 downto 0);
signal rom : rom_type := (
others => X"00000000");
begin
process(clk)
begin
if clk


end Behavioral;
