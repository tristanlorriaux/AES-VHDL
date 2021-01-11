-- sbox_tbvhd
-- test bench du SBOX
-- Tristan LORRIAUX 27/11/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity sbox_tb is
end sbox_tb;

architecture sbox_tb_arch of sbox_tb is

    component SBOX is
    port(SBOX_i : in bit8;
         SBOX_o : out bit8);
    end component;

    signal SBOX_i_s, SBOX_o_s : bit8;

begin
    DUT : SBOX port map(
        SBOX_i  => SBOX_i_s,
        SBOX_o => SBOX_o_s
    );
    SBOX_i_s <= X"00", X"63" after 25 ns;

end sbox_tb_arch ; -- arch

configuration sbox_tb_conf of sbox_tb is
    for sbox_tb_arch
        for DUT : SBOX
            use entity LIB_RTL.SBOX(SBOX_arch);
        end for;
    end for;
end sbox_tb_conf;
