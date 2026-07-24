module cpu(
    input clk,
    input reset
);
//here, i'll make all the connections for the different modules so our cpu comes to life
//first, declare all the wires I'll be using
//Program Counter Wires
wire pc_inc;
wire pc_load;
wire [7:0] jmp_addr;
wire [7:0] pc_out;

//Instruction Memory Wires
wire [15:0] instruction;

//Instruction Register wires
wire ir_load;
wire [15:0] ir_out;

//Decoder wires
wire [3:0] opcode;
wire [1:0] dest_reg_sel;
wire [1:0] src_reg_sel;
wire [7:0] immediate_val;
wire [7:0] target_address;

//control unit wires
wire reg_write_en;
wire [2:0] alu_op;
wire mem_read;

// Register File wires
    wire [7:0] reg_data_dest;
    wire [7:0] reg_data_src;
    wire [7:0] write_data;

 // ALU wires
    wire [7:0] alu_result;   

assign jmp_addr = target_address;
assign write_data = (opcode == 4'b0110) ? immediate_val : alu_result;

//now, instantiating the modules
program_counter PC_unit (
        .clk(clk),
        .reset(reset),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .jmp_addr(jmp_addr),
        .pc_out(pc_out)
    );

instruction_memory ROM_unit (
        .address(pc_out),
        .instruction(instruction)
    );

instruction_register IR_unit (
        .clk(clk),
        .reset(reset),
        .ir_load(ir_load),
        .ir_in(instruction),
        .ir_out(ir_out)
    );

decoder Decoder_unit (
        .ir_out(ir_out),
        .opcode(opcode),
        .dest_reg_sel(dest_reg_sel),
        .src_reg_sel(src_reg_sel),
        .immediate_val(immediate_val),
        .target_address(target_address)
    );

control_unit CU_unit (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .reg_write_en(reg_write_en),
        .alu_op(alu_op),
        .pc_inc(pc_inc),
        .pc_load(pc_load),
        .ir_load(ir_load),
        .mem_read(mem_read)
    );

register_file RegFile_unit (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write_en),
        .dest_reg_sel(dest_reg_sel),
        .src_reg_sel(src_reg_sel),
        .write_data(write_data),
        .reg_data_dest(reg_data_dest),
        .reg_data_src(reg_data_src)
    );

alu ALU_unit (
        .alu_op(alu_op),
        .operand_A(reg_data_dest),
        .operand_B((opcode == 4'b0001) ? reg_data_src : reg_data_src), 
        // Note: For MOV, operand_B uses reg_data_src. For LDI, the ALU is in PASS mode 
        // but write_data bypasses via our MUX above, making operand_B's value here immaterial.
        .alu_result(alu_result)
    );   
endmodule