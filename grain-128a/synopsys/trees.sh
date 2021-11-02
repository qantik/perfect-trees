#!/usr/bin/tcsh

# (10 ns, 100 MHz), (100 ns, 10 MHz), (1000 ns, 1 MHz), (5000 ns, 0.5 MHz)
foreach f (100 1000 5000)

  @ period = $f / 2
  
  sed -i 's/.*create_clock.*/create_clock -name "clk" -period '$f' -waveform { 0 '$period' } { clk } /' ./compile.tcl
  sed -i 's/.*constant clk_period .*/    constant clk_period   : time := '$f' ns;/' ../grain_128a_tb.vhd

  foreach l (`shuf trees_grain128a.txt`)
    echo '=============================== '$l
    
    # a1, b1, c1, fa, fb, fc, a2, b2, c2
    set split=( $l:as/,/ / )
    sed -i 's/.*constant f1 : .*/    constant f1 : integer := '$split[5]';--32/' ../ufunc.vhd
    sed -i 's/.*constant f2 : .*/    constant f2 : integer := '$split[4]';--47/' ../ufunc.vhd
    sed -i 's/.*constant f3 : .*/    constant f3 : integer := '$split[3]';--58/' ../ufunc.vhd
    sed -i 's/.*constant f4 : .*/    constant f4 : integer := '$split[2]';--90/' ../ufunc.vhd
    sed -i 's/.*constant f5 : .*/    constant f5 : integer := '$split[1]';--121/' ../ufunc.vhd
    
    sed -i 's/.*constant n1 : .*/    constant n1 : integer := '$split[33]';--32/' ../ufunc.vhd
    sed -i 's/.*constant n2 : .*/    constant n2 : integer := '$split[32]';--37/' ../ufunc.vhd
    sed -i 's/.*constant n3 : .*/    constant n3 : integer := '$split[31]';--72/' ../ufunc.vhd
    sed -i 's/.*constant n4 : .*/    constant n4 : integer := '$split[30]';--102/' ../ufunc.vhd
    sed -i 's/.*constant n5 : .*/    constant n5 : integer := '$split[29]';--44/' ../ufunc.vhd
    sed -i 's/.*constant n6 : .*/    constant n6 : integer := '$split[28]';--60/' ../ufunc.vhd
    sed -i 's/.*constant n7 : .*/    constant n7 : integer := '$split[27]';--61/' ../ufunc.vhd
    sed -i 's/.*constant n8 : .*/    constant n8 : integer := '$split[26]';--125/' ../ufunc.vhd
    sed -i 's/.*constant n9 : .*/    constant n9 : integer := '$split[25]';--63/' ../ufunc.vhd
    sed -i 's/.*constant n10 : .*/    constant n10 : integer := '$split[24]';--67/' ../ufunc.vhd
    sed -i 's/.*constant n11 : .*/    constant n11 : integer := '$split[23]';--69/' ../ufunc.vhd
    sed -i 's/.*constant n12 : .*/    constant n12 : integer := '$split[22]';--101/' ../ufunc.vhd
    sed -i 's/.*constant n13 : .*/    constant n13 : integer := '$split[21]';--80/' ../ufunc.vhd
    sed -i 's/.*constant n14 : .*/    constant n14 : integer := '$split[20]';--88/' ../ufunc.vhd
    sed -i 's/.*constant n15 : .*/    constant n15 : integer := '$split[19]';--110/' ../ufunc.vhd
    sed -i 's/.*constant n16 : .*/    constant n16 : integer := '$split[18]';--111/' ../ufunc.vhd
    sed -i 's/.*constant n17 : .*/    constant n17 : integer := '$split[17]';--115/' ../ufunc.vhd
    sed -i 's/.*constant n18 : .*/    constant n18 : integer := '$split[16]';--117/' ../ufunc.vhd
   
    # 128a 
    sed -i 's/.*constant n19 : .*/    constant n19 : integer := '$split[15]';--46/' ../ufunc.vhd
    sed -i 's/.*constant n20 : .*/    constant n20 : integer := '$split[14]';--50/' ../ufunc.vhd
    sed -i 's/.*constant n21 : .*/    constant n21 : integer := '$split[13]';--58/' ../ufunc.vhd
    sed -i 's/.*constant n22 : .*/    constant n22 : integer := '$split[12]';--103/' ../ufunc.vhd
    sed -i 's/.*constant n23 : .*/    constant n23 : integer := '$split[11]';--104/' ../ufunc.vhd
    sed -i 's/.*constant n24 : .*/    constant n24 : integer := '$split[10]';--106/' ../ufunc.vhd
    sed -i 's/.*constant n25 : .*/    constant n25 : integer := '$split[9]';--33/' ../ufunc.vhd
    sed -i 's/.*constant n26 : .*/    constant n26 : integer := '$split[8]';--35/' ../ufunc.vhd
    sed -i 's/.*constant n27 : .*/    constant n27 : integer := '$split[7]';--36/' ../ufunc.vhd
    sed -i 's/.*constant n28 : .*/    constant n28 : integer := '$split[6]';--40/' ../ufunc.vhd
  
    dc_shell -f compile.tcl > /dev/null
    source analyze.sh > out.txt
    dc_shell -f power.tcl > /dev/null
  
    set pow=`grep 'Total    ' powercon_lp.txt | awk -F'  +' '{print $5}' | grep -Eo '[0-9]+\.[0-9]+(e[+|-]0[1-9])?'`
  
    echo $split[34]' '$pow >> grain128a-$f-ns.dat  
  end

end

set pid=$$
kill $pid
