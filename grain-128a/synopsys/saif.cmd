power -gate_level on
power grain_128a
power -enable
run 1 s
power -disable
power -report  copa_timing.saif 1e-09 grain_128a
quit

