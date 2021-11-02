#!/usr/bin/tcsh

# (10 ns, 100 MHz), (100 ns, 10 MHz), (1000 ns, 1 MHz), (5000 ns, 0.5 MHz)
foreach f (100)

  @ period = $f / 2
  
  sed -i 's/.*create_clock.*/create_clock -name "clk" -period '$f' -waveform { 0 '$period' } { clk } /' ./compile.tcl
  sed -i 's/.*constant clk_period .*/    constant clk_period   : time := '$f' ns;/' ../kreyvium_tb.vhd

  foreach l (`cat kreyvium_trees.txt`)
    echo '=============================== '$l
    
    # a1, b1, c1, fa, fb, fc, a2, b2, c2
    set split=( $l:as/,/ / )
    sed -i 's/.*constant a1 : .*/    constant a1 : integer := '$split[1]';--66/' ../ufunc.vhd
    sed -i 's/.*constant b1 : .*/    constant b1 : integer := '$split[2]';--162/' ../ufunc.vhd
    sed -i 's/.*constant c1 : .*/    constant c1 : integer := '$split[3]';--243/' ../ufunc.vhd
   
    sed -i 's/.*constant fa : .*/    constant fa : integer := '$split[4]';--69/' ../ufunc.vhd
    sed -i 's/.*constant fb : .*/    constant fb : integer := '$split[5]';--171/' ../ufunc.vhd
    sed -i 's/.*constant fc : .*/    constant fc : integer := '$split[6]';--264/' ../ufunc.vhd
    
    sed -i 's/.*constant a2 : .*/    constant a2 : integer := '$split[7]';--93/' ../ufunc.vhd
    sed -i 's/.*constant b2 : .*/    constant b2 : integer := '$split[8]';--84/' ../ufunc.vhd
    sed -i 's/.*constant c2 : .*/    constant c2 : integer := '$split[9]';--111/' ../ufunc.vhd
  
    dc_shell -f compile.tcl > /dev/null
    source analyze.sh > out.txt
    dc_shell -f power.tcl > /dev/null
  
    set pow=`grep 'Total    ' powercon_lp.txt | awk -F'  +' '{print $5}' | grep -Eo '[0-9]+\.[0-9]+(e[+|-]0[1-9])?'`
  
    echo $split[10]' '$pow >> kreyvium-$f-ns.dat  
  end

end

set pid=$$
kill $pid
