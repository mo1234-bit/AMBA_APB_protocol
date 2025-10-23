vlib work
vlog -f src_files.list +cover -covercells
vsim -sv_lib ./mylib_ram -sv_lib ./mylib_ram2 -voptargs=+acc work.top12 -classdebug -uvmcontrol=all -cover
add wave -position insertpoint  \
sim:/top12/apbif/PCLK \
sim:/top12/apbif/PRESETn \
sim:/top12/apbif/transfer \
sim:/top12/apbif/READ_WRITE \
sim:/top12/apbif/apb_write_paddr \
sim:/top12/apbif/apb_write_data \
sim:/top12/apbif/apb_read_paddr \
sim:/top12/apbif/PSLVERR \
sim:/top12/apbif/apb_read_data_out \
sim:/top12/apbif/PSLVERR_ref \
sim:/top12/apbif/apb_read_data_out_ref
add wave -position insertpoint  \
sim:/top12/APB_DUT/wone
add wave -position insertpoint  \
sim:/top12/APB_DUT/rone
run -all

# quit -sim
# vcover report FIFO.ucdb -details -annotate -all -output Coverage_rpt.txt