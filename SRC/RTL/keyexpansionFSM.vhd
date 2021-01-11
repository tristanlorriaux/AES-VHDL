--15/12/20  
--keyexpansionFSM.vhd
--Code décrivant le fonctionnement de la machine a états finis de keyexpansion


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library LIB_AES;
use LIB_AES.crypt_pack.all;

library LIB_RTL;
use LIB_RTL.all;


entity keyexpansionFSM  is 
port ( start_i : in std_logic	;
    clock_i : in std_logic;
    counter_i : in bit4; 
    reset_i : in std_logic; 
    enable_o : out std_logic;
    reset_counter_o : out std_logic
    );
end keyexpansionFSM;

architecture keyexpansionFSM_arch of keyexpansionFSM is

    type state_type is (init, count, stop);
    signal present_state, next_state : state_type;
    
begin

    sequentiel : process(clock_i, reset_i)
    begin
    if reset_i = '0' then
        present_state <= init;
    elsif rising_edge(clock_i) then
        present_state <= next_state;
    end if;
    end process;

    C0 : process(present_state, start_i, counter_i)
    begin
        case present_state is
            when init=>
            if start_i = '1' then
                next_state <= count;
            else
                next_state <= init;
            end if;
            when count =>        
            if counter_i = x"A" then
                next_state <= stop;
            else
                next_state <= count;
            end if;                
            when stop =>
            if start_i='1' then
                next_state <= stop;
            else
                next_state <= init;
            end if;
            when others =>
            next_state <= present_state;
        end case;
    end process C0;

    C1 : process(present_state)
    begin
    case present_state is
        when init=>
        enable_o   <= '0';
        reset_counter_o   <= '0';
        when count =>
        enable_o   <= '1';
        reset_counter_o   <= '1';
        when stop =>
        enable_o   <= '0';
        reset_counter_o   <= '1';
    end case;
    end process C1;

end keyexpansionFSM_arch;