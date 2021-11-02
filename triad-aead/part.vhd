library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part is
    port (x1,x2,x3,x4,x5 : in std_logic;
          m              : in std_logic; 
          a              : out std_logic; 
          y              : out std_logic);
end entity part;

architecture parallel of part is
    signal b : std_logic;
begin

    b <= x1 xor x2;
    a <= b;

    y <= b xor (x3 and x4) xor x5 xor m;

end architecture parallel;
