library ieee;
use ieee.std_logic_1164.all;

entity grain_128a is
    generic (r : integer := 256);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          key : in std_logic_vector(127 downto 0);
          iv  : in std_logic_vector(95 downto 0);

          ready : out std_logic;
          ks    : out std_logic_vector(r-1 downto 0));
end entity grain_128a;

architecture behavioural of grain_128a is

    signal round : integer range 0 to (256/r) + 1;

    signal init    : std_logic;
    signal load_en : std_logic;
    signal load    : std_logic_vector(255 downto 0);
    
    signal x : std_logic_vector(255 downto 0);
    signal y : std_logic_vector(255 downto 0);

begin

    load_en <= '0' when round = 0 else '1';
    ready   <= '1' when round > 256/r else '0';

    init <= '1' when round >= 1 and round <= 256/r else '0';
    load <= key & iv & (31 downto 0 => '1');

    sreg  : entity work.sreg port map (clk, load_en, load, y, x);
    ufunc : entity work.ufunc generic map (r) port map (x, init, y, ks);

    fsm : process(clk, reset_n)
    begin
        if reset_n = '0' then
            round <= 0;
        elsif rising_edge(clk) then
            if round <= 256/r then
                round <= round + 1;
            end if;
        end if;
    end process fsm;

end architecture behavioural;
