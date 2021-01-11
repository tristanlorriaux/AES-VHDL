-- keyexpansion_I_O_tb.vhd
-- test bench de keyexpansion_I_O
-- Tristan LORRIAUX 24/12/2020 #Joyeux Noël

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity keyexpansion_I_O_tb is
end keyexpansion_I_O_tb;

architecture keyexpansion_I_O_tb_arch of keyexpansion_I_O_tb is

    component keyexpansion_I_O is
        port (key_i_IO		  : in	bit128;
          clock_i_IO	  : in	std_logic;
          reset_i_IO	  : in	std_logic;
          start_i_IO	  : in	std_logic;
          expansion_key_o_IO : out bit128);
    end component keyexpansion_I_O;

    signal key_i_IO_s		  : 	bit128;
    signal clock_i_IO_s	  : 	std_logic := '0';
    signal reset_i_IO_s	  : 	std_logic := '0';
    signal start_i_IO_s	  : 	std_logic := '0';
    signal expansion_key_o_IO_s : bit128;

    begin 
    DUT : keyexpansion_I_O port map(
        key_i_IO => key_i_IO_s,
        clock_i_IO => clock_i_IO_s,
        reset_i_IO => reset_i_IO_s,
        start_i_IO => start_i_IO_s,
        expansion_key_o_IO => expansion_key_o_IO_s
    );

    --stimulis
    clock_i_IO_s <= not clock_i_IO_s after 50 ns;
    reset_i_IO_s <= '1' after 50 ns;
    start_i_IO_s <= '1' after 25 ns;
    key_i_IO_s <= x"2b7e151628aed2a6abf7158809cf4f3c";

      

end keyexpansion_I_O_tb_arch;


configuration keyexpansion_I_O_tb_conf of keyexpansion_I_O_tb is
    for keyexpansion_I_O_tb_arch
        for DUT : keyexpansion_I_O
            use configuration LIB_RTL.keyexpansion_I_O_conf;
        end for ;
    end for ;
end keyexpansion_I_O_tb_conf;