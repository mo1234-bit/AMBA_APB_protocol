vlib work
vlog Master.v slave1.v slave2.v APB.v test.v
vsim -voptargs=+acc work.test
add wave *
run -all
#quit -sim