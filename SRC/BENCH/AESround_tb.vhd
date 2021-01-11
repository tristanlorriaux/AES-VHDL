-- mix_columns_elem_tb.vhd
-- test bench de AESround
-- Tristan LORRIAUX 15/12/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity AESround_tb is
end AESround_tb;

architecture AESround_tb_arch of AESround_tb is
    component AESround
    port(
        text_i			: in  bit128;
        currentkey_i		: in  bit128;
        data_o			: out bit128;
        clock_i		: in  std_logic;
        resetb_i		: in  std_logic;
        enableMixcolumns_i	: in  std_logic;
        enableRoundcomputing_i : in  std_logic);
    end component;
    

    signal text_i_s : bit128;
    signal currentkey_i_s : bit128;
    signal data_o_s	: bit128;
    
    signal resetb_i_s, enableMixcolumns_i_s, enableRoundcomputing_i_s : std_logic;
    signal clock_i_s : std_logic := '0';
    
    begin
        DUT : AESround port map(
            text_i => text_i_s,
            data_o => data_o_s,
            currentkey_i => currentkey_i_s,
            clock_i	=> clock_i_s,
            resetb_i =>	resetb_i_s,
            enableMixcolumns_i => enableMixcolumns_i_s,
            enableRoundcomputing_i => enableRoundcomputing_i_s
        );
        text_i_s <= x"45732d747520636f6e66696ee865203f";
    
        currentkey_i_s <= x"2b7e151628aed2a6abf7158809cf4f3c";
        
        --attendu en sortie : x"c5 1c d5 52 8a 48 4f 03 41 92 41 c2 e5 ec 5b 0e"
        
        -- stimulii
        clock_i_s <= not(clock_i_s) after 50 ns; -- clock de période : 20 ns

        resetb_i_s <='0','1' after 10 ns; -- activation

        enableRoundcomputing_i_s <='0', '1' after 100 ns;

        enableMixcolumns_i_s <='1'; -- 
        
    end AESround_tb_arch;


configuration AESround_tb_conf of AESround_tb is
    for AESround_tb_arch
        for DUT : AESround
            use configuration LIB_RTL.AESround_conf;
        end for ;
    end for ;
end AESround_tb_conf;