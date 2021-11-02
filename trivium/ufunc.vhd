library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ufunc is
    generic (r : integer);
    port (x : in  std_logic_vector(0 to 287);

          y : out std_logic_vector(0 to 287);  -- updated state
          z : out std_logic_vector(0 to r-1)); -- keystream
end entity ufunc;

architecture parallel of ufunc is

    -- Trivium, Trivium-LE
    constant a1 : integer := 66;  --66, 87
    constant b1 : integer := 162; --162, 159
    constant c1 : integer := 243; --243, 267

    constant a2 : integer := 93;  --93, 93
    constant b2 : integer := 84;  --84, 99
    constant c2 : integer := 111; --111, 96

    constant fa : integer := 69;  --69, 78
    constant fb : integer := 171; --171, 183
    constant fc : integer := 264; --264, 279

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
    
    y <= r1(0 to a2-1) & r2(0 to b2-1) & r3(0 to c2-1);

    -- restricted
    alg : for i in 0 to r-1 generate
        p1 : entity work.part port map (
        	r3((c1-1) + (r-(a2+b2)) - i),
        	r3(((a2+b2+c2)-1) + (r-(a2+b2)) - i),
            r3(((a2+b2+c2)-3) + (r-(a2+b2)) - i),
        	r3(((a2+b2+c2)-2) + (r-(a2+b2)) - i),
            --r3((c1+0) + (r-(a2+b2)) - i), -- Trivium-LE2
            --r3((c1+1) + (r-(a2+b2)) - i), -- Trivium-LE2
        	r1((fa-1) + r - i),
            o3(i),
        	r1(r - i - 1)
        );
        
        p2 : entity work.part port map (
            r1((a1-1) + r - i),
        	r1((a2-1) + r - i),
            r1((a2-3) + r - i),
        	r1((a2-2) + r - i),
            --r1((a1+0) + r - i), -- Trivium-LE2
        	--r1((a1+1) + r - i), -- Trivium-LE2
        	r2((fb-1) + (r-a2) - i),
            o1(i),
        	r2(r - i - 1)
        );

        p3 : entity work.part port map (
        	r2((b1-1) + (r-a2) - i),
        	r2(((a2+b2)-1) + (r-a2) - i),
            r2(((a2+b2)-3) + (r-a2) - i),
        	r2(((a2+b2)-2) + (r-a2) - i),
        	--r2((b1+0) + (r-a2) - i), -- Trivium-LE2
        	--r2((b1+1) + (r-a2) - i), -- Trivium-LE2
        	r3((fc-1) + (r-(a2+b2)) - i),
        	o2(i),
        	r3(r - i - 1)
        );
        
        z(i) <= o1(i) xor o2(i) xor o3(i);
    end generate alg;
    
    -- regular, ultra
    --alg : for i in 0 to r-1 generate
    --    o1(i) <= r1(65 + r - i)        xor r1(92 + r - i);
    --    o2(i) <= r2(161 + (r-93) - i)  xor r2(176 + (r-93) - i);
    --    o3(i) <= r3(242 + (r-177) - i) xor r3(287 + (r-177) - i);

    --    r1(r - i - 1) <= o3(i) xor (r3(285 + (r-177) - i) and r3(286 + (r-177) - i)) xor r1(68 + r - i);
    --    r2(r - i - 1) <= o1(i) xor (r1(90 + r - i)        and r1(91 + r - i))        xor r2(170 + (r-93) - i);
    --    r3(r - i - 1) <= o2(i) xor (r2(174 + (r-93) - i)  and r2(175 + (r-93) - i))  xor r3(263 + (r-177) - i);

    --    z(i) <= o1(i) xor o2(i) xor o3(i);
    --end generate alg;
   
end architecture parallel;

