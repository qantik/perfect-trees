#!/usr/bin/tcsh

# (10 ns, 100 MHz), (100 ns, 10 MHz), (1000 ns, 1 MHz), (5000 ns, 0.5 MHz)
foreach f (10 100 1000 5000)
  
  @ period = $f / 2
  
  sed -i 's/.*create_clock.*/create_clock -name "clk" -period '$f' -waveform { 0 '$period' } { clk } /' ./compile.tcl
  sed -i 's/.*constant clk_period .*/    constant clk_period   : time := '$f' ns;/' ../trivium_mb_tb.vhd

  foreach r (`seq 288 288`)
    echo '=============================== '$r
  
    sed -i 's/.*generic (r .*/    generic (r : integer := '$r');/' ../trivium_mb.vhd
    sed -i 's/.*constant r .*/    constant r  : integer := '$r';/' ../trivium_mb_tb.vhd
    
    dc_shell -f compile.tcl > /dev/null
    source analyze.sh > out.txt
    dc_shell -f power.tcl > /dev/null
   
    set area=`grep "Total cell area:" area.txt | grep -E -o "[1-9]+\.[0-9]+"`
    set pic=`grep "Assertion FAILURE at " out.txt | grep -E -o "[0-9]*"`
    set sec = `echo 'print '$pic' * 0.000000000001' | python`
    
    set pow=`grep 'Total    ' powercon_lp.txt | awk -F'  +' '{print $5}' | grep -Eo '[0-9]+\.[0-9]+(e[+|-]0[1-9])?'`
    set ene=`echo 'print '$pow' * 0.001 * '$sec | python`
    
    echo $r' '$area' '$pic' '$sec' '$pow' '$ene >> trivium-mb-$f-ns.dat
  end

end

set pid=$$
kill $pid
