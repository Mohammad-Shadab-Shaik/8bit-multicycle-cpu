module decoder(
    input [15:0] ir_out,
    //here, I break down my input instruction code into its constitutent parts to manipulate it easily
    output reg [3:0] opcode,
    output reg [1:0] dest_reg_sel,
    output reg [1:0] src_reg_sel,
    output reg [7:0] immediate_val,
    output reg [7:0] target_address     //for jmp
);

always @(*) begin
        opcode = ir_out[15:12]; // using blocking (=) for combinational logic
        dest_reg_sel = ir_out[11:10];
        src_reg_sel = ir_out[9:8];
        immediate_val = ir_out[7:0];
        target_address = ir_out[7:0];   //for jmp
    end

endmodule