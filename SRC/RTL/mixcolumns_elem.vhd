-- mixcolums_elem.vhd
-- Tristan Lorriaux 07/12/2020
-- Fichier décrivant le composant élémentaire à mixcolums :  entre la colonne et une matrice de Jourdain


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity mixcolumns_elem is
	port (
		datae_i : in column_state;
		datae_o : out column_state
	);
end mixcolumns_elem;

architecture mixcolumns_elem_arch of mixcolumns_elem is
    
    signal decal_octet_s : column_state ;
    signal data2_s : column_state ; --datae_i x 0x02
	signal data3_s : column_state ; --datae_i x 0x03
	
begin
    G1 : for i in 0 to 3 generate
        --On mutiplie par 2
        decal_octet_s(i) <= datae_i(i)(6 downto 0)&'0';
        data2_s(i) <= decal_octet_s(i) xor ("000" & datae_i(i)(7) & datae_i(i)(7) & '0' & datae_i(i)(7) & datae_i(i)(7));
        --On mutiplie par 3
        data3_s(i) <= data2_s(i) xor datae_i(i);
    end generate G1;

	datae_o(0) <= data2_s(0) xor data3_s(1) xor datae_i(2)  xor datae_i(3);
    datae_o(1) <= datae_i(0)  xor data2_s(1) xor data3_s(2) xor datae_i(3);
    datae_o(2) <= datae_i(0)  xor datae_i(1)  xor data2_s(2) xor data3_s(3);
    datae_o(3) <= data3_s(0) xor datae_i(1)  xor datae_i(2)  xor data2_s(3);
	
end architecture mixcolumns_elem_arch;
