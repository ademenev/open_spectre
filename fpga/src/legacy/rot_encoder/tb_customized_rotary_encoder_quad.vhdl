--This si a TEST bench???!

library ieee;
use ieee.std_logic_1164.all;

entity tb_customized_rotary_encoder_quad is
end entity tb_customized_rotary_encoder_quad;

architecture testbench of tb_customized_rotary_encoder_quad is
  signal clk_tb        : std_logic := '0';
  signal swa_tb, swb_tb : std_logic := '0';
  signal rotary_event_tb : std_logic;
  signal rotary_dir_tb   : std_logic;
  signal data_out_tb     : std_logic_vector(15 downto 0);

  constant CLK_PERIOD   : time := 10 ns; -- Adjust as needed
  
  -- Instantiate the customized_rotary_encoder_quad module
  component customized_rotary_encoder_quad
    port (
      clk_i          : in  std_logic;
      swa_i          : in  std_logic;
      swb_i          : in  std_logic;
      rotary_event_o : out std_logic;
      rotary_dir_o   : out std_logic;
      data_out_o     : out std_logic_vector(15 downto 0)
    );
  end component;
  
 begin

  -- Clock generation process
  process
  begin
    while now < 1000 ns loop
      clk_tb <= not clk_tb;
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  process
  begin
    wait for CLK_PERIOD * 2; -- Initial stabilization

    -- Test with clockwise rotation
        swa_tb <= '0'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '1'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '1'; swb_tb <= '0';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '0';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '1'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '1'; swb_tb <= '0';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '0';
    wait for CLK_PERIOD;

    
        wait for CLK_PERIOD * 2; -- Initial stabilization
    
    -- Test with counter-clockwise rotation
        swa_tb <= '1'; swb_tb <= '0';
    wait for CLK_PERIOD;
       swa_tb <= '1'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '0';
    wait for CLK_PERIOD;
            swa_tb <= '1'; swb_tb <= '0';
    wait for CLK_PERIOD;
       swa_tb <= '1'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '1';
    wait for CLK_PERIOD;
        swa_tb <= '0'; swb_tb <= '0';
    wait for CLK_PERIOD;

    
    -- Test with valid event
    swa_tb <= '1'; swb_tb <= '1';
    wait for CLK_PERIOD;
    
    -- Additional test cases can be added here

    wait;
  end process;

  -- Instantiate the customized_rotary_encoder_quad module
  uut : customized_rotary_encoder_quad
    port map (
      clk_i          => clk_tb,
      swa_i          => swa_tb,
      swb_i          => swb_tb,
      rotary_event_o => rotary_event_tb,
      rotary_dir_o   => rotary_dir_tb,
      data_out_o     => data_out_tb
    );

end architecture testbench;
