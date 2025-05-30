--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: 
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-

-- created by   :   RD Jordan
-- test bench for 4 parallel NAND gates

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nand4_tb is
end entity;

architecture behavioral of nand4_tb is
    -- test inputs
    signal a: std_logic_vector(3 downto 0) := (others => '0');
    signal b: std_logic_vector(3 downto 0) := (others => '0');

    -- test output
    signal y: std_logic_vector(3 downto 0);

    -- instantiate the NAND gates
    component nand4 is
        port (
            a: in std_logic_vector(3 downto 0);  -- first inputs
            b: in std_logic_vector(3 downto 0);  -- second inputs
            y: out std_logic_vector(3 downto 0)  -- outputs
        );
    end component;

begin
    -- instantiate the NAND gates
    UUT: nand4
        port map (
            a => a,
            b => b,
            y => y
        );

    -- test stimulus process
    stim_proc: process
    begin
        -- set the input signals and wait for the output to be stable
        a <= "0000";
        b <= "0000";
        wait for 10 ns;

        -- set the input signals and wait for the output to be stable
        a <= "1111";
        b <= "1111";
        wait for 10 ns;

        -- set the input signals and wait for the output to be stable
        a <= "1010";
        b <= "0101";
        wait for 10 ns;

        -- set the input signals and wait for the output to be stable
        a <= "0101";
        b <= "1010";
        wait for 10 ns;

        -- end the test
        wait;
    end process;
end architecture;
