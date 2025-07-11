--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|      
-- Create Date: 2023
-- Created by: Rob D Jordan
-- Notes: Array vector lib


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package array_pck is

  type array_int is array (natural range <>) of integer;

  type array_2    is array (natural range <>) of std_logic_vector(  2-1 downto 0);
  type array_3    is array (natural range <>) of std_logic_vector(  3-1 downto 0);
  type array_4    is array (natural range <>) of std_logic_vector(  4-1 downto 0);
  type array_5    is array (natural range <>) of std_logic_vector(  5-1 downto 0);
  type array_6    is array (natural range <>) of std_logic_vector(  6-1 downto 0);
  type array_7    is array (natural range <>) of std_logic_vector(  7-1 downto 0);
  type array_8    is array (natural range <>) of std_logic_vector(  8-1 downto 0);
 
  type array_10    is array (natural range <>) of std_logic_vector(  11-1 downto 0);
  type array_11    is array (natural range <>) of std_logic_vector(  11-1 downto 0);
  type array_12    is array (natural range <>) of std_logic_vector(  12-1 downto 0);
  type array_16    is array (natural range <>) of std_logic_vector(  16-1 downto 0);
  type array_20    is array (natural range <>) of std_logic_vector(  20-1 downto 0);

end array_pck;

package body array_pck is

end package body array_pck;
