library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity afisaj_ssd is
    Port ( clk       : in STD_LOGIC;
           stare_joc : in integer range 0 to 2;
           an        : out STD_LOGIC_VECTOR (7 downto 0);
           cat       : out STD_LOGIC_VECTOR (6 downto 0));
end afisaj_ssd;

architecture Behavioral of afisaj_ssd is
    signal count     : std_logic_vector(17 downto 0) := (others => '0');
    signal digit_sel : std_logic_vector(1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
        end if;
    end process;

    digit_sel <= count(17 downto 16);

    process(digit_sel)
    begin
        case digit_sel is
            when "00"   => an <= "11111110"; 
            when "01"   => an <= "11111101"; 
            when "10"   => an <= "11111011"; 
            when "11"   => an <= "11110111"; 
            when others => an <= "11111111";
        end case;
    end process;

    process(digit_sel, stare_joc)
    begin
        cat <= "1111111"; 

        if stare_joc = 1 then
            case digit_sel is
                when "11"   => cat <= "0001100"; 
                when "10"   => cat <= "0001000"; 
                when "01"   => cat <= "0010010"; 
                when "00"   => cat <= "0010010"; 
                when others => cat <= "1111111"; 
            end case;

        elsif stare_joc = 2 then
            case digit_sel is
                when "11"   => cat <= "1000111"; 
                when "10"   => cat <= "1000000"; 
                when "01"   => cat <= "0010010"; 
                when "00"   => cat <= "0000110"; 
                when others => cat <= "1111111"; 
            end case;
        end if;
    end process;
end Behavioral;