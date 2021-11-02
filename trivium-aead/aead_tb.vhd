library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity aead_tb is
end entity aead_tb;

architecture bench of aead_tb is
    constant r  : integer := 288;
    
    signal clk     : std_logic;
    signal load    : std_logic;

    signal key : std_logic_vector(79 downto 0);
    signal iv  : std_logic_vector(79 downto 0);

    signal mac_data : std_logic_vector(r-1 downto 0);
    signal sc_data  : std_logic_vector(r-1 downto 0);
    
    signal tag : std_logic_vector(r-1 downto 0);
    signal ct  : std_logic_vector(r-1 downto 0);

    constant clk_period   : time := 100 ns;
    constant reset_period : time := clk_period/4;

begin
  
    aead : entity work.aead port map (clk, load, key, iv, mac_data, sc_data, tag, ct);
    
    clk_process : process
    	variable count : integer := 0;
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process clk_process;
    
    test : process
        file vec_file      : text;
        variable vec_line  : line;
        variable vec_space : character;

        variable vec_id      : integer;
        variable vec_mac_len : integer;
        variable vec_ct_len  : integer;
	    variable vec_key     : std_logic_vector(79 downto 0);
	    variable vec_iv      : std_logic_vector(79 downto 0);
	    variable vec_ks      : std_logic_vector(287 downto 0);
	    variable vec_data    : std_logic_vector(287 downto 0);
	    variable vec_tag     : std_logic_vector(287 downto 0);

        variable round : integer := 0;
    begin

	file_open(vec_file, "../test_vectors/vectors.txt", read_mode);

	while not endfile(vec_file) loop
        report "Vector: " & integer'image(round); round := round + 1;

        readline(vec_file, vec_line);
        read(vec_line, vec_id); read(vec_line, vec_space);
        read(vec_line, vec_mac_len); read(vec_line, vec_space);
        read(vec_line, vec_ct_len);

	    readline(vec_file, vec_line); hread(vec_line, vec_key);
	    readline(vec_file, vec_line); hread(vec_line, vec_iv);

	    key      <= vec_key;
	    iv       <= vec_iv;
        mac_data <= (others => 'X');
        sc_data  <= (others => '0');
        load     <= '1';

        for i in 0 to vec_mac_len-1 loop
	        readline(vec_file, vec_line); hread(vec_line, vec_data);

            for j in 0 to 288/r-1 loop
                wait until rising_edge(clk);
                mac_data <= vec_data(287-r*(j) downto 288-r*(j+1));
            
                if i = 0 and j = 0 then 
                wait for 0.5*clk_period;
                load <= '0';
                end if;

                if i = vec_mac_len-1 and j = 0 then

                    wait for 0.5*clk_period;
	                readline(vec_file, vec_line); hread(vec_line, vec_tag);
                    assert vec_tag(287 downto 288-r) = tag report "incorrect tag" severity failure;
                end if;
                if i = vec_mac_len-1 and j = 288/r-1 then
                    load <= '1';
                end if;
            end loop;
        end loop;
       
        for i in 0 to vec_ct_len-1 loop
            readline(vec_file, vec_line); hread(vec_line, vec_data);
            for j in 0 to 288/r-1 loop
                wait until rising_edge(clk);

                if i = 0 and j = 0 then
                    load <= '0';
                end if;
	            
                if i <= 3 then
                    mac_data <= vec_data(287-r*(j) downto 288-r*(j+1));
                    sc_data  <= (others => '0');
                else
                    mac_data <= (others => '0');
                    sc_data  <= vec_data(287-r*(j) downto 288-r*(j+1));
                end if;
            end loop;
        end loop;
	
    end loop;

    assert false report "test finished" severity failure;

    end process test;

end architecture bench;
