library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ufunc is
    generic (r : integer);
    port (x   : in std_logic_vector(0 to 287);
          key : in std_logic_vector(0 to 127); 
          iv  : in std_logic_vector(0 to 127); 

          y : out std_logic_vector(0 to 287);
          z : out std_logic_vector(0 to r-1));
end entity ufunc;

architecture parallel of ufunc is

    constant a1 : integer := 66;
    constant b1 : integer := 162;
    constant c1 : integer := 243;

    constant a2 : integer := 93;
    constant b2 : integer := 84;
    constant c2 : integer := 111;

    constant fa : integer := 69;
    constant fb : integer := 171;
    constant fc : integer := 264;

    signal r1 : std_logic_vector(0 to (a2-1)+r);
    signal r2 : std_logic_vector(0 to (b2-1)+r);
    signal r3 : std_logic_vector(0 to (c2-1)+r);
    
    signal o1 : std_logic_vector(0 to r-1);
    signal o2 : std_logic_vector(0 to r-1);
    signal o3 : std_logic_vector(0 to r-1);

begin

    r1(r to r+(a2-1))  <= x(0 to a2-1);
    r2(r to r+(b2-1))  <= x(a2 to (a2+b2)-1);
    r3(r to r+(c2-1))  <= x(a2+b2 to (a2+b2+c2)-1);

    alg : for i in 0 to r-1 generate
        p1 : entity work.part generic map (true) port map (
        	r3((c1-1) + (r-(a2+b2)) - i),
        	r3(((a2+b2+c2)-1) + (r-(a2+b2)) - i),
            r3(((a2+b2+c2)-3) + (r-(a2+b2)) - i),
        	r3(((a2+b2+c2)-2) + (r-(a2+b2)) - i),
        	r1((fa-1) + r - i),
		    key(i mod 128),
            o3(i),
        	r1(r - i - 1)
        );
        
        p2 : entity work.part generic map(false) port map (
            r1((a1-1) + r - i),
        	r1((a2-1) + r - i),
            r1((a2-3) + r - i),
        	r1((a2-2) + r - i),
        	r2((fb-1) + (r-a2) - i),
		    iv(i mod 128),
            o1(i),
        	r2(r - i - 1)
        );

        p3 : entity work.part_orig port map (
        	r2((b1-1) + (r-a2) - i),
        	r2(((a2+b2)-1) + (r-a2) - i),
            r2(((a2+b2)-3) + (r-a2) - i),
        	r2(((a2+b2)-2) + (r-a2) - i),
        	r3((fc-1) + (r-(a2+b2)) - i),
        	o2(i),
        	r3(r - i - 1)
        );
        
        z(i) <= o1(i) xor o2(i) xor o3(i);
    end generate alg;
    
    y <= r1(0 to a2-1) & r2(0 to b2-1) & r3(0 to c2-1);

end architecture parallel;

