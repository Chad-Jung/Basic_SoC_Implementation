set_db init_lib_search_path /home/hah014/Basic_SoC_Implementation/3_SYN/1_LIB
set_db init_hdl_search_path /home/hah014/Basic_SoC_Implementation/1_RTL/4_COMB_LOGIC/1_MUX
read_libs slow_vdd1v0_basicCells.lib
read_hdl gpio_mux.v

elaborate

read_sdc /home/hah014/Basic_SoC_Implementation/3_SYN/2_CONSTRAINTS/sample.sdc
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

syn_generic
syn_map
syn_opt

report_timing > ./reports/timing.rpt
report_power > ./reports/power.rpt
report_area > ./reports/area.rpt
report_qor > ./reports/qor.rpt

write_hdl > ./outputs/gpio_mux__netlist.v
write_sdc > ./outputs/gpio_mux__final.sdc
