-- mix_columns_elem_tb.vhd
-- test bench du colum_calculator
-- Tristan LORRIAUX 07/12/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity mix_columns_elem_tb is
end mix_columns_elem_tb;

architecture mix_columns_elem_tb_arch of mix_columns_elem_tb is

    component mixcolumns_elem is
        port ( 
            datae_i  : in  column_state;
            datae_o  : out  column_state
        );
    end component;

    signal datae_i_s, datae_o_s : column_state;
    signal test_ok_s : column_state;
    signal pass_fail_s : std_logic;

begin
    DUT : mixcolumns_elem port map(
        datae_i => datae_i_s,
        datae_o => datae_o_s
    );
    datae_i_s <= (x"9f", x"19", x"10", x"7b");

    test_ok_s <= (x"65", x"e6", x"2b", x"45");

    pass_fail_s<= '1' when datae_o_s = test_ok_s else '0';

end mix_columns_elem_tb_arch ; -- arch

configuration mix_columns_elem_tb_conf of mix_columns_elem_tb is
    for mix_columns_elem_tb_arch
        for DUT : mixcolumns_elem 
            use entity LIB_RTL.mixcolumns_elem(mixcolumns_elem_arch);
        end for;
    end for;
end mix_columns_elem_tb_conf;
