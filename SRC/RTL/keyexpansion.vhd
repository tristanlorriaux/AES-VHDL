--15/12/20  
--keyexpansion.vhd
--Code décrivant le fonctionnement de la génération des clées de ronde


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;



entity keyexpansion is 
port ( key_i		  : in	bit128;
    rcon_i            : in bit8;
    expansion_key_o : out bit128);
end keyexpansion;

architecture keyexpansion_arch of keyexpansion is

    component SBOX
    port(
        SBOX_i  : in bit8;
        SBOX_o : out bit8);
    end component SBOX;

-- dans cryptpack.vhd
-- type key_state is array (0 to 3) of column_state;
        
    signal word_i_s : key_state;
    signal word_rotSBOX_s : column_state;
    signal word_o_s : key_state;


begin
    -- conversion en key state (4x4 bit8 array)
    
    col : for j in 0 to 3 generate
    	row : for i in 0 to 3 generate
            word_i_s(j)(i) <= key_i(127-32*j-8*i downto 120-32*j-8*i);
    	end generate;
    end generate;

    -- on calcule W0
    -- transfo SBOX
    SB : for i in 0 to 3 generate
	cell : SBOX port map (
	    SBOX_i => word_i_s(3)((i+1) mod 4),
	    SBOX_o => word_rotSBOX_s(i));
    end generate SB;

    word_o_s(0) <= word_rotSBOX_s xor (rcon_i, X"00", X"00", X"00") xor word_i_s(0);

    -- on calcule le reste
    WOCol : for j in 1 to 3 generate
	word_o_s(j) <= word_o_s(j-1) xor word_i_s(j);
    end generate;


    -- reconversion en bit 128
    KOCol : for j in 0 to 3 generate
    	KOrow : for i in 0 to 3 generate
            expansion_key_o(127-32*j-8*i downto 120-32*j-8*i) <= word_o_s(j)(i);
    	end generate;
    end generate;


end architecture;

configuration keyexpansion_conf of keyexpansion is
    for keyexpansion_arch
        for SB
            for all : SBOX
                use entity LIB_RTL.SBOX(SBOX_arch);
            end for;
        end for;
    end for;
end configuration keyexpansion_conf;