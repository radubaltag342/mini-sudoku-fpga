library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sudoku_pkg.all;

entity vga is
    Port ( rst      : in  STD_LOGIC;
           clk      : in  STD_LOGIC;         
           tabla_in : in  matrice_joc;
           cursor_x : in  integer range 0 to 3;
           cursor_y : in  integer range 0 to 3;
           hs       : out STD_LOGIC;
           vs       : out STD_LOGIC;
           r        : out STD_LOGIC_VECTOR(3 downto 0);
           g        : out STD_LOGIC_VECTOR(3 downto 0);
           b        : out STD_LOGIC_VECTOR(3 downto 0));
end vga;

architecture Behavioral of vga is
    constant HD  : integer := 640;
    constant HFP : integer := 16;
    constant HSP : integer := 96;
    constant HBP : integer := 48;
    constant H_TOTAL : integer := HD + HFP + HSP + HBP;

    constant VD  : integer := 480;
    constant VFP : integer := 10;
    constant VSP : integer := 2;
    constant VBP : integer := 33;
    constant V_TOTAL : integer := VD + VFP + VSP + VBP;

    signal h_cnt : integer range 0 to H_TOTAL - 1 := 0;
    signal v_cnt : integer range 0 to V_TOTAL - 1 := 0;

    signal hs_reg : STD_LOGIC := '1';
    signal vs_reg : STD_LOGIC := '1';
    signal r_reg  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal g_reg  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal b_reg  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin
    process(clk, rst)
        variable col, row   : integer range 0 to 3;
        variable r_v, g_v, b_v : STD_LOGIC_VECTOR(3 downto 0);
        variable in_h, in_v : boolean;
        variable in_grid, on_vline, on_hline, in_cifra, video_act : boolean;
    begin
        if rst = '1' then
            h_cnt  <= 0;
            v_cnt  <= 0;
            hs_reg <= '1';
            vs_reg <= '1';
            r_reg  <= (others => '0');
            g_reg  <= (others => '0');
            b_reg  <= (others => '0');
        elsif rising_edge(clk) then
            if h_cnt = H_TOTAL - 1 then
                h_cnt <= 0;
                if v_cnt = V_TOTAL - 1 then
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;

            if (h_cnt >= HD + HFP) and (h_cnt < HD + HFP + HSP) then
                hs_reg <= '0';
            else
                hs_reg <= '1';
            end if;

            if (v_cnt >= VD + VFP) and (v_cnt < VD + VFP + VSP) then
                vs_reg <= '0';
            else
                vs_reg <= '1';
            end if;

            video_act := (h_cnt < HD) and (v_cnt < VD);
            
            if not video_act then
                r_v := x"0"; g_v := x"0"; b_v := x"0";
            else
                r_v := x"0"; g_v := x"0"; b_v := x"0";

                if    h_cnt >= 120 and h_cnt < 220 then col := 0;
                elsif h_cnt >= 220 and h_cnt < 320 then col := 1;
                elsif h_cnt >= 320 and h_cnt < 420 then col := 2;
                else                                     col := 3;
                end if;

                if    v_cnt >= 40  and v_cnt < 140 then row := 0;
                elsif v_cnt >= 140 and v_cnt < 240 then row := 1;
                elsif v_cnt >= 240 and v_cnt < 340 then row := 2;
                else                                     row := 3;
                end if;

                on_vline := (h_cnt = 120 or h_cnt = 220 or h_cnt = 320 or h_cnt = 420 or h_cnt = 520) 
                            and (v_cnt >= 40 and v_cnt <= 440);

                on_hline := (v_cnt = 40  or v_cnt = 140 or v_cnt = 240 or v_cnt = 340 or v_cnt = 440) 
                            and (h_cnt >= 120 and h_cnt <= 520);

                in_grid := (h_cnt > 120 and h_cnt < 520 and v_cnt > 40  and v_cnt < 440);

                in_h := (h_cnt >= 150 and h_cnt < 190) or (h_cnt >= 250 and h_cnt < 290) 
                     or (h_cnt >= 350 and h_cnt < 390) or (h_cnt >= 450 and h_cnt < 490);

                in_v := (v_cnt >= 70  and v_cnt < 110) or (v_cnt >= 170 and v_cnt < 210) 
                     or (v_cnt >= 270 and v_cnt < 310) or (v_cnt >= 370 and v_cnt < 410);

                in_cifra := in_h and in_v;

                if on_vline or on_hline then
                    r_v := x"F"; g_v := x"F"; b_v := x"F";
                elsif in_grid then
                    if col = cursor_x and row = cursor_y then
                        r_v := x"3"; g_v := x"3"; b_v := x"3";
                    end if;

                    if in_cifra then
                        case tabla_in(row, col) is
                            when 1 => r_v := x"F"; g_v := x"0"; b_v := x"0";
                            when 2 => r_v := x"0"; g_v := x"F"; b_v := x"0";
                            when 3 => r_v := x"0"; g_v := x"0"; b_v := x"F";
                            when 4 => r_v := x"F"; g_v := x"F"; b_v := x"0";
                            when others => null;
                        end case;
                    end if;
                end if;
            end if;
            r_reg <= r_v;
            g_reg <= g_v;
            b_reg <= b_v;
        end if;
    end process;

    hs <= hs_reg;
    vs <= vs_reg;
    r  <= r_reg;
    g  <= g_reg;
    b  <= b_reg;
end Behavioral;