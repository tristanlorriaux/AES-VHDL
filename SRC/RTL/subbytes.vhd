-- subbytes.vhd
-- Tristan Lorriaux 2020-01-12
-- Fichier décrivant le composant subbytes : transformation non linéaire appliquée à tous les octets de l’état en utilisant 
-- une table de substitution appelée S-Box


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity SubBytes is
port( 
    data_i: in type_state;
    data_o: out type_state);
end entity SubBytes;

architecture SubBytes_arch of SubBytes is

    component SBOX
        port( 
            SBOX_i : in bit8;
            SBOX_o : out bit8);
        end component;
    begin 
        BOX : SBOX  port map(
            data_i(0)(0),data_o(0)(0));
        G1 : for h in 0 to 3 generate -- parcours de chaque colonne
            G2 : for i in 0 to 3 generate -- parcours de chaque octet/"mot"
                    BOX2 : SBOX port map(data_i(h) (i),data_o(h) (i));
            end generate G2;
        end generate G1;

end architecture SubBytes_arch;

configuration SubBytes_conf of SubBytes is
    for SubBytes_arch
        for G1
            for G2
                for all: SBOX
                    use entity LIB_RTL.SBOX(SBOX_arch);
                end for;
            end for;
        end for;
    end for;
end configuration SubBytes_conf;
