library ieee;
use ieee.std_logic_1164.all;

entity grain_128aead is
    generic (r : integer := 32);
    port (clk     : in std_logic;
          reset_n : in std_logic;

          key : in std_logic_vector(127 downto 0);
          iv  : in std_logic_vector(95 downto 0);
          data : in std_logic_vector(r/2-1 downto 0);

          part_key : in std_logic_vector(r-1 downto 0);
          feed_key : out std_logic;

          ready    : out std_logic;
          tag      : out std_logic_vector(63 downto 0);
          ct       : out std_logic_vector(r/2-1 downto 0));
end entity grain_128aead;

architecture behavioural of grain_128aead is

    signal round : integer range 0 to (384/r) + 1;

    signal init1   : std_logic;
    signal init2   : std_logic;
    signal load_en : std_logic;
    signal load    : std_logic_vector(255 downto 0);
    
    signal x : std_logic_vector(255 downto 0);
    signal y : std_logic_vector(255 downto 0);

    signal a_init : std_logic;
    signal a_upd  : std_logic;
    signal a_load : std_logic_vector(r-1 downto 0);
    signal a_x : std_logic_vector(63 downto 0);
    signal a_y : std_logic_vector(63 downto 0);
    
    signal r_init : std_logic;
    signal r_upd  : std_logic;
    signal r_load : std_logic_vector(r-1 downto 0);
    signal r_x : std_logic_vector(63 downto 0);
    signal r_y : std_logic_vector(63 downto 0);

    signal ks     : std_logic_vector(r-1 downto 0);

    signal z_acc : std_logic_vector(r/2-1 downto 0);
    signal z_ct  : std_logic_vector(r/2-1 downto 0);

begin

    tag <= a_x;
    ct  <= data xor z_ct;

    z_ex : for i in 0 to r/2-1 generate
        z_acc(r/2-1-i)  <= ks(r-2-2*i);
        z_ct(r/2-1-i) <= ks(r-1-2*i);
    end generate;

    load_en  <= '0' when round = 0 else '1';
    ready    <= '1' when round > 384/r else '0';
    feed_key <= init2;

    init1 <= '1' when round >= 1 and round <= 256/r else '0';
    init2 <= '1' when round > 256/r and round <= 384/r else '0';
    load <= key & iv & (30 downto 0 => '1') & '0';

    sreg      : entity work.sreg port map (clk, load_en, load, y, x);
    ufunc     : entity work.ufunc generic map (r) port map (x, part_key, init1, init2, y, ks);
    acc_ufunc : entity work.acc_ufunc generic map(r/2) port map(a_x, r_x, data, z_acc, a_y, r_y);

    r_upd <= '1' when round > 384/r else '0';
    a_upd <= '1' when round > 384/r else '0';

    gen1 : if r > 64 generate
        a_load <= ks(127 downto 64) & (r/2-1 downto 0 => '0');
        r_load <= ks(63 downto 0) & (r/2-1 downto 0 => '0');

        a_init <= init2;
        r_init <= init2;
    end generate;

    gen2 : if r <= 64 generate
        a_load <= ks;
        r_load <= ks;

        a_init <= '1' when round > 256/r and round <= 320/r else '0';
        r_init <= '1' when round > 320/r and round <= 384/r else '0';
    end generate;
    
    rreg : entity work.acc_reg generic map (r) port map(clk, r_init, r_upd, r_load, r_y, r_x);
    areg : entity work.acc_reg generic map (r) port map(clk, a_init, a_upd, a_load, a_y, a_x);

    fsm : process(clk, reset_n)
    begin
        if reset_n = '0' then
            round <= 0;
        elsif rising_edge(clk) then
            if round <= 384/r then
                round <= round + 1;
            end if;
        end if;
    end process fsm;

end architecture behavioural;
