library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sudoku_pkg.all; 

entity top_vga_div is
    Port ( rst_t       : in STD_LOGIC;
           clk_t       : in STD_LOGIC;
           btn_up_t    : in STD_LOGIC;
           btn_down_t  : in STD_LOGIC;
           btn_left_t  : in STD_LOGIC;
           btn_right_t : in STD_LOGIC;
           btn_enter_t : in STD_LOGIC;
           sw_t        : in STD_LOGIC_VECTOR(4 downto 0);
           an_t        : out STD_LOGIC_VECTOR (7 downto 0);
           cat_t       : out STD_LOGIC_VECTOR (6 downto 0);
           hs_t        : out STD_LOGIC;
           vs_t        : out STD_LOGIC;
           r_t         : out STD_LOGIC_VECTOR (3 downto 0);
           g_t         : out STD_LOGIC_VECTOR (3 downto 0);
           b_t         : out STD_LOGIC_VECTOR (3 downto 0));
end top_vga_div;

architecture Behavioral of top_vga_div is

    component div_frecventa is
        Port ( rst : in STD_LOGIC; clk : in STD_LOGIC; clk_divizat : out STD_LOGIC);
    end component;

    component debouncer is
        Port ( clk : in STD_LOGIC; btn_in : in STD_LOGIC; btn_out : out STD_LOGIC);
    end component;

    component logica_jocului is
        Port ( clk : in STD_LOGIC; rst : in STD_LOGIC;
               btn_sus : in STD_LOGIC; btn_jos : in STD_LOGIC; btn_stg : in STD_LOGIC; btn_dr : in STD_LOGIC; btn_enter : in STD_LOGIC;
               sw : in STD_LOGIC_VECTOR(4 downto 0);
               cursor_x_out : out integer range 0 to 3; cursor_y_out : out integer range 0 to 3; tabla_out : out matrice_joc;
               stare_joc : out integer range 0 to 2);
    end component;

    component vga is
        Port ( rst : in STD_LOGIC; clk : in STD_LOGIC; tabla_in : in matrice_joc;
               cursor_x : in integer range 0 to 3; cursor_y : in integer range 0 to 3;
               hs : out STD_LOGIC; vs : out STD_LOGIC; r : out STD_LOGIC_VECTOR(3 downto 0); g : out STD_LOGIC_VECTOR(3 downto 0); b : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    component afisaj_ssd is
        Port ( clk       : in STD_LOGIC;
               stare_joc : in integer range 0 to 2;
               an        : out STD_LOGIC_VECTOR (7 downto 0);
               cat       : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    signal clk_25MHz : std_logic := '0';
    signal db_up, db_down, db_left, db_right, db_enter : std_logic;
    signal cx_semnal, cy_semnal : integer range 0 to 3;
    signal tabla_semnal : matrice_joc;
    signal stadiu_joc_semnal : integer range 0 to 2;

begin
    map_div: div_frecventa port map (rst => rst_t, clk => clk_t, clk_divizat => clk_25MHz);
    
    deb_up:    debouncer port map (clk => clk_25MHz, btn_in => btn_up_t,    btn_out => db_up);
    deb_down:  debouncer port map (clk => clk_25MHz, btn_in => btn_down_t,  btn_out => db_down);
    deb_left:  debouncer port map (clk => clk_25MHz, btn_in => btn_left_t,  btn_out => db_left);
    deb_right: debouncer port map (clk => clk_25MHz, btn_in => btn_right_t, btn_out => db_right);
    deb_ent:   debouncer port map (clk => clk_25MHz, btn_in => btn_enter_t, btn_out => db_enter);
    
    map_logica: logica_jocului port map (
        clk => clk_25MHz, rst => rst_t,
        btn_sus => db_up, btn_jos => db_down, btn_stg => db_left, btn_dr => db_right, btn_enter => db_enter,
        sw => sw_t,
        cursor_x_out => cx_semnal, cursor_y_out => cy_semnal, tabla_out => tabla_semnal,
        stare_joc => stadiu_joc_semnal 
    );
    
    map_ssd: afisaj_ssd port map (
        clk => clk_25MHz,
        stare_joc => stadiu_joc_semnal,
        an => an_t,
        cat => cat_t
    );
    
    map_vga: vga port map (
        rst => rst_t, clk => clk_25MHz,
        tabla_in => tabla_semnal, cursor_x => cx_semnal, cursor_y => cy_semnal,
        hs => hs_t, vs => vs_t, r => r_t, g => g_t, b => b_t
    );
end Behavioral;