library ieee;
use ieee.std_logic_1164.all;

entity trivia is
    generic (r : integer := 1);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          key : in std_logic_vector(0 to 127);
          iv  : in std_logic_vector(0 to 127);

          ready : out std_logic;
          ks    : out std_logic_vector(0 to r-1));
end entity trivia;

architecture behavioural of trivia is

    signal round : integer range 0 to 1152+r;

    signal load_en : std_logic;
    signal load    : std_logic_vector(0 to 383);
    
    signal x : std_logic_vector(0 to 383);
    signal y : std_logic_vector(0 to 383);

begin

    load_en <= '0' when round = 0 else '1';
    ready   <= '1' when round > 1152 else '0';

    load <= key & (0 to 108 => '1') & iv & (0 to 18 => '1');

    sreg  : entity work.sreg port map (clk, load_en, load, y, x);
    ufunc : entity work.ufunc generic map (r) port map (x, y, ks);

    fsm : process(clk, reset_n)
    begin

        if reset_n = '0' then
            round <= 0;
        elsif rising_edge(clk) then
            if round <= 1152 then
                round <= round + r;
            end if;
        end if;
    end process fsm;

end architecture behavioural;
