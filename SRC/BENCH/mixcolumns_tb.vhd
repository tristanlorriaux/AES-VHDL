-- mix_columns_elem_tb.vhd
-- test bench du mixcolumns
-- Tristan LORRIAUX 07/12/2020

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity mixcolumns_tb is
end mixcolumns_tb;

architecture mixcolumns_tb_arch of mixcolumns_tb is

    component mixcolumns is
        port( 
            data_i: in type_state;
            enable_i: in std_logic;
            data_o: out type_state);
    end component mixcolumns;

    signal data_i_s, data_o_s : type_state;
    signal init_data_i_s : bit128 := X"afe601d5169106abce62d3b1bc4420ae";
    signal enable_s : std_logic := '1';
begin
    DUT : mixColumns
    port map(
        data_i => data_i_s,
        enable_i => enable_s,
        data_o => data_o_s
    );

    enable_s <= '1';

    G1 : for col in 0 to 3 generate
        G2 : for row in 0 to 3 generate
            data_i_s(row)(col) <= init_data_i_s(127 - 32 * col - 8 * row downto 120 - 32 * col - 8 * row);
        end generate;
    end generate;

end architecture mixcolumns_tb_arch;


configuration mixcolumns_tb_conf of mixcolumns_tb is
    for mixcolumns_tb_arch
        for DUT : mixcolumns 
            use configuration LIB_RTL.mixcolumns_conf;
        end for;
    end for;
end mixcolumns_tb_conf;
