library ieee;
use ieee.std_logic_1164.all;

entity acc_reg is
    generic (r : integer := 2);
    port (clk : in std_logic;
         
          init : in  std_logic;
          upd  : in  std_logic;
          d0   : in  std_logic_vector(r-1 downto 0);
          d1   : in  std_logic_vector(63 downto 0);
          q    : out std_logic_vector(63 downto 0));
end entity acc_reg;

architecture behavioural of acc_reg is
    signal x : std_logic_vector(63 downto 0);
begin

    q <= x;

    gen1 : if r < 64 generate
        state : process(clk)
        begin
            if rising_edge(clk) then
                if init = '1' then
                    x <= x(63-r downto 0) & d0;
                elsif upd = '1' then
                    x <= d1;
                end if;
            end if;
        end process state;
    end generate;
    
    gen2 : if r = 64 generate
        state : process(clk)
        begin
            if rising_edge(clk) then
                if init = '1' then
                    x <= d0;
                elsif upd = '1' then
                    x <= d1;
                end if;
            end if;
        end process state;
    end generate;
    
    gen3 : if r = 128 generate
        state : process(clk)
        begin
            if rising_edge(clk) then
                if init = '1' then
                    x <= d0(127 downto 64);
                elsif upd = '1' then
                    x <= d1;
                end if;
            end if;
        end process state;
    end generate;

end architecture behavioural;

