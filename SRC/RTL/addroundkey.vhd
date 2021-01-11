-- addroundkey.vhd
-- Tristan Lorriaux 2020-01-12
-- Fichier décrivant le composant addroundkey : transformation non linéaire appliquée à tous les octets de l’état en utilisant une table de substitution appelée S-Box


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity addroundkey is
port( 
    data_i1: in type_state;
    data_i2: in type_state;
    data_o: out type_state);
end entity addroundkey;

architecture addroundkey_arch of addroundkey is

begin 
	Rang: for i in 0 to 3 generate
		Col: for j in 0 to 3 generate
			data_o(i)(j) <= data_i1 (i)(j) xor data_i2 (i)(j);
		end generate Col;
	end generate Rang;
end architecture addroundkey_arch;
