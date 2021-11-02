library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- trivium update function
entity ufunc is
    generic (r : integer);
    port (x : in std_logic_vector(0 to 255);
          m : in std_logic_vector(0 to r-1);

          y : out std_logic_vector(0 to 255);  -- updated state
          z : out std_logic_vector(0 to r-1)); -- keystream
end entity ufunc;

architecture parallel of ufunc is
    
    constant a1 : integer := 68;--68, 68
    constant b1 : integer := 144;--144, 144
    constant c1 : integer := 236;--236, 246

    constant a2 : integer := 80;--80
    constant b2 : integer := 88;--88
    constant c2 : integer := 88;--88

    constant fa : integer := 74;--74, 76
    constant fb : integer := 146;--146, 164
    constant fc : integer := 252;--252, 242

    constant na1 : integer := 73; -- a2-3, 73, 73
    constant na2 : integer := 79; -- a2-1, 79, 79
    
    constant nb1 : integer := 145; -- (a2+b2)-3, 145, 147
    constant nb2 : integer := 167; -- (a2+b2)-1, 167, 167
    
    constant nc1 : integer := 245; -- (a2+b2+c2)-3, 245, 251
    constant nc2 : integer := 255; -- (a2+b2+c2)-1, 255, 255
    
    constant ay : integer := 165;--165
    constant az : integer := 253;--253

    signal r1 : std_logic_vector(0 to (a2-1)+r);
    signal r2 : std_logic_vector(0 to (b2-1)+r);
    signal r3 : std_logic_vector(0 to (c2-1)+r);
    
    signal o1 : std_logic_vector(0 to r-1);
    signal o2 : std_logic_vector(0 to r-1);
    signal o3 : std_logic_vector(0 to r-1);

begin

    r1(r to r+(a2-1)) <= x(0 to a2-1);
    r2(r to r+(b2-1)) <= x(a2 to (a2+b2)-1);
    r3(r to r+(c2-1)) <= x(a2+b2 to (a2+b2+c2)-1);

    alg : for i in 0 to r-1 generate
        p1 : entity work.part port map (
		r3((c1-1) + (r-(a2+b2)) - i),
		r3((a2+b2+c2-1) + (r-(a2+b2)) - i),
                r3((nc1-1) + (r-(a2+b2)) - i),
		r3((nc2-1) + (r-(a2+b2)) - i),
		r1((fa-1) + r - i),
		m(i),
        	o3(i),
		r1(r - i - 1)
	);
        
        p2 : entity work.part1 port map (
		r1((a1-1) + r - i),
		r1((a2-1) + r - i),
                r1((na1-1) + r - i),
		r1((na2-1) + r - i),
		r2((fb-1) + (r-a2) - i),
		r2((ay-1) + (r-a2) - i),
		r3((az-1) + (r-(a2+b2)) - i),
		m(i),
        	o1(i),
		r2(r - i - 1)
	);

        p3 : entity work.part port map (
		r2((b1-1) + (r-a2) - i),
		r2((a2+b2-1) + (r-a2) - i),
                r2((nb1-1) + (r-a2) - i),
		r2((nb2-1) + (r-a2) - i),
		r3((fc-1) + (r-(a2+b2)) - i),
		m(i),
        	o2(i),
		r3(r - i - 1)
	);
        
	z(i) <= o1(i) xor o2(i) xor o3(i);

    end generate alg;

    y <= r1(0 to a2-1) & r2(0 to b2-1) & r3(0 to c2-1);
 
end architecture parallel;

