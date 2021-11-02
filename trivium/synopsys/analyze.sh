vlogan -full64 copa-syn.v
vhdlan -full64 ./../trivium_tb.vhd
vcs -full64 -debug -sdf typ:trivium_tb/trivium:copa-syn.sdf trivium_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
