onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {general signals}
add wave -noupdate -radix hexadecimal /monociclo_tb/wb_dato_o_tb
add wave -noupdate -radix hexadecimal /monociclo_tb/rst_i_tb
add wave -noupdate -radix hexadecimal /monociclo_tb/clk_i_tb
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/memData_dato_o
add wave -noupdate -divider PC
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/if_inst_i
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/if_inst_o
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/se_data_o
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/PC_next
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/PC_branch
add wave -noupdate -divider ALU
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/ctrl_alu_i
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/rr_datars1_o
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/alu_datars2_i
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/alu_result_o
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/ex_zero_o
add wave -noupdate -divider {Ctrl Unit}
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/ALUOp
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/RegWrite
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/PCSrc
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/MemtoReg
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/MemWrite
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/MemRead
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/Branch
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/ALUSrc
add wave -noupdate -divider {Register FIle}
add wave -noupdate -radix hexadecimal -childformat {{{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[31]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[30]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[29]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[28]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[27]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[26]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[25]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[24]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[23]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[22]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[21]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[20]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[19]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[18]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[17]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[16]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[15]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[14]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[13]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[12]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[11]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[10]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[9]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[8]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[7]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[6]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[5]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[4]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[3]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[2]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[1]} -radix hexadecimal} {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[0]} -radix hexadecimal}} -subitemconfig {{/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[31]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[30]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[29]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[28]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[27]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[26]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[25]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[24]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[23]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[22]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[21]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[20]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[19]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[18]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[17]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[16]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[15]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[14]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[13]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[12]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[11]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[10]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[9]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[8]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[7]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[6]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[5]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[4]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[3]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[2]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[1]} {-height 15 -radix hexadecimal} {/monociclo_tb/U0_tb/ReadRegister_U0/RegFile[0]} {-height 15 -radix hexadecimal}} /monociclo_tb/U0_tb/ReadRegister_U0/RegFile
add wave -noupdate -divider {Data Memory}
add wave -noupdate -radix hexadecimal /monociclo_tb/U0_tb/MemData_U0/memSync
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {378 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9525 ps} {10025 ps}
