-- subbytes_tb.vhd
-- test bench du subbytes
-- Tristan LORRIAUX 04/12/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity subbytes_tb is
end subbytes_tb;

architecture subbytes_tb_arch of subbytes_tb is

    component subbytes is
        port ( 
            data_i  : in  type_state;
            data_o  : out  type_state
        );
    end component;

    signal data_i_s, data_o_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

begin
    DUT : subbytes port map(
        data_i => data_i_s,
        data_o => data_o_s
    );
    data_i_s <= ( (x"6e",  x"5d",  x"c5",  x"e1"),   
                (x"0d",  x"8e",  x"91",  x"aa"),
                (x"38", x"b1", x"7c",  x"6f"),
                (x"62", x"c9",  x"e6",  x"03"));

    test_ok_s <= ( (x"9f", x"4c", x"a6", x"f8"),        
                (x"d7", x"19", x"81", x"ac"),
                (x"07", x"c8", x"10", x"a8"),
                (x"aa", x"dd", x"8e", x"7b"));

    pass_fail_s<= '1' when data_o_s = test_ok_s else '0';

end subbytes_tb_arch ; -- arch

configuration subbytes_tb_conf of subbytes_tb is
    for subbytes_tb_arch
        for DUT : subbytes
            use entity LIB_RTL.subbytes(subbytes_arch);
        end for;
    end for;
end subbytes_tb_conf;
