vlogan -full64 copa-syn.v
vhdlan -full64 ./../grain_128a_tb.vhd
vcs -full64 -debug -sdf typ:grain_128a_tb/grain_128a:copa-syn.sdf grain_128a_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
