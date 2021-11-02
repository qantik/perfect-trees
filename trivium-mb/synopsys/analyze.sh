vlogan -full64 copa-syn.v
vhdlan -full64 ./../trivium_mb_tb.vhd
vcs -full64 -debug -sdf typ:trivium_mb_tb/trivium_mb:copa-syn.sdf trivium_mb_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
