library ieee;
use ieee.std_logic_1164.all;

entity sreg is
    port (clk : in std_logic;
         
          sel : in  std_logic;
          d0  : in  std_logic_vector(255 downto 0);
          d1  : in  std_logic_vector(255 downto 0);
          q   : out std_logic_vector(255 downto 0));
end entity sreg;

architecture behavioural of sreg is
begin

    state : process(clk)
    begin
        if rising_edge(clk) then
            if sel = '0' then
                q <= d0;
            else
                q <= d1;
            end if;
        end if;
    end process state;

end architecture behavioural;

