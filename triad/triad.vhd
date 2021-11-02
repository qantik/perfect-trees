library ieee;
use ieee.std_logic_1164.all;

entity triad is
    generic (r : integer := 256);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          k : in std_logic_vector(0 to 127);
          iv  : in std_logic_vector(0 to 95);

          ready : out std_logic;
          ks    : out std_logic_vector(0 to r-1));
end entity triad;

architecture behavioural of triad is

    signal round : integer range 0 to 1024+r;

    signal load_en : std_logic;
    signal load    : std_logic_vector(0 to 255);
    
    signal x : std_logic_vector(0 to 255);
    signal y, y1, y2 : std_logic_vector(0 to 255);

begin

    load_en <= '0' when round = 0 else '1';
    ready   <= '1' when round > 1024 else '0';

    load <= iv(0 to 7) & k(32 to 39) & X"FF" & k(24 to 31) & X"FF" & k(16 to 23) & X"FF" & k(8 to 15) & X"FE" & k(0 to 7) &
            iv(88 to 95) & iv(80 to 87) & iv(72 to 79) & iv(64 to 71) & iv(56 to 63) & iv(48 to 55) & iv(40 to 47) &
            iv(32 to 39) & iv(24 to 31) & iv(16 to 23) & iv(8 to 15) & k(120 to 127) & k(112 to 119) & k(104 to 111) &
            k(96 to 103) & k(88 to 95) & k(80 to 87) & k(72 to 79) & k(64 to 71) & k(56 to 63) & k(48 to 55) & k(40 to 47);

    sreg  : entity work.sreg port map (clk, load_en, load, y, x);
    ufunc : entity work.ufunc generic map (r) port map (x, y, ks);

    fsm : process(clk, reset_n)
    begin

        if reset_n = '0' then
            round <= 0;
        elsif rising_edge(clk) then
            if round <= 1024 then
                round <= round + r;
            end if;
        end if;
    end process fsm;

end architecture behavioural;
