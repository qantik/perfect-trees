#!/usr/bin/tcsh

# (10 ns, 100 MHz), (100 ns, 10 MHz), (1000 ns, 1 MHz), (5000 ns, 0.5 MHz)
foreach f (100)

  @ period = $f / 2
  
  sed -i 's/.*create_clock.*/create_clock -name "clk" -period '$f' -waveform { 0 '$period' } { clk } /' ./compile.tcl
  sed -i 's/.*constant clk_period .*/    constant clk_period   : time := '$f' ns;/' ../triad_tb.vhd

  foreach l (`cat trees_triad.txt`)
    echo '=============================== '$l
    
    # a1, b1, c1, fa, fb, fc, a2, b2, c2, fy, fz
    set split=( $l:as/,/ / )
    sed -i 's/.*constant a1 : .*/    constant a1 : integer := '$split[1]';--68/' ../ufunc.vhd
    sed -i 's/.*constant b1 : .*/    constant b1 : integer := '$split[2]';--144/' ../ufunc.vhd
    sed -i 's/.*constant c1 : .*/    constant c1 : integer := '$split[3]';--236/' ../ufunc.vhd
    
    sed -i 's/.*constant fa : .*/    constant fa : integer := '$split[4]';--74/' ../ufunc.vhd
    sed -i 's/.*constant fb : .*/    constant fb : integer := '$split[5]';--146/' ../ufunc.vhd
    sed -i 's/.*constant fc : .*/    constant fc : integer := '$split[6]';--252/' ../ufunc.vhd
    
    sed -i 's/.*constant a2 : .*/    constant a2 : integer := '$split[7]';--80/' ../ufunc.vhd
    sed -i 's/.*constant b2 : .*/    constant b2 : integer := '$split[8]';--88/' ../ufunc.vhd
    sed -i 's/.*constant c2 : .*/    constant c2 : integer := '$split[9]';--88/' ../ufunc.vhd
    
    sed -i 's/.*constant ay : .*/    constant ay : integer := '$split[10]';--165/' ../ufunc.vhd
    sed -i 's/.*constant az : .*/    constant az : integer := '$split[11]';--253/' ../ufunc.vhd
  
    dc_shell -f compile.tcl > /dev/null
    source analyze.sh > out.txt
    dc_shell -f power.tcl > /dev/null
  
    set pow=`grep 'Total    ' powercon_lp.txt | awk -F'  +' '{print $5}' | grep -Eo '[0-9]+\.[0-9]+(e[+|-]0[1-9])?'`
  
    echo $split[12]' '$pow >> triad-$f-ns.dat  
  end

end

set pid=$$
kill $pid
