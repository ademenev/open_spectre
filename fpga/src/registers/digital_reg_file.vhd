
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: 
-- created by   :   RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- OPEN SPECTRE REGISTER FILE
-- Sources: https://www.dte.us.es/docencia/master/micr/dapa/modulos-de-laboratorio/ficheros-modulo-1e/lab4mod1ev1-1_e.pdf
-- https://www.edaboard.com/threads/vhdl-cpu-register-file-help.304421/
-- https://forum.digilent.com/topic/8777-feedback-on-a-register-file-design/page/3/
-- current method is too manual can i use somthing , like this and loops to avoid writing each reg all the time? https://github.com/ChristianPalmiero/Windowed-Register-File/blob/master/Simple%20register%20file/Design/register_file.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity digital_reg_file is
  generic (
    reg_version_id : std_logic_vector(7 downto 0) := x"00";
    data_width     : integer                      := 32
  );
  port (
    -- CPU interface
    regs_clk     : in std_logic;
    regs_rst     : in std_logic;
    regs_en      : in std_logic;
    regs_wen     : in std_logic_vector(3 downto 0);
    regs_addr    : in std_logic_vector(12 downto 0);
    regs_wr_data : in std_logic_vector(data_width - 1 downto 0);
    regs_rd_data : out std_logic_vector(data_width - 1 downto 0);
    --- Sniffer interface
    read_sniiffer  : in std_logic;
    sniff_rom_addr : in std_logic_vector(7 downto 0) := (others => '0');
    sniff_rom_data : out std_logic_vector(63 downto 0);
    -- Hardware Interface
    --- Rotery encoder input registers
    Rotery_addr_mux : out std_logic_vector(3 downto 0); -- this address tells the rotery encoders which part of the register to write to, think of it like pages on a midi controller. (no processor state memory requiered)
    Rotery_enc_0    : in std_logic_vector(31 downto 0);
    Rotery_enc_1    : in std_logic_vector(31 downto 0);
    Rotery_enc_2    : in std_logic_vector(31 downto 0);
    Rotery_enc_3    : in std_logic_vector(31 downto 0);
    Rotery_enc_4    : in std_logic_vector(31 downto 0);
    -- Rotery encoder preset registers (used to set envoder values from the CPU)
    Rotery_enc_preset_w : out std_logic; -- write values to rotery encoder regs.
    Rotery_enc_0_preset : out std_logic_vector(31 downto 0);
    Rotery_enc_1_preset : out std_logic_vector(31 downto 0);
    Rotery_enc_2_preset : out std_logic_vector(31 downto 0);
    Rotery_enc_3_preset : out std_logic_vector(31 downto 0);
    Rotery_enc_4_preset : out std_logic_vector(31 downto 0);
    button_matrix       : in std_logic_vector(31 downto 0);
    -- Leds out
    led_output     : out std_logic_vector(31 downto 0); -- leds shifted out via shift reg to front pannel leds, so no pwm per led.
    led_global_pwm : out std_logic_vector(31 downto 0); -- global pwm mosfet for led brighness?
    lcd_backligh   : out std_logic; -- change to temp input, no longer an LCD or if thewre is it will always be on

    -- Fan Interface
    fan_pwm : out std_logic_vector(31 downto 0); --reference for FAN controller https://github.com/VLSI-EDA/PoC/blob/master/src/io/io_FanControl.vhdl
    fan_rpm : in std_logic_vector(31 downto 0);

    -- Pinmatrix
    matrix_out_addr : out std_logic_vector(5 downto 0);
    matrix_mask_out : out std_logic_vector(63 downto 0); -- the pin settings for a single oputput
    matrix_load     : out std_logic;
    invert_matrix   : out std_logic_vector(63 downto 0); -- inverts matrix inputs before they go into the 'patch pannel'
    -- Comparitor
    vid_span : out std_logic_vector(7 downto 0);
    --Analoge Matrix
    out_addr       : out std_logic_vector(7 downto 0);
    ch_addr        : out std_logic_vector(7 downto 0);
    gain_in        : out std_logic_vector(4 downto 0); -- this is curently disabled due to talk of DSP, need to look at pipilining this
    anna_matrix_wr : out std_logic;
    --Shape Gen 1 & 2
    --GEN 1
    pos_h_1   : out std_logic_vector(11 downto 0);
    pos_v_1   : out std_logic_vector(11 downto 0);
    zoom_h_1  : out std_logic_vector(11 downto 0);
    zoom_v_1  : out std_logic_vector(11 downto 0);
    circle_1  : out std_logic_vector(11 downto 0);
    gear_1    : out std_logic_vector(11 downto 0);
    lantern_1 : out std_logic_vector(11 downto 0);
    fizz_1    : out std_logic_vector(11 downto 0);
    --GEN 2
    pos_h_2   : out std_logic_vector(11 downto 0);
    pos_v_2   : out std_logic_vector(11 downto 0);
    zoom_h_2  : out std_logic_vector(11 downto 0);
    zoom_v_2  : out std_logic_vector(11 downto 0);
    circle_2  : out std_logic_vector(11 downto 0);
    gear_2    : out std_logic_vector(11 downto 0);
    lantern_2 : out std_logic_vector(11 downto 0);
    fizz_2    : out std_logic_vector(11 downto 0);
    --Random Voltage generator
    noise_freq    : out std_logic_vector(9 downto 0);
    slew_in       : out std_logic_vector(2 downto 0);
    cycle_recycle : out std_logic;
    --Oscilators 1 and 2 
    sync_sel_osc1 : out std_logic_vector(1 downto 0);
    osc_1_freq    : out std_logic_vector(9 downto 0);
    osc_1_derv    : out std_logic_vector(9 downto 0);
    sync_sel_osc2 : out std_logic_vector(1 downto 0);
    osc_2_freq    : out std_logic_vector(9 downto 0);
    osc_2_derv    : out std_logic_vector(9 downto 0);
    --YCbCr output levels
    y_level        : out std_logic_vector(11 downto 0);
    cr_level       : out std_logic_vector(11 downto 0);
    cb_level       : out std_logic_vector(11 downto 0);
    video_active_O : out std_logic;

    -- debug
    debug            : out std_logic_vector(127 downto 0);
    exception_addr_o : out std_logic

  );
