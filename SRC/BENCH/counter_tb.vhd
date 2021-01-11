-- counter_tb.vhd
-- Tristan Lorriaux 2020-11-27
-- Counter test bench

-- use IEEE lib for types
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-- use AES local library for bit4 type
library LIB_AES;
use LIB_AES.crypt_pack.all;

-- use RTL local library for counter arch
library LIB_RTL;

entity counter_tb is
end counter_tb;

architecture counter_tb_arch of counter_tb is

    component Counter is
      port(reset_i  : in  std_logic;
           enable_i : in  std_logic;
           clock_i  : in  std_logic;
           count_o  : out bit4);
    end component;

    signal reset_s, enable_s : std_logic;
    signal clock_s : std_logic := '0';
    signal count_s : bit4;

begin
    DUT : Counter port map(
	reset_i => reset_s,
	enable_i => enable_s,
	clock_i => clock_s,
	count_o => count_s);

    -- stimulii
    clock_s <= not(clock_s) after 50 ns; -- clock period : 100 ns
    reset_s <= '0', '1' after 25 ns; -- activate component
    enable_s <= '0', '1' after 425 ns; -- wait 4 clock cycles before beginning


end architecture counter_tb_arch;

configuration counter_tb_conf of counter_tb is
    for counter_tb_arch
        for DUT : Counter
            use entity LIB_RTL.counter(counter_arch);
        end for;
    end for;
end counter_tb_conf;
