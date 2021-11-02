library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity grain_128aead_tb is
end entity grain_128aead_tb;

architecture bench of grain_128aead_tb is
    constant r  : integer := 32;
    
    signal clk     : std_logic := '1';
    signal reset_n : std_logic := '1';

    signal key  : std_logic_vector(127 downto 0);
    signal iv   : std_logic_vector(95 downto 0);
    signal data : std_logic_vector(r/2-1 downto 0);

    signal part_key : std_logic_vector(r-1 downto 0);
    signal feed_key : std_logic;
    
    signal ready : std_logic;
    signal tag   : std_logic_vector(63 downto 0);
    signal ct    : std_logic_vector(r/2-1 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := clk_period/4;

begin
  
    grain_128aead : entity work.grain_128aead port map (clk, reset_n, key, iv, data, part_key, feed_key, ready, tag, ct);
    
    clk_process : process
    	variable count : integer := 0;
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process clk_process;
    
    test : process
        file vec_file      : text;
        variable vec_line  : line;
        variable vec_space : character;
        
        variable vec_id      : integer;
        variable vec_ad_len  : integer;
        variable vec_msg_len : integer;
	    variable vec_key     : std_logic_vector(127 downto 0);
	    variable vec_iv      : std_logic_vector(95 downto 0);
	    variable vec_data    : std_logic_vector(63 downto 0);
	    variable vec_tag     : std_logic_vector(63 downto 0);
	    variable vec_ct      : std_logic_vector(r/2-1 downto 0);

        variable b : integer := 0;

        variable round : integer := 0;
    begin

	file_open(vec_file, "../test_vectors/vectors.txt", read_mode);

	while not endfile(vec_file) loop
        report "Vector: " & integer'image(round); round := round + 1;

        readline(vec_file, vec_line);
        read(vec_line, vec_id); read(vec_line, vec_space);
        read(vec_line, vec_ad_len); read(vec_line, vec_space);
        read(vec_line, vec_msg_len);

	    readline(vec_file, vec_line);
	    hread(vec_line, vec_key);
	    readline(vec_file, vec_line);
	    hread(vec_line, vec_iv);

	    key      <= vec_key;
	    iv       <= vec_iv;
        part_key <= (others => '0');
        data     <= (others => '0');

        reset_n <= '0';
        wait for reset_period;
        reset_n <= '1';

        wait until feed_key = '1';
        for i in 1 to 128/r loop
            part_key <= vec_key(127-r*(i-1) downto 128-r*i);
            wait until rising_edge(clk);
        end loop;
        
        wait until ready = '1';
        part_key <= (others => '0');

        if r = 1 then
            b := 1;
        else
            b := r/2;
        end if;

        for i in 0 to vec_ad_len-1 loop
	        readline(vec_file, vec_line);
	        hread(vec_line, vec_data);
            for j in 0 to 64/(b)-1 loop
                data <= vec_data(63-(b)*j downto 64-(b)*(j+1));
                wait until rising_edge(clk);
            end loop;
        end loop;
        
        for i in 0 to vec_msg_len-1 loop
	        readline(vec_file, vec_line);
	        hread(vec_line, vec_data);
            for j in 0 to 64/(b)-1 loop
                data <= vec_data(63-(b)*j downto 64-(b)*(j+1));
                wait until rising_edge(clk);
            end loop;
        end loop;

        wait for 2*reset_period;
	    readline(vec_file, vec_line);
	    hread(vec_line, vec_tag);
        for i in 1 to 256/r loop
            assert tag = vec_tag report "incorrect tag" severity failure;
        end loop;

	end loop;

    assert false report "test finished" severity failure;

    end process test;

end architecture bench;
