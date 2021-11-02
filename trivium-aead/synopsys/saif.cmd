power -gate_level on
power aead
power -enable
run 1 s
power -disable
power -report  copa_timing.saif 1e-09 aead
quit

