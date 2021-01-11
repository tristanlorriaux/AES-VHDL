library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AES is
  port(clock_i	: in  std_logic;
       reset_i	: in  std_logic;
       start_i	: in  std_logic;
       key_i	: in  bit128;
       data_i	: in  bit128;
       data_o	: out bit128;
       aes_on_o : out std_logic);
end entity AES;

architecture AES_arch of AES is

  component keyexpansion_I_O
    port (key_i_IO		  : in	bit128;
	  clock_i_IO	  : in	std_logic;
	  reset_i_IO	  : in	std_logic;
	  start_i_IO  : in	std_logic;
	  expansion_key_o_IO : out bit128);

  end component;
  component Counter is
    port (
      reset_i  : in  std_logic;
      enable_i : in  std_logic;
      clock_i  : in  std_logic;
      count_o  : out bit4);
  end component Counter;

  component FSM_AES
    port (resetb_i		 : in  std_logic;
	  clock_i		 : in  std_logic;
	  start_i		 : in  std_logic;
	  reset_key_expander_o	 : out std_logic;
	  start_key_expander_o	 : out std_logic;
	  counter_aes_i		 : in  bit4;
	  reset_counter_aes_o	 : out std_logic;
	  enable_counter_aes_o	 : out std_logic;
	  enableMixcolumns_o	 : out std_logic;
	  enableRoundcomputing_o : out std_logic;
	  enableOutput_o	 : out std_logic;
	  done_o		 : out std_logic);
  end component;

  component AESRound
    port(text_i			: in  bit128;
	 currentkey_i		: in  bit128;
	 data_o			: out bit128;
	 clock_i		: in  std_logic;
	 resetb_i		: in  std_logic;
	 enableMixcolumns_i	: in  std_logic;
	 enableRoundcomputing_i : in  std_logic);
  end component;

  signal resetb_s	     : std_logic;
  signal reset_keyexpander_s : std_logic;
  signal start_keyexpander_s : std_logic;

  signal counter_aes_s	      : bit4;
  signal reset_counter_aes_s  : std_logic;
  signal enable_counter_aes_s : std_logic;

  signal data_s			: bit128;
  signal outputKeyExpander_s	: bit128;
  signal enableMixcolumns_s	: std_logic;
  signal enableRoundcomputing_s : std_logic;

  signal enableOutput_s : std_logic;

begin
  -- positive reset
  resetb_s <= not reset_i;

  -- key expander_I_O component
  U0 : keyexpansion_I_O
    port map(key_i_IO	     => key_i,
	     clock_i_IO	     => clock_i,
	     reset_i_IO	     => reset_keyexpander_s,
	     start_i_IO	     => start_keyexpander_s,
	     expansion_key_o_IO => outputKeyExpander_s);

  U1 : FSM_AES
    port map(
      resetb_i		     => resetb_s,
      clock_i		     => clock_i,
      start_i		     => start_i,
      reset_key_expander_o   => reset_keyexpander_s,
      start_key_expander_o   => start_keyexpander_s,
      counter_aes_i	     => counter_aes_s,
      reset_counter_aes_o    => reset_counter_aes_s,
      enable_counter_aes_o   => enable_counter_aes_s,
      enableMixcolumns_o     => enableMixColumns_s,
      enableRoundComputing_o => enableRoundComputing_s,
      enableOutput_o	     => enableOutput_s,
      done_o		     => aes_on_o);

  Counter_1 : Counter
    port map (
      reset_i  => reset_counter_aes_s,
      enable_i => enable_counter_aes_s,
      clock_i  => clock_i,
      count_o  => counter_aes_s);

  U2 : AESround
    port map(
      text_i		     => data_i,
      currentkey_i	     => outputKeyExpander_s,
      data_o		     => data_s,
      clock_i		     => clock_i,
      resetb_i		     => resetb_s,
      enableMixcolumns_i     => enableMixColumns_s,
      enableRoundcomputing_i => enableRoundComputing_s);

  data_o <= data_s when enableOutput_s = '1' else (others => 'Z');

end architecture AES_arch;


configuration AES_conf of AES is
  for aes_arch
      for U0 : keyexpansion_I_O
          use configuration LIB_RTL.keyexpansion_I_O_conf;
      end for;
      for U1 : FSM_AES
          use entity LIB_RTL.FSM_AES(FSM_AES_arch);
      end for;
      for U2 : AESround
          use configuration LIB_RTL.AESround_conf;
      end for;
      for Counter_1 : Counter
          use entity LIB_RTL.counter(counter_arch);
      end for;
  end for;
end configuration AES_conf;
