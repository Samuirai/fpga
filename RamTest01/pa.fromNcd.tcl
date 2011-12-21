
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name RamTest01 -dir "Z:/coding/fpga/RamTest01/planAhead_run_1" -part xc6slx16csg324-3
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "Z:/coding/fpga/RamTest01/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Z:/coding/fpga/RamTest01} }
set_param project.paUcfFile  "Z:/coding/fpga/Nexys3_Master.ucf"
add_files "Z:/coding/fpga/Nexys3_Master.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
read_xdl -file "Z:/coding/fpga/RamTest01/main.ncd"
if {[catch {read_twx -name results_1 -file "Z:/coding/fpga/RamTest01/main.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"Z:/coding/fpga/RamTest01/main.twx\": $eInfo"
}
