-- mixcolumns.vhd
-- Tristan Lorriaux 2020-07-12
-- Fichier décrivant le composant mixcolumns : entrée 4 colonnes, sortie 4 colonnnes mixées par le column calculator ou non ! (selon enable)


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;

entity mixcolumns is
port( 
    data_i: in type_state;
    enable_i: in std_logic;
    data_o: out type_state);
end entity mixcolumns;

architecture mixcolumns_arch of mixcolumns is

	component mixcolumns_elem is
	port ( 
		datae_i  : in  column_state;
		datae_o  : out  column_state
	);
	end component mixcolumns_elem;

	signal data_o_s : type_state;
    
	
begin
		G1 : for i in 0 to 3 generate
        inter : mixcolumns_elem port map(
            datae_i(0) => data_i(0)(i), 
            datae_i(1) => data_i(1)(i),
            datae_i(2) => data_i(2)(i), 
            datae_i(3) => data_i(3)(i),

            datae_o(0) => data_o_s(0)(i), 
            datae_o(1) => data_o_s(1)(i), 
            datae_o(2) => data_o_s(2)(i), 
            datae_o(3) => data_o_s(3)(i)
        );
        end generate G1;
        data_o <= data_i when enable_i = '0'
            else data_o_s;

end architecture mixcolumns_arch;

configuration mixcolumns_conf of mixcolumns is
    for mixcolumns_arch
        for G1
            for all: mixcolumns_elem
                use entity LIB_RTL.mixcolumns_elem(mixcolumns_elem_arch);
            end for;
        end for;
    end for;
end configuration mixcolumns_conf;