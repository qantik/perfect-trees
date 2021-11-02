library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lin is
    port (x0, x1, x2, x3, x4, x5 : in std_logic;
          --f                      : in std_logic;
          y                      : out std_logic);
end entity lin;

architecture parallel of lin is
begin

    y <= x0 xor x1 xor x2 xor x3 xor x4 xor x5;

end architecture parallel;
