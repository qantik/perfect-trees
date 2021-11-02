library ieee;
use ieee.std_logic_1164.all;

entity aead is
    generic (r : integer := 288);
    port (clk     : in std_logic;
          load    : in std_logic; -- synchronous load

          key : in std_logic_vector(0 to 79);
          iv  : in std_logic_vector(0 to 79);

          mac_data : in std_logic_vector(0 to r-1);
          sc_data  : in std_logic_vector(0 to r-1);
    
          tag   : out std_logic_vector(0 to r-1);
          ct    : out std_logic_vector(0 to r-1));
end entity aead;

architecture behavioural of aead is
    
    signal x : std_logic_vector(0 to 287);
    signal y : std_logic_vector(0 to 287);
    signal z : std_logic_vector(0 to r-1);
    
    signal init : std_logic_vector(0 to 287);

begin

    tag <= z;
    ct  <= z xor sc_data;

    init <= key & (0 to 12 => '0') & iv & (0 to 111 => '0') & "111";
    
    sreg  : entity work.sreg port map (clk, load, init, y, x);
    ufunc : entity work.ufunc generic map (r) port map (x, mac_data, y, z);

end architecture behavioural;
