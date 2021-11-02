sh rm -rf WORK/*
remove_design -all

define_design_lib WORK -path ./WORK
analyze -library WORK -format vhdl { \
../sreg.vhd \
../acc_reg.vhd \
../h.vhd \
../non.vhd \
../lin.vhd \
../ufunc.vhd \
../acc_ufunc.vhd \
../grain_128aead.vhd \
}

#elaborate ufunc -architecture parallel -library WORK
#compile -exact_map
#set_dont_touch [find design ufunc]

elaborate grain_128aead -architecture behavioural -library WORK
create_clock -name "clk" -period 10 -waveform { 0 50 } { clk } 

set_dont_use {tcbn90lphpbc0d77_ccs/MUX*}
set_dont_use {tcbn90lphpbc0d77_ccs/OAI*}
set_dont_use {tcbn90lphpbc0d77_ccs/MAOI*}
set_dont_use {tcbn90lphpbc0d77_ccs/AOI*}
set_dont_use {tcbn90lphpbc0d77_ccs/XNR4*}
set_dont_use {tcbn90lphpbc0d77_ccs/XOR4*}
set_dont_use {tcbn90lphpbc0d77_ccs/IND*}
set_dont_use {tcbn90lphpbc0d77_ccs/INR*}
set_dont_use {tcbn90lphpbc0d77_ccs/NR*}
set_dont_use {tcbn90lphpbc0d77_ccs/CK*}
current_design ufunc_r*
compile
set_dont_touch ufunc_r*
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/MUX*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/OAI*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/MAOI*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/AOI*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/XNR4*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/XOR4*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/IND*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/INR*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/NR*] dont_use
remove_attribute [get_lib_cells tcbn90lphpbc0d77_ccs/CK*] dont_use
current_design grain_128aead
compile

#current_design grain_128aead
#compile_ultra
#compile

uplevel #0 { report_timing -path full > ./timing.txt}
uplevel #0 { report_area -hierarchy > ./area.txt}
 
write -hierarchy -format verilog -output copa-syn.v 
write_sdf copa-syn.sdf  
write -hierarchy -format ddc -output copa.ddc
write -hierarchy -format vhdl -output copa.vhdl
write_sdc -nosplit copa.sdc

exit
