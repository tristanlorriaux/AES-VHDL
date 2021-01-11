-- shifrows.vhd
-- Tristan Lorriaux 04/12/2020
-- Fichier décrivant le composant shiftrow : permutation circulaire

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library LIB_AES;
use LIB_AES.crypt_pack.all;
library LIB_RTL;

entity shiftrows is
    port ( 
        data_i  : in  type_state;
        data_o  : out  type_state
    );
end shiftrows;

architecture shiftrows_arch of shiftrows is

begin
     
    Row: for i in 0 to 3 generate
        Col: for j in 0 to 3 generate
            data_o(i)(j) <= data_i(i)((i+j) mod 4);
        end generate Col;
    end generate Row;  
   
end shiftrows_arch;