end entity digital_reg_file;

architecture RTL of digital_reg_file is

  type regs32 is array (natural range <>) of std_logic_vector(31 downto 0);
  signal regs : regs32(63 downto 0)
  := (others => (others => '0'));

  -- Function for converting byte adresses to an index
  -- into the 32 bit register array.
  -- Conversion from std_vect to nateral/int https://nandland.com/common-vhdl-conversions/#Arith-Std_Logic_Vector-To-Integer
  function ra (
    byte_addr : std_logic_vector(12 downto 0) -- take full 12 bit address
  ) return natural is
    variable ret : natural;
  begin
    ret := to_integer(unsigned(byte_addr(12 downto 2))); -- drop the last 2 bits so that the address is correctly allighend , then get an index from it
    return ret;
  end ra;

  --cpu interface
  signal addr_reg  : std_logic_vector(12 downto 0);
  signal read_reg  : std_logic_vector(32 downto 0);
  signal write_reg : std_logic_vector(31 downto 0);
  signal write_en  : std_logic;
  --sniffer interface
  signal digital_matrix_data : std_logic_vector(63 downto 0);
  --Hardware interface
  signal Rotery_addr_mux_i : std_logic_vector(3 downto 0); -- this address tells the rotery encoders which part of the register to write to, think of it like pages on a midi controller. (no processor state memory requiered)
  -- Rotery encoder preset registers (used to set envoder values from the CPU)
  signal Rotery_enc_preset_w_i : std_logic; -- write values to rotery encoder regs.
  signal Rotery_enc_0_preset_i : std_logic_vector(31 downto 0);
  signal Rotery_enc_1_preset_i : std_logic_vector(31 downto 0);
  signal Rotery_enc_2_preset_i : std_logic_vector(31 downto 0);
  signal Rotery_enc_3_preset_i : std_logic_vector(31 downto 0);
  signal Rotery_enc_4_preset_i : std_logic_vector(31 downto 0);

  -- Leds
  signal led_output_i     : std_logic_vector(31 downto 0); -- leds shifted via shift reg to front pannel leds, so no pwm per led.
  signal led_global_pwm_i : std_logic_vector(31 downto 0); -- global pwm mosfet for led brighness?
  signal lcd_backligh_i   : std_logic;

  -- Fan Interface
  signal fan_pwm_i : std_logic_vector(31 downto 0);
  --digital side
  signal matrix_out_addr_int : std_logic_vector(5 downto 0);
  signal matrix_load_int     : std_logic;
  signal mask_lower          : std_logic_vector(31 downto 0);
  signal mask_upper          : std_logic_vector(31 downto 0);
  signal inv_lower           : std_logic_vector(31 downto 0);
  signal inv_upper           : std_logic_vector(31 downto 0);
  signal vid_span_int        : std_logic_vector(7 downto 0);
  -- analoge side
  signal out_addr_int       : std_logic_vector(7 downto 0);
  signal ch_addr_int        : std_logic_vector(7 downto 0);
  signal gain_in_int        : std_logic_vector(4 downto 0);
  signal anna_matrix_wr_int : std_logic;

  --Shape gen 1 & 2
  signal pos_h_i_1   : std_logic_vector(11 downto 0);
  signal pos_v_i_1   : std_logic_vector(11 downto 0);
  signal zoom_h_i_1  : std_logic_vector(11 downto 0);
  signal zoom_v_i_1  : std_logic_vector(11 downto 0);
  signal circle_i_1  : std_logic_vector(11 downto 0);
  signal gear_i_1    : std_logic_vector(11 downto 0);
  signal lantern_i_1 : std_logic_vector(11 downto 0);
  signal fizz_i_1    : std_logic_vector(11 downto 0);
  signal pos_h_i_2   : std_logic_vector(11 downto 0);
  signal pos_v_i_2   : std_logic_vector(11 downto 0);
  signal zoom_h_i_2  : std_logic_vector(11 downto 0);
  signal zoom_v_i_2  : std_logic_vector(11 downto 0);
  signal circle_i_2  : std_logic_vector(11 downto 0);
  signal gear_i_2    : std_logic_vector(11 downto 0);
  signal lantern_i_2 : std_logic_vector(11 downto 0);
  signal fizz_i_2    : std_logic_vector(11 downto 0);
  -- noise gen
  signal noise_freq_i    : std_logic_vector(9 downto 0);
  signal slew_in_i       : std_logic_vector(2 downto 0);
  signal cycle_recycle_i : std_logic;
  --osc 
  signal sync_sel_osc1_i : std_logic_vector(1 downto 0);
  signal osc_1_freq_i    : std_logic_vector(9 downto 0);
  signal osc_1_derv_i    : std_logic_vector(9 downto 0);
  signal sync_sel_osc2_i : std_logic_vector(1 downto 0);
  signal osc_2_freq_i    : std_logic_vector(9 downto 0);
  signal osc_2_derv_i    : std_logic_vector(9 downto 0);

  -- color output levels
  signal y_level_i      : std_logic_vector(11 downto 0);
  signal cr_level_i     : std_logic_vector(11 downto 0);
  signal cb_level_i     : std_logic_vector(11 downto 0);
  signal video_active   : std_logic;
  signal exception_addr : std_logic; -- toggles on address out of range error for reg file -- need better solution with reset + exception for sniffer

begin

  ---------------------------------------------------------------------------
  -- Register reads for sniffer
  ---------------------------------------------------------------------------
  --  process (regs_clk)
  --  begin
  --    if rising_edge(regs_clk) then
  --      if regs_en = '0' then
  --        read_reg <= x"00000000" & '0';
  --      else
  --        read_reg <= regs(ra(regs_addr));
  --      end if;
  --    end if;
  --  end process;

  --  regs_rd_data <= read_reg;

  ---------------------------------------------------------------------------
  -- READ: Pass external signals into the read reg array
  ---------------------------------------------------------------------------
  -- outgoing, so inputs to this block from the outside
  regs(ra(x"00")) <= x"000000" & fpga_rev_id; -- read only reg with the FPGA build number

  -- digital side
  regs(ra(x"04")) <= x"000000" & "00" & matrix_out_addr_int; -- this is the matrix output
  regs(ra(x"08")) <= x"000000" & "0000000" & matrix_load_int; -- load flag
  regs(ra(x"10")) <= mask_lower;
  regs(ra(x"14")) <= mask_upper;
  -- regs(ra(x"18")) <= xxxxxxxxxxxx; saved for future matrix expantion
  regs(ra(x"1C")) <= inv_lower; -- inverts the matrix inputs, lower 32
  regs(ra(x"20")) <= inv_upper; -- inverts the matrix inputs, upper 32
  regs(ra(x"24")) <= x"000000" & vid_span_int;

  -- analoge side matrix
  regs(ra(x"28")) <= x"000000" & out_addr_int;
  regs(ra(x"2C")) <= x"000000" & ch_addr_int;
  regs(ra(x"30")) <= x"000000" & "000" & gain_in_int;
  regs(ra(x"34")) <= x"000000" & "0000000" & anna_matrix_wr_int;

  -- shape gen 1 & 2
  regs(ra(x"3C")) <= x"00" & pos_h_i_2 & pos_h_i_1;
  regs(ra(x"40")) <= x"00" & pos_v_i_2 & pos_v_i_1;
  regs(ra(x"44")) <= x"00" & zoom_h_i_2 & zoom_h_i_1;
  regs(ra(x"48")) <= x"00" & zoom_v_i_2 & zoom_v_i_1;
  regs(ra(x"4C")) <= x"00" & circle_i_2 & circle_i_1;
  regs(ra(x"50")) <= x"00" & gear_i_2 & gear_i_1;
  regs(ra(x"54")) <= x"00" & lantern_i_2 & lantern_i_1;
  regs(ra(x"5C")) <= x"00" & fizz_i_2 & fizz_i_1;

  -- random gen
  regs(ra(x"60")) <= x"0000" & "00" & '0' & slew_in_i & noise_freq_i;
  regs(ra(x"64")) <= x"000000" & "0000000" & cycle_recycle_i; -- put this back into the register above at some point

  -- OSC 1&2
  regs(ra(x"68")) <= x"00" & "00" & sync_sel_osc1_i & osc_1_derv_i & osc_1_freq_i;
  regs(ra(x"6C")) <= x"00" & "00" & sync_sel_osc2_i & osc_2_derv_i & osc_2_freq_i;

  -- output y,cr,cb levels
  regs(ra(x"70")) <= x"00" & cr_level_i & y_level_i;
  regs(ra(x"74")) <= x"00000" & cb_level_i;
  regs(ra(x"78")) <= x"000000" & "0000000" & video_active;

  -- hardware interface
  regs(ra(x"7C")) <= 0x"0000000" & Rotery_addr_mux_i;
  regs(ra(x"80")) <= Rotery_enc_0; -- read only
  regs(ra(x"84")) <= Rotery_enc_1; -- read only
  regs(ra(x"88")) <= Rotery_enc_2; -- read only
  regs(ra(x"8C")) <= Rotery_enc_3; -- read only
  regs(ra(x"90")) <= Rotery_enc_4; -- read only
  regs(ra(x"94")) <= 0x"0000000" & "000" & Rotery_enc_preset_w_i;
  regs(ra(x"98")) <= Rotery_enc_0_preset_i;
  regs(ra(x"9C")) <= Rotery_enc_1_preset_i;
  regs(ra(x"A0")) <= Rotery_enc_2_preset_i;
  regs(ra(x"A4")) <= Rotery_enc_3_preset_i;
  regs(ra(x"A8")) <= Rotery_enc_4_preset_i;
  regs(ra(x"AC")) <= led_output_i;
  regs(ra(x"B0")) <= led_global_pwm_i;
  regs(ra(x"B4")) <= 0x"0000000" & "000" & lcd_backligh_i;
  regs(ra(x"B8")) <= fan_pwm_i;
  regs(ra(x"BC")) <= fan_rpm; -- read only
  regs(ra(x"C0")) <= button_matrix; -- read only

  -- other
  regs(ra(x"C4")) <= x"DEADBEEF"; --test reg 1

  ---------------------------------------------------------------------------
  -- Register writes
  ---------------------------------------------------------------------------
  process (regs_clk)
  begin
    if rising_edge(regs_clk) then
      addr_reg  <= regs_addr;
      write_reg <= regs_wr_data;
      write_en  <= '0';
      if (regs_en = '1' and regs_wen(0) = '1') then
        write_en <= '1';
      end if;
    end if;
  end process;
  -- ---------------------------------------------------------------------------
  -- WRITE: Get the data from the incoming write port and pass it to the internal signal for each reg
  ---------------------------------------------------------------------------
  process (regs_clk)
  begin
    if rising_edge(regs_clk) then
      if (write_en = '1') then
        case addr_reg(7 downto 0) is
          when x"04" =>
            matrix_out_addr_int <= write_reg(5 downto 0);
          when x"08" =>
            matrix_load_int <= write_reg(0);
          when x"10" =>
            mask_lower <= write_reg;
          when x"14" =>
            mask_upper <= write_reg;
          when x"1C" =>
            inv_lower <= write_reg;
          when x"20" =>
            inv_lower <= write_reg;
          when x"24" =>
            vid_span_int <= write_reg(7 downto 0);
          when x"28" =>
            out_addr_int <= write_reg(7 downto 0);
          when x"2C" =>
            ch_addr_int <= write_reg(7 downto 0);
          when x"30" =>
            gain_in_int <= write_reg(4 downto 0);
          when x"34" =>
            anna_matrix_wr_int <= write_reg(0);
          when x"38" =>
            pos_h_i_1 <= write_reg(11 downto 0);
            pos_h_i_2 <= write_reg(23 downto 12);
          when x"3C" =>
            pos_v_i_1 <= write_reg(11 downto 0);
            pos_v_i_2 <= write_reg(23 downto 12);
          when x"40" =>
            pos_h_i_1 <= write_reg(11 downto 0);
            pos_h_i_2 <= write_reg(23 downto 12);
          when x"44" =>
            zoom_h_i_1 <= write_reg(11 downto 0);
            zoom_h_i_2 <= write_reg(23 downto 12);
          when x"48" =>
            zoom_v_i_1 <= write_reg(11 downto 0);
            zoom_v_i_2 <= write_reg(23 downto 12);
          when x"4C" =>
            circle_i_1 <= write_reg(11 downto 0);
            circle_i_2 <= write_reg(23 downto 12);
          when x"50" =>
            gear_i_1 <= write_reg(11 downto 0);
            gear_i_2 <= write_reg(23 downto 12);
          when x"54" =>
            lantern_i_1 <= write_reg(11 downto 0);
            lantern_i_2 <= write_reg(23 downto 12);
          when x"58" =>
            fizz_i_1 <= write_reg(11 downto 0);
            fizz_i_2 <= write_reg(23 downto 12);
          when x"60" =>
            noise_freq_i <= write_reg(9 downto 0);
            slew_in_i    <= write_reg(12 downto 10);
            --            cycle_recycle_i <= write_reg(13);
          when x"64" =>
            cycle_recycle_i <= write_reg(0);
          when x"68" =>
            sync_sel_osc1_i <= write_reg(21 downto 20);
            osc_1_derv_i    <= write_reg(19 downto 10);
            osc_1_freq_i    <= write_reg(9 downto 0);
          when x"6C" =>
            sync_sel_osc2_i <= write_reg(21 downto 20);
            osc_2_derv_i    <= write_reg(19 downto 10);
            osc_2_freq_i    <= write_reg(9 downto 0);

          when x"70" =>
            y_level_i  <= write_reg(11 downto 0);
            cr_level_i <= write_reg(23 downto 12);
          when x"74" =>
            cb_level_i <= write_reg(11 downto 0);
          when x"78" =>
            video_active <= write_reg(0);

          when x"7C" =>
            Rotery_addr_mux_i <= write_reg(3 downto 0);
            -- Note the Gap in addresses for the read only Rot encoders?
          when x"94" =>
            Rotery_enc_preset_w_i <= write_reg(0);
          when x"98" =>
            Rotery_enc_0_preset_i <= write_reg;
          when x"9C" =>
            Rotery_enc_1_preset_i <= write_reg;
          when x"A0" =>
            Rotery_enc_2_preset_i <= write_reg;
          when x"A4" =>
            Rotery_enc_3_preset_i <= write_reg;
          when x"A8" =>
            Rotery_enc_4_preset_i <= write_reg;
          when x"AC" =>
            led_output_i <= write_reg;
          when x"B0" =>
            led_global_pwm_i <= write_reg;
          when x"B4" =>
            lcd_backligh_i <= write_reg(0);
          when x"B8" =>
            fan_pwm_i <= write_reg;

          when others =>
            exception_addr <= not exception_addr;

            -- do nothing
        end case;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Sniffer: reads analoge and digital martix writes and stores them to me read back later by processor
  -----------------------------------------------------------------------------
  digital_matrix_data <= mask_upper & mask_lower;

  dirty_dog_i : entity work.reg_sniffer
    port map
    (
      clk             => regs_clk,
      rst             => regs_rst,
      read_ram        => read_sniiffer,
      read_address    => sniff_rom_addr,
      ram_data_out    => sniff_rom_data,
      matrix_out_addr => matrix_out_addr_int,
      matrix_mask_out => digital_matrix_data, -- the pin settings for a single oputput
      matrix_load     => matrix_load_int,
      out_addr        => out_addr_int,
      ch_addr         => ch_addr_int,
      gain_in         => gain_in_int,
      anna_matrix_wr  => anna_matrix_wr_int
    );
  ---------------------------------------------------------------------------
  -- Output: pass registers with outputs to the out port
  ---------------------------------------------------------------------------
  matrix_out_addr <= matrix_out_addr_int;
  matrix_load     <= matrix_load_int;
  matrix_mask_out <= mask_upper & mask_lower;
  invert_matrix   <= inv_upper & inv_lower;
  vid_span        <= vid_span_int;
  out_addr        <= out_addr_int;
  ch_addr         <= ch_addr_int;
  gain_in         <= gain_in_int;

  anna_matrix_wr <= anna_matrix_wr_int;

  pos_h_1   <= pos_h_i_1;
  pos_v_1   <= pos_v_i_1;
  zoom_h_1  <= zoom_h_i_1;
  zoom_v_1  <= zoom_v_i_1;
  circle_1  <= circle_i_1;
  gear_1    <= gear_i_1;
  lantern_1 <= lantern_i_1;
  fizz_1    <= fizz_i_1;

  pos_h_2   <= pos_h_i_2;
  pos_v_2   <= pos_v_i_2;
  zoom_h_2  <= zoom_h_i_2;
  zoom_v_2  <= zoom_v_i_2;
  circle_2  <= circle_i_2;
  gear_2    <= gear_i_2;
  lantern_2 <= lantern_i_2;
  fizz_2    <= fizz_i_2;

  noise_freq    <= noise_freq_i;
  slew_in       <= slew_in_i;
  cycle_recycle <= cycle_recycle_i;

  sync_sel_osc1 <= sync_sel_osc1_i;
  osc_1_freq    <= osc_1_freq_i;
  osc_1_derv    <= osc_1_derv_i;
  sync_sel_osc2 <= sync_sel_osc2_i;
  osc_2_freq    <= osc_2_freq_i;
  osc_2_derv    <= osc_2_derv_i;

  y_level  <= y_level_i;
  cr_level <= cr_level_i;
  cb_level <= cb_level_i;

  video_active_O <= video_active;

  Rotery_addr_mux     <= Rotery_addr_mux_i;
  Rotery_enc_preset_w <= Rotery_enc_preset_w_i;
  Rotery_enc_0_preset <= Rotery_enc_0_preset_i;
  Rotery_enc_1_preset <= Rotery_enc_1_preset_i;
  Rotery_enc_2_preset <= Rotery_enc_2_preset_i;
  Rotery_enc_3_preset <= Rotery_enc_3_preset_i;
  Rotery_enc_4_preset <= Rotery_enc_4_preset_i;
  led_output          <= led_output_i;
  led_global_pwm      <= led_global_pwm_i;
  lcd_backligh        <= lcd_backligh_i;
  fan_pwm             <= fan_pwm_i;

end RTL;
