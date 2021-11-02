vlogan -full64 copa-syn.v
vhdlan -full64 ./../kreyvium_tb.vhd
vcs -full64 -debug -sdf typ:kreyvium_tb/kreyvium:copa-syn.sdf kreyvium_tb +neg_tchk +sdfverbose
./simv -ucli -include saif.cmd
#dve -full64 -toolexe simv
