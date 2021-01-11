-- AES_tb.vhd
-- test bench du AES
-- Tristan LORRIAUX 27/12/2020 

library ieee;
use ieee.std_logic_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

--entity
entity AES_tb is
end AES_tb;

--arch
architecture AES_tb_arch of AES_tb is
    component AES is
        port (
            data_i : in bit128;
            clock_i : in std_logic;
            reset_i : in std_logic;
            start_i : in std_logic;
            key_i	: in  bit128;
            data_o : out bit128;
            aes_on_o : out std_logic
        );
    end component;

    signal data_i_s : bit128 := X"45732d747520636f6e66696ee865203f";
    signal key_i_s : bit128 := X"2b7e151628aed2a6abf7158809cf4f3c";
    signal clock_s : std_logic:='0';
    signal reset_s : std_logic;
    signal start_s : std_logic;
    signal data_o_s : bit128;
    signal aes_on_s : std_logic;

begin

    DUT : AES
    port map(
        data_i => data_i_s,
        key_i => key_i_s,
        clock_i => clock_s,
        reset_i => reset_s,
        start_i => start_s,
        data_o => data_o_s,
        aes_on_o => aes_on_s

    );

 reset_s<='1','0' after 10 ns;
 clock_s <= not(clock_s) after 50 ns;
 start_s<='0','1' after 110 ns, '0' after 160 ns;



end architecture; -- arch



configuration AES_tb_conf of AES_tb is
    for AES_tb_arch
        for DUT : AES
            use configuration LIB_RTL.AES_conf;
        end for;
    end for;
end configuration AES_tb_conf;

