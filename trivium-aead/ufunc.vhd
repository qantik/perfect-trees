library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ufunc is
    generic (r : integer);
    port (x : in std_logic_vector(0 to 287);
          m : in std_logic_vector(0 to r-1); 

          y : out std_logic_vector(0 to 287);
          z : out std_logic_vector(0 to r-1));
end entity ufunc;

architecture parallel of ufunc is

    -- Trivium, Trivium-LE
    constant a1 : integer := 87;--66, 87
    constant b1 : integer := 159;--162, 159
    constant c1 : integer := 267;--243, 267

    constant a2 : integer := 93;--93, 93
    constant b2 : integer := 99;--84, 99
    constant c2 : integer := 96;--111, 96

    constant fa : integer := 78;--69, 78
    constant fb : integer := 183;--171, 183
    constant fc : integer := 279;--264, 279

    signal r1 : std_logic_vector(0 to (a2-1)+r);
    signal r2 : std_logic_vector(0 to (b2-1)+r);
    signal r3 : std_logic_vector(0 to (c2-1)+r);
    
    signal o1 : std_logic_vector(0 to r-1);
    signal o2 : std_logic_vector(0 to r-1);
    signal o3 : std_logic_vector(0 to r-1);
    
    signal tmp1 : std_logic_vector(0 to r-1);
    signal tmp2 : std_logic_vector(0 to r-1);
    signal tmp3 : std_logic_vector(0 to r-1);
    
begin

    r1(r to r+(a2-1)) <= x(0 to a2-1);
    r2(r to r+(b2-1)) <= x(a2 to (a2+b2)-1) xor (m(5) & m(4) & m(3) & m(2) & m(1) & m(0) & (92 downto 0 => '0'));
    r3(r to r+(c2-1)) <= x(a2+b2 to (a2+b2+c2)-1);
    
    alg_p1 : for i in 0 to r-1 generate
        p1 : entity work.part port map (
        	r3((c1-1) + (r-(a2+b2)) - i),
        	r3(((a2+b2+c2)-1) + (r-(a2+b2)) - i),
            --r3(((a2+b2+c2)-3) + (r-(a2+b2)) - i),
        	--r3(((a2+b2+c2)-2) + (r-(a2+b2)) - i),
            r3((c1+0) + (r-(a2+b2)) - i), -- Trivium-LE2
            r3((c1+1) + (r-(a2+b2)) - i), -- Trivium-LE2
        	r1((fa-1) + r - i),
        	m(i),
            o3(i),
        	r1(r - i - 1)
        );
        z(i) <= o1(i) xor o2(i) xor o3(i);
    end generate alg_p1;
        
    alg_p2 : for i in r-1-5 to r-1 generate
        p2 : entity work.part1 port map (
        	r1((a1-1) + r - i),
        	r1((a2-1) + r - i),
            --r1((a2-3) + r - i),
        	--r1((a2-2) + r - i),
            r1((a1+0) + r - i), -- Trivium-LE2
        	r1((a1+1) + r - i), -- Trivium-LE2
        	r2((fb-1) + (r-a2) - i),
            o1(i),
        	r2(r - i - 1)
        );
    end generate alg_p2;
    
    alg_p21 : for i in 0 to r-2-5 generate
        p2 : entity work.part port map (
        	r1((a1-1) + r - i),
        	r1((a2-1) + r - i),
            --r1((a2-3) + r - i),
        	--r1((a2-2) + r - i),
            r1((a1+0) + r - i), -- Trivium-LE2
        	r1((a1+1) + r - i), -- Trivium-LE2
        	r2((fb-1) + (r-a2) - i),
        	m(i+6),
            o1(i),
        	r2(r - i - 1)
        );
    end generate alg_p21;

    alg32 : for i in 0 to r-1 generate
        p3 : entity work.part port map (
        	r2((b1-1) + (r-a2) - i),
        	r2(((a2+b2)-1) + (r-a2) - i),
            --r2(((a2+b2)-3) + (r-a2) - i),
        	--r2(((a2+b2)-2) + (r-a2) - i),
        	r2((b1+0) + (r-a2) - i), -- Trivium-LE2
        	r2((b1+1) + (r-a2) - i), -- Trivium-LE2
        	r3((fc-1) + (r-(a2+b2)) - i),
        	m(i),
        	o2(i),
        	r3(r - i - 1)
        );
        
    end generate alg32;
    
    y <= r1(0 to a2-1) & r2(0 to b2-1) & r3(0 to c2-1);

end architecture parallel;

