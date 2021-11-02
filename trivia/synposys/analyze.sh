vlogan -full64 copa-syn.v
vhdlan -full64 ./../trivia_tb.vhd
vcs -full64 -debug -sdf typ:trivia_tb/trivia:copa-syn.sdf trivia_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv

