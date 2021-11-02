# Perfect Trees: Designing Energy-Optimal Symmetric Encryption Primitives

*Andrea Caforio (LASEC, Ecole Polytechnique Fédérale de Lausanne)*

*Subhadeep Banik (LASEC, Ecole Polytechnique Fédérale de Lausanne)*

*Yosuke Todo (NTT Social Informatics Laboratories)*

*Willi Meier (FHNW)*

*Takanori Isobe (University of Hyogo and NICT)*

*Fukang Liu (University of Hyogo)*

*Bin Zhang (Chinese Academy of Sciences)*

## Auxiliary material for the reproduction of all results:

`./trees`: Scripts to calculate the total number of perfect unrolled strand trees for all schemes.
`./[cipher-name]`: VHDL implementation.
`./[cipher-name]/test_vectors`: Test vectors and reference implementation.
`./[cipher-name]/synopsys`: Synopsys DC synthesis scripts.
`./[cipher-name]/synopsys/all.sh`: Synthesize cipher for multiple unrolling factors and frequencies.
`./[cipher-name]/synopsys/trees.sh`: Synthesize cipher for different tap configurations defined in `trees.txt`.

Both the NanGate 15 nm and NanGate 45 nm cell libraries are freely available at https://si2.org/open-cell-library/.
In order to be utilized inside Synopsys, both libraries need to be converted to a `.db` file,
this is readily achieved as shown here https://class.ece.uw.edu/cadta/synopsys/tutorial1.html.

Note that running the following scripts will require the access to the Synopsys ASIC tool chain, in particular, Synopsys design vision and
Synopsys VCS. These softwares are available in most universities. 

Fig 1: Run `all.sh` to generate energy data in folder trivium

Fig 2: Run `dc_shell -f compile.tcl` + `source analyze.sh` + `dc_shell -f power.tcl`  in folder trivium

Fig:7: Run `trees.sh` in folder trivium

Fig:9: Run `trees.sh `in folders `./triad`, `./trivium-mb`, `./kreyvium` and `./trivia`

Fig 10:  Run `dc_shell -f compile.tcl`  + `source analyze.sh` + `dc_shell -f power.tcl`  in folders `./triad`, `./trivium-mb`, `./kreyvium` and `./trivia`

Fig 11:  Run `dc_shell -f compile.tcl`  + `source analyze.sh` + `dc_shell -f power.tcl`  in folders `./trivium-aead`, `./triad-aead`, `./grain128-aead`.


Note the scatter plot simulations may take over 24 hours depending on the computing resources available.

