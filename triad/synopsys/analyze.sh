vlogan -full64 copa-syn.v
vhdlan -full64 ./../triad_tb.vhd
vcs -full64 -debug -sdf typ:triad_tb/triad:copa-syn.sdf triad_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
