read_ddc copa.ddc

reset_switching_activity

read_saif -verbose -input copa_timing.saif -instance TRIVIUM_TB/TRIVIUM -unit ns

report_power > powercon_lp.txt

report_power -hier > powerhier_lp.txt

exit
