library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Divide ceasul de 100 MHz la 25 MHz pentru pixel clock VGA.
-- Implementare: contor modulo-2 cu toggle => 100MHz / 4 = 25MHz.
--
-- FIX 8: Folosim BUFG (Global Clock Buffer) pentru semnalul de iesire.
-- Fara BUFG, Vivado genereaza avertisment "clock driven by non-clock resource"
-- si ceasul divizat are skew mare, putand cauza setup/hold violations la
-- toate componentele clocked de el (vga, logica_jocului, debouncer, afisaj_ssd).
-- BUFG rutreaza ceasul pe reteaua dedicata de clock a FPGA-ului Xilinx.

library UNISIM;
use UNISIM.VComponents.all;

entity div_frecventa is
    Port ( rst         : in  STD_LOGIC;
           clk         : in  STD_LOGIC;   -- 100 MHz (de la oscilator Basys 3)
           clk_divizat : out STD_LOGIC);  -- 25 MHz  (pixel clock VGA)
end div_frecventa;

architecture Behavioral of div_frecventa is
    signal count   : integer range 0 to 1 := 0;
    signal clk_int : std_logic := '0';
begin

    process(clk, rst)
    begin
        if rst = '1' then
            count   <= 0;
            clk_int <= '0';
        elsif rising_edge(clk) then
            if count = 1 then
                count   <= 0;
                clk_int <= not clk_int;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    -- FIX 8: Buffer global de clock - esential pentru timing corect in Vivado
    clk_buf : BUFG
        port map (
            I => clk_int,
            O => clk_divizat
        );

end Behavioral;
