set project_name "YanaGPU"
set project_dir  "./vivado_project"
set target_part  "xc7a35tcpg236-1"

create_project $project_name $project_dir -part $target_part -force
add_files [glob ../rtl/*.sv]
add_files -fileset sim_1 [glob ../tb/*.sv]
set_property top yana_gpu_top [current_fileset]
set_property top tb_yana_gpu_top [get_filesets sim_1]
set_property target_language Verilog [current_project]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "YanaGPU project created for Basys 3-compatible Artix-7 part."
