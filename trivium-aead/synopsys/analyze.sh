vlogan -full64 copa-syn.v
vhdlan -full64 ./../aead_tb.vhd
vcs -full64 -debug -sdf typ:aead_tb/aead:copa-syn.sdf aead_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
