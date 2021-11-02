library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ufunc is
    generic (r : integer);
    port (x    : in std_logic_vector(255 downto 0);
          init : in std_logic;

          y : out std_logic_vector(255 downto 0);
          z : out std_logic_vector(r-1 downto 0));
end entity ufunc;

architecture parallel of ufunc is

    signal n : std_logic_vector(127+r downto 0);
    signal l : std_logic_vector(127+r downto 0);
    
    signal ks : std_logic_vector(r-1 downto 0);
    
    signal t1, t2 : std_logic_vector(r-1 downto 0);

    constant f1 : integer  := 32;   --92;    
    constant f2 : integer  := 47;   --95;   
    constant f3 : integer  := 58;   --119;  
    constant f4 : integer  := 90;   --120;  
    constant f5 : integer  := 121;  --122;  
                                          
    constant n1 : integer  := 32;   --78;   
    constant n2 : integer  := 37;   --81;   
    constant n3 : integer  := 72;   --85;   
    constant n4 : integer  := 102;  --88;   
    constant n5 : integer  := 44;   --94;   
    constant n6 : integer  := 60;   --97;   
    constant n7 : integer  := 61;   --98;   
    constant n8 : integer  := 125;  --102;  
    constant n9 : integer  := 63;   --104;  
    constant n10 : integer := 67;   --105;  
    constant n11 : integer := 69;   --106;  
    constant n12 : integer := 101;  --112;  
    constant n13 : integer := 80;   --114;  
    constant n14 : integer := 88;   --117;  
    constant n15 : integer := 110;  --120;  
    constant n16 : integer := 111;  --122;  
    constant n17 : integer := 115;  --125;  
    constant n18 : integer := 117;  --126;

    constant n19 : integer := 46; 
    constant n20 : integer := 50; 
    constant n21 : integer := 58; 
    constant n22 : integer := 103; 
    constant n23 : integer := 104; 
    constant n24 : integer := 106; 
    constant n25 : integer := 33; 
    constant n26 : integer := 35; 
    constant n27 : integer := 36; 
    constant n28 : integer := 40; 

begin

    n(r+127 downto r) <= x(255 downto 128);
    l(r+127 downto r) <= x(127 downto 0);

    z <= ks;
	    
    l(r-1 downto 0) <= t1(r-1 downto 0) xor ks when init = '1' else t1(r-1 downto 0);  
    n(r-1 downto 0) <= t2(r-1 downto 0) xor ks when init = '1' else t2(r-1 downto 0);  
    
    y <= n(127 downto 0) & l(127 downto 0);

    -- restricted
    alg : for i in 0 to r-1 generate
    
        lin : entity work.lin port map (
            l(r + f1 - 1 - i),
            l(r + f2 - 1 - i),
            l(r + f3 - 1 - i),
            l(r + f4 - 1 - i),
            l(r + f5 - 1 - i),
            l(r + 128 - 1 - i),
            
            t1(r-i-1) 
        );
        
        non : entity work.non port map (
            n(r + n1 - 1 - i),
            n(r + n2 - 1 - i),
            n(r + n3 - 1 - i),
            n(r + n4 - 1 - i),
            n(r + 128 - 1 - i),
            n(r + n5 - 1 - i),
            n(r + n6 - 1 - i),
            n(r + n7 - 1 - i),
            n(r + n8 - 1 - i),
            n(r + n9 - 1 - i),
            n(r + n10 - 1 - i),
            n(r + n11 - 1 - i),
            n(r + n12 - 1 - i),
            n(r + n13 - 1 - i),
            n(r + n14 - 1 - i),
            n(r + n15 - 1 - i),
            n(r + n16 - 1 - i),
            n(r + n17 - 1 - i),
            n(r + n18 - 1 - i),

            n(r + n19 - 1 - i),
            n(r + n20 - 1 - i),
            n(r + n21 - 1 - i),
            n(r + n22 - 1 - i),
            n(r + n23 - 1 - i),
            n(r + n24 - 1 - i),
            n(r + n25 - 1 - i),
            n(r + n26 - 1 - i),
            n(r + n27 - 1 - i),
            n(r + n28 - 1 - i),

            l(127+r-i),
            t2(r-i-1) 
        );
        
        h : entity work.h port map (
            n(r + 116 - 1 - i),
            l(r + 120 - 1 - i),
            l(r + 115 - 1 - i),
            l(r + 108 - 1 - i),
            n(r + 33 - 1 - i),
            l(r + 86 - 1 - i),
            l(r + 68 - 1 - i),
            l(r + 49 - 1 - i),
            l(r + 34 - 1 - i),

            n(r + 126 - 1 - i),
            n(r + 113 - 1 - i),
            n(r + 92 - 1 - i),
            n(r + 83 - 1 - i),
            n(r + 64 - 1 - i),
            n(r + 55 - 1 - i),
            n(r + 39 - 1 - i),

            l(r + 35 - 1 - i),

            ks(r-1-i)
        );
        
    end generate alg;
   
    -- regular, restricted
    --alg : for i in 0 to r-1 generate
    --        t1(r-i-1) <= l(r + f1 - 1 - i) xor l(r + f2 - 1 - i) xor l(r + f3 - 1 - i) xor
    --    		 l(r + f4 - 1 - i) xor l(r + f5 - 1 - i) xor l(r + 128 - 1 - i);

    --        t2(r-i-1) <= n(r + n1 - 1 - i) xor n(r + n2 - 1 - i) xor n(r + n3 - 1 - i) xor
    --    		 n(r + n4 - 1 - i) xor n(r + 128 - 1 - i) xor
    --    		 (n(r + n5 - 1 - i) and n(r + n6 - 1 - i)) xor
    --    		 (n(r + n7 - 1 - i) and n(r + n8 - 1 - i)) xor
    --    		 (n(r + n9 - 1 - i) and n(r + n10 - 1 - i)) xor
    --    		 (n(r + n11 - 1 - i) and n(r + n12 - 1 - i)) xor
    --    		 (n(r + n13 - 1 - i) and n(r + n14 - 1 - i)) xor
    --    		 (n(r + n15 - 1 - i) and n(r + n16 - 1 - i)) xor
    --    		 (n(r + n17 - 1 - i) and n(r + n18 - 1 - i)) xor l(127+r-i) xor
	--		 (n(r + n19 - 1 - i) and n(r + n20 - 1 - i) and n(r + n21 - 1 - i)) xor
	--		 (n(r + n22 - 1 - i) and n(r + n23 - 1 - i) and n(r + n24 - 1 - i)) xor
	--		 (n(r + n25 - 1 - i) and n(r + n26 - 1 - i) and n(r + n27 - 1 - i) and n(r + n28 - 1 - i));
    --       
    --        ks(r-1-i) <= (n(r + 116 - 1 - i) and l(r + 120 - 1 - i)) xor (l(r + 115 - 1 - i) and l(r + 108 - 1 - i)) xor
    --    		 (n(r + 33 - 1 - i) and l(r + 86 - 1 - i)) xor (l(r + 68 - 1 - i) and l(r + 49 - 1 - i)) xor
    --    		 (n(r + 116 - 1 - i) and n(r + 33 - 1 - i) and l(r + 34 - 1 - i)) xor
    --    		 n(r + 126 - 1 - i) xor n(r + 113 - 1 - i) xor n(r + 92 - 1 - i) xor
    --    		 n(r + 83 - 1 - i) xor n(r + 64 - 1 - i) xor n(r + 55 - 1 - i) xor
    --    		 n(r + 39 - 1 - i) xor l(r + 35 - 1 - i);

    --end generate alg;
    
end architecture parallel;

