vlib work
vlog -f src_files.list +cover -covercells
vsim  -voptargs=+acc work.top1 -classdebug -uvmcontrol=all -cover
run -all

# quit -sim

# vcover report APB.ucdb -details -annotate -all -output Coverage_rpt.txt
