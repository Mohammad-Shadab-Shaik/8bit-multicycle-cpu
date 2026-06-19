module alu(
    input [2:0] alu_op,
    input [7:0] operand_A,
    input [7:0] operand_B,
    output reg [7:0] alu_result
);
    //same operation code defined in my control unit
    localparam ALU_PASS = 3'b000;
    localparam ALU_ADD  = 3'b001;
    localparam ALU_SUB  = 3'b010;
    localparam ALU_AND  = 3'b011;
    localparam ALU_OR   = 3'b100;

    always @(*) begin
        case(alu_op)
            ALU_PASS: begin
                alu_result = operand_B;     //nop. give source back to itself
            end
            ALU_ADD: begin
                alu_result = operand_A + operand_B;
            end
            ALU_SUB: begin
                alu_result = operand_A - operand_B;
            end
            ALU_AND: begin
                alu_result = operand_A & operand_B;     //bitwise and
            end
            ALU_OR: begin
                alu_result = operand_A | operand_B;     //bitwise or
            end 
            default: begin
                alu_result = 8'h00;
            end
        endcase
    end
endmodule