library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    Port ( clk     : in STD_LOGIC;
           btn_in  : in STD_LOGIC;
           btn_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal count           : std_logic_vector(15 downto 0) := (others => '0');
    signal btn_stare       : std_logic := '0';
    signal btn_stare_veche : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_in = '1' then
                if count = x"FFFF" then
                    btn_stare <= '1';
                else
                    count <= count + 1;
                end if;
            else
                count      <= (others => '0');
                btn_stare  <= '0';
            end if;
            btn_stare_veche <= btn_stare;
        end if;
    end process;
    
    btn_out <= '1' when (btn_stare = '1' and btn_stare_veche = '0') else '0';
end Behavioral;