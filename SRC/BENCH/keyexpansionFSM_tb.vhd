-- keyexpansionFSM_tb.vhd
-- test bench de keyexpansionFSM
-- Tristan LORRIAUX 15/12/2020

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity keyexpansionFSM_tb is
end keyexpansionFSM_tb;

architecture keyexpansionFSM_tb_arch of keyexpansionFSM_tb is

    component keyexpansionFSM
    port(
        start_i : in std_logic	;
        clock_i : in std_logic;
        counter_i : in bit4; 
        reset_i : in std_logic; 
        enable_o : out std_logic;
        reset_counter_o : out std_logic);
    end component;
    

    signal start_i_s :  std_logic;
    signal clock_i_s : std_logic := '0';
    signal counter_i_s :  bit4; 
    signal reset_i_s :  std_logic; 
    signal enable_o_s :  std_logic;
    signal reset_counter_o_s : std_logic;
        
    begin
        DUT : keyexpansionFSM port map(
            start_i => start_i_s,
            clock_i => clock_i_s ,
            counter_i => counter_i_s,
            reset_i => reset_i_s , 
            enable_o => enable_o_s,
            reset_counter_o=> reset_counter_o_s 
        );


        clock_i_s <= not(clock_i_s) after 10 ns;

        start_i_s <= '0',
            '1' after 90 ns,
            '0' after 300 ns;
        reset_i_s <= '0', '1' after 60 ns;

        -- compteur artificiel
        counter_i_s <=  X"0",
            X"1" after 100 ns,
            X"2" after 120 ns,
            X"3" after 140 ns,
            X"4" after 160 ns,
            X"5" after 180 ns,
            X"6" after 200 ns,
            X"7" after 220 ns,
            X"8" after 240 ns,
            X"9" after 260 ns;
            
    end keyexpansionFSM_tb_arch;


configuration keyexpansionFSM_tb_conf of keyexpansionFSM_tb is
    for keyexpansionFSM_tb_arch
        for DUT : keyexpansionFSM
            use entity LIB_RTL.keyexpansionFSM(keyexpansionFSM_arch);
        end for ;
    end for ;
end keyexpansionFSM_tb_conf;