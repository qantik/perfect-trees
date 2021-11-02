library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acc_ufunc is
    generic (r : integer);
    port (a_x  : in std_logic_vector(63 downto 0);
          r_x  : in std_logic_vector(63 downto 0);
          m    : in std_logic_vector(r-1 downto 0);
          z    : in std_logic_vector(r-1 downto 0);

          a_y : out std_logic_vector(63 downto 0);
          r_y : out std_logic_vector(63 downto 0));
end entity acc_ufunc;

architecture parallel of acc_ufunc is

    type table is array (0 to r) of std_logic_vector(63 downto 0);
    signal a_tmp : table;
    signal r_tmp : table;

begin

  a_tmp(0) <= a_x;
  r_tmp(0) <= r_x;

  gen : for i in 1 to r generate
      a_tmp(i) <= a_tmp(i-1) xor ((63 downto 0 => m(r-i)) and r_tmp(i-1));
      r_tmp(i) <= r_tmp(i-1)(62 downto 0) & z(r-i);
  end generate;

  a_y <= a_tmp(r);
  r_y <= r_tmp(r);

end architecture parallel;

