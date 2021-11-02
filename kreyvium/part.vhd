library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity part is
    generic (left : boolean := true);
    port (x1,x2,x3,x4,x5,kiv : in std_logic;
          a                  : out std_logic; 
          y                  : out std_logic);
end entity part;

architecture parallel of part is
    signal b : std_logic;
begin

    lt : if left = true generate
        b <= x1 xor x2 xor kiv;
        a <= b;

        y <= b xor (x3 and x4) xor x5;
    end generate;
    
    lf : if left = false generate
        b <= x1 xor x2;
        a <= b;

        y <= b xor (x3 and x4) xor x5 xor kiv;
    end generate;

end architecture parallel;
