
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name TEST04 -dir "Z:/coding/fpga/TEST04/planAhead_run_1" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "Z:/coding/fpga/TEST04/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {Z:/coding/fpga/TEST04} }
set_param project.pinAheadLayout  yes
set_param project.paUcfFile  "main.ucf"
add_files "main.ucf" -fileset [get_property constrset [current_run]]
open_netlist_design
