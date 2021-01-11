-- keyexpansion_tb.vhd
-- test bench de keyexpansion
-- Tristan LORRIAUX 15/12/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity keyexpansion_tb is
end keyexpansion_tb;

architecture keyexpansion_tb_arch of keyexpansion_tb is
    component keyexpansion
    port(
        key_i		  : in	bit128;
        rcon_i            : in bit8;
        expansion_key_o : out bit128);
    end component;
    

    signal key_i_s : bit128;
    signal rcon_i_s : bit8;
    signal expansion_key_o_s	: bit128;
        
    begin
        DUT : keyexpansion port map(
            key_i => key_i_s,
            rcon_i => rcon_i_s,
            expansion_key_o => expansion_key_o_s
        );

        --stimulis
        rcon_i_s <= X"01";
        key_i_s <=  x"2b7e151628aed2a6abf7158809cf4f3c";
    
        --sortie attendue : expansion_key_o_s = x"a0 fa fe 17 88 54 2c b1 23 a3 39 39 2a 6c 76 05";  

    end keyexpansion_tb_arch;


configuration keyexpansion_tb_conf of keyexpansion_tb is
    for keyexpansion_tb_arch
        for DUT : keyexpansion
            use configuration LIB_RTL.keyexpansion_conf;
        end for ;
    end for ;
end keyexpansion_tb_conf;