read_ddc copa.ddc

reset_switching_activity

read_saif -verbose -input copa_timing.saif -instance AEAD_TB/AEAD -unit ns

report_power > powercon_lp.txt

report_power -hier > powerhier_lp.txt

exit
