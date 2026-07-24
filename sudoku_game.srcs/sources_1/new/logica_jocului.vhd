library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sudoku_pkg.all;

entity logica_jocului is
    Port ( clk          : in  STD_LOGIC;
           rst          : in  STD_LOGIC;
           btn_sus      : in  STD_LOGIC;
           btn_jos      : in  STD_LOGIC;
           btn_stg      : in  STD_LOGIC;
           btn_dr       : in  STD_LOGIC;
           btn_enter    : in  STD_LOGIC;
           sw           : in  STD_LOGIC_VECTOR(4 downto 0);
           cursor_x_out : out integer range 0 to 3;
           cursor_y_out : out integer range 0 to 3;
           tabla_out    : out matrice_joc;
           stare_joc    : out integer range 0 to 2);
end logica_jocului;

architecture Behavioral of logica_jocului is
    signal cx    : integer range 0 to 3 := 0;
    signal cy    : integer range 0 to 3 := 0;
    signal tabla : matrice_joc := ((0,0,0,0),(0,0,0,0),(0,0,0,0),(0,0,0,0));
    constant WIN_BOARD : matrice_joc := (
        (1, 2, 3, 4),
        (3, 4, 1, 2),
        (2, 1, 4, 3),
        (4, 3, 2, 1)
    );
begin
    process(clk)
        variable val_sw : integer range 0 to 4;
    begin
        if rising_edge(clk) then
            if    sw(4) = '1' then val_sw := 4;
            elsif sw(3) = '1' then val_sw := 3;
            elsif sw(2) = '1' then val_sw := 2;
            elsif sw(1) = '1' then val_sw := 1;
            else                    val_sw := 0;
            end if;

            if rst = '1' then
                cx    <= 0;
                cy    <= 0;
                tabla <= ((0,0,0,0),(0,0,0,0),(0,0,0,0),(0,0,0,0));
            else
                if btn_sus = '1' then if cy > 0 then cy <= cy - 1; end if; end if;
                if btn_jos = '1' then if cy < 3 then cy <= cy + 1; end if; end if;
                if btn_stg = '1' then if cx > 0 then cx <= cx - 1; end if; end if;
                if btn_dr  = '1' then if cx < 3 then cx <= cx + 1; end if; end if;

                if btn_enter = '1' then
                    if tabla(cy, cx) = 0 or val_sw = 0 then
                        tabla(cy, cx) <= val_sw;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(tabla)
        variable full    : boolean;
        variable correct : boolean;
    begin
        full    := true;
        correct := true;
        
        for i in 0 to 3 loop
            for j in 0 to 3 loop
                if tabla(i,j) = 0 then 
                    full := false; 
                end if;
                if tabla(i,j) /= WIN_BOARD(i,j) then 
                    correct := false; 
                end if;
            end loop;
        end loop;

        if full then
            if correct then stare_joc <= 1;
            else            stare_joc <= 2;
            end if;
        else
            stare_joc <= 0;
        end if;
    end process;

    cursor_x_out <= cx;
    cursor_y_out <= cy;
    tabla_out    <= tabla;
end Behavioral;