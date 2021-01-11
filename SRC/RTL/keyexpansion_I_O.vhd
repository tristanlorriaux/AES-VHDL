--23/12/20  
--keyexpansion_I_O.vhd
--Code décrivant le fonctionnement de la génération des clées de ronde via la machine à états finis et via keyexpansion.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;



entity keyexpansion_I_O is
port (key_i_IO		  : in	bit128;
  clock_i_IO	  : in	std_logic;
  reset_i_IO	  : in	std_logic;
  start_i_IO	  : in	std_logic;
  expansion_key_o_IO : out bit128);
end keyexpansion_I_O;

architecture keyexpansion_I_O_arch of keyexpansion_I_O is
    
    component keyexpansion is 
    port ( key_i		  : in	bit128;
        rcon_i            : in bit8;
        expansion_key_o : out bit128);
    end component keyexpansion;

    component keyexpansionFSM  is 
    port ( start_i : in std_logic	;
        clock_i : in std_logic;
        counter_i : in bit4; 
        reset_i : in std_logic; 
        enable_o : out std_logic;
        reset_counter_o : out std_logic
        );
    end component keyexpansionFSM;

    component Counter is
        port(reset_i  : in  std_logic;
             enable_i : in  std_logic;
             clock_i  : in  std_logic;
             count_o  : out bit4);
    end component Counter;

    signal counter_s : bit4;
    signal rcon_s : bit8;
    signal enable_s : std_logic;
    signal reset_counter_o_s : std_logic;
    signal key_reg_s : bit128;
    signal keystate_s : bit128;
    signal expansion_key_o_s : bit128; 

    begin
        rcon_s <= Rcon(to_integer(unsigned(counter_s))mod 10);
        --keyexpansion component
        U0 : keyexpansion
    port map( 
        key_i  => keystate_s,
        rcon_i => rcon_s,
        expansion_key_o => expansion_key_o_s);

        --keyexpansionFSM component
        U1 : keyexpansionFSM
    port map(
        start_i => start_i_IO,
        clock_i => clock_i_IO,
        reset_i => reset_i_IO,
        counter_i => counter_s,
        enable_o => enable_s,
        reset_counter_o => reset_counter_o_s
    );

        --counter componenent

        U2 : Counter
    port map(
        reset_i => reset_counter_o_s,
        enable_i => enable_s,
        clock_i => clock_i_IO,
        count_o => counter_s 
    );


    P0 : process(expansion_key_o_s, clock_i_IO, reset_i_IO, enable_s) --registre
    begin
        if reset_i_IO = '0' then  -- reset asynchrone
            R0 : for row in 0 to 3 loop
                R1 : for col in 0 to 3 loop
                    key_reg_s(127 - 32*col - 8*row downto 120- 32*col -8*row) <= (others => '0');
                end loop;
            end loop;
        elsif (clock_i_IO'event and clock_i_IO = '1') then
            if (enable_s = '1') then
                key_reg_s <= expansion_key_o_s;
            else
                key_reg_s <= key_i_IO; --init
            end if;
        end if;
    end process P0;

    keystate_s <= key_reg_s when enable_s = '1' else key_i_IO; --mux
    
    expansion_key_o_IO <= keystate_s;

end keyexpansion_I_O_arch;

configuration keyexpansion_I_O_conf of keyexpansion_I_O is
    for keyexpansion_I_O_arch
        for U0 : keyexpansion
            use entity LIB_RTL.keyexpansion(keyexpansion_arch);
        end for;
        for U1 : keyexpansionFSM
            use entity LIB_RTL.keyexpansionFSM(keyexpansionFSM_arch);
        end for;
        for U2 : Counter
            use entity LIB_RTL.Counter(Counter_arch);
        end for;
    end for;
end keyexpansion_I_O_conf;