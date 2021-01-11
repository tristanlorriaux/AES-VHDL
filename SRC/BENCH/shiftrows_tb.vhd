-- shiftrow_tb.vhd
-- test bench du shiftrows
-- Tristan LORRIAUX 04/12/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity shiftrows_tb is
end shiftrows_tb;

architecture shiftrows_tb_arch of shiftrows_tb is

    component shiftrows is
        port ( 
            data_i  : in  type_state;
            data_o  : out  type_state
        );
    end component;

    signal data_i_s, data_o_s : type_state;
    signal test_ok_s : type_state;
    signal pass_fail_s : std_logic;

begin
    DUT : shiftrows port map(
        data_i => data_i_s,
        data_o => data_o_s
    );
    data_i_s <= ( (x"9f", x"4c", x"a6", x"f8"),        
                (x"d7", x"19", x"81", x"ac"),
                (x"07", x"c8", x"10", x"a8"),
                (x"aa", x"dd", x"8e", x"7b"));

    test_ok_s <= ( (x"9f", x"4c", x"a6", x"f8"),        
                (x"19", x"81", x"ac", x"d7"),
                (x"10", x"a8", x"07", x"c8"),
                (x"7b", x"aa", x"dd", x"8e"));

    pass_fail_s<= '1' when data_o_s = test_ok_s else '0';

end shiftrows_tb_arch ; -- arch

configuration shiftrows_tb_conf of shiftrows_tb is
    for shiftrows_tb_arch
        for DUT : shiftrows
            use entity LIB_RTL.shiftrows(shiftrows_arch);
        end for;
    end for;
end shiftrows_tb_conf;
