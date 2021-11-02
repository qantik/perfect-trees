library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity kreyvium_tb is
end entity kreyvium_tb;

architecture bench of kreyvium_tb is
    constant r  : integer := 256;
    
    signal clk     : std_logic := '1';
    signal reset_n : std_logic := '1';

    signal key : std_logic_vector(127 downto 0);
    signal iv  : std_logic_vector(127 downto 0);
    
    signal ready : std_logic;
    signal ks    : std_logic_vector(r-1 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := clk_period/4;

begin
  
    kreyvium : entity work.kreyvium port map (clk, reset_n, key, iv, ready, ks);
    
    clk_process : process
    	variable count : integer := 0;
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process clk_process;
    
    test : process
        file vec_file     : text;
        variable vec_line : line;
	    variable vec_key  : std_logic_vector(127 downto 0);
	    variable vec_iv   : std_logic_vector(127 downto 0);
	    variable vec_ks   : std_logic_vector(255 downto 0);

        variable round : integer := 0;
    begin

	file_open(vec_file, "../test_vectors/vectors.txt", read_mode);

	while not endfile(vec_file) loop
        report "Vector: " & integer'image(round); round := round + 1;

        readline(vec_file, vec_line); -- scratch vector number

	    readline(vec_file, vec_line);
	    hread(vec_line, vec_key);
	    readline(vec_file, vec_line);
	    hread(vec_line, vec_iv);
	    readline(vec_file, vec_line);
	    hread(vec_line, vec_ks);

	    key <= vec_key;
	    iv  <= vec_iv;

        reset_n <= '0';
        wait for reset_period;
        reset_n <= '1';

        wait until ready = '1';
        wait for reset_period;

        for i in 1 to 256/r loop
            assert ks = vec_ks(255-((i-1)*r) downto (256-r)-(i-1)*r)
                report "incorrect keystream" severity failure;
            
            wait until rising_edge(clk);
            wait for reset_period;
        end loop;

	end loop;

    assert false report "test finished" severity failure;

    end process test;

end architecture bench;
