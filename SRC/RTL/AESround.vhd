--11/12/20  
--AESround.vhd
--Code décrivant le fonctionnement de la ronde AES : 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;



entity AESRound is 
port (  text_i			: in  bit128;
        currentkey_i		: in  bit128;
        data_o			: out bit128;
        clock_i		: in  std_logic;
        resetb_i		: in  std_logic;
        enableMixcolumns_i	: in  std_logic;
        enableRoundcomputing_i : in  std_logic);
end AESRound;

architecture AESRound_arch of AESRound is
    
    component subbytes
    port( data_i : in type_state;
        data_o : out type_state); 
    end component subbytes;  

    component shiftrows
    port( data_i : in type_state;
        data_o : out type_state); 
    end component shiftrows;  

    component mixcolumns
     port( data_i: in type_state;
        enable_i: in std_logic;
        data_o: out type_state); 
    end component mixcolumns;

    component addroundkey
     port(data_i1: in type_state;
        data_i2: in type_state;
        data_o: out type_state); 
    end component addroundkey;
    
    -- signaux
    signal currentKeyState_s	: type_state;
    signal textState_s		: type_state;
    signal outputSB_s	: type_state;
    signal outputSR_s	: type_state;
    signal outputMC_s	: type_state;
    signal outputMux_s	: type_state;
    signal outputARK_s	: type_state;
    signal regState_s	: type_state;
 
 
 begin
 
     -- Conversion des signaux externes entrants
      -- On conv une key_i bit128(127 downto 0) en type state
    Kcol : for j in 0 to 3 generate
        Krow : for i in 0 to 3 generate
            currentKeyState_s(i)(j) <= currentKey_i(127-32*j-8*i downto 120-32*j-8*i);
        end generate;
    end generate;
    -- On conv le text_i bit128(127 downto 0) en type state
    Tcol : for j in 0 to 3 generate
        Trow : for i in 0 to 3 generate
            textState_s(i)(j) <= text_i(127-32*j-8*i downto 120-32*j-8*i);
        end generate;
    end generate;
 
 
     -- Port map
    SB : subbytes port map (
        data_i => regState_s,
        data_o => outputSB_s);
 
    SR : shiftrows port map (
        data_i => outputSB_s,
        data_o => outputSR_s);
 
    MC : mixcolumns port map (
        data_i  => outputSR_s,
        enable_i => enableMixColumns_i,
        data_o  => outputMC_s);
 
      -- Mux :
    outputMux_s <= outputMC_s when enableRoundComputing_i = '1' else textState_s;
 
    ARK : addroundkey port map (
        data_i1	    => outputMux_s,
        data_i2 => currentKeyState_s,
        data_o	    => outputARK_s);
 
     -- (Re)conversions en sortie
     Ocol : for j in 0 to 3 generate
         Orow : for i in 0 to 3 generate
             data_o(127-32*j-8*i downto 120-32*j-8*i) <= regState_s(i)(j);
         end generate;
     end generate;
 
     -- On modifie le registre
    P0 : process(outputARK_s, clock_i, resetb_i, enableRoundComputing_i)
        begin
        if resetb_i = '0' then  -- reset asynchrone
            R0 : for i in 0 to 3 loop
                R1 : for j in 0 to 3 loop
                    regState_s(i)(j) <= (others => '0');
                end loop;
            end loop;
        elsif (enableRoundComputing_i = '0') then
            regState_s <= regState_s;
        elsif ((clock_i'event and clock_i = '1') or (enableRoundComputing_i'event and enableRoundComputing_i = '1')) then
            regState_s <= outputARK_s;
        end if;
    end process P0;
 
 end architecture;


 configuration AESRound_conf of AESRound is
    for AESRound_arch
        for SB : subbytes
            use configuration LIB_RTL.subbytes_conf;
        end for;
        for SR : shiftrows
            use entity LIB_RTL.shiftrows(shiftrows_arch);
        end for;
        for MC : mixcolumns
            use configuration LIB_RTL.mixcolumns_conf;
        end for;
        for ARK : addroundkey
            use entity LIB_RTL.addroundkey(addroundkey_arch);
        end for;
    end for;
end AESRound_conf;