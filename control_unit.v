module control_unit(
    input clk,
    input reset,
    input [3:0] opcode,
    output reg reg_write_en,
    output reg [2:0] alu_op,    //3 bit code given to ALU such to represent add, sub, etc
    output reg pc_inc,          //control signal to increment pc by 1
    output reg pc_load,         //used to update pc during jmp instruction
    output reg ir_load,         //active when ir is to be loaded with a new value
    output reg mem_read         //active when instruction memory is to be read during fetch part of the cycle
);

//fsm state definitions
localparam FETCH = 2'b00;
localparam DECODE = 2'b01;
localparam EXECUTE = 2'b10;
localparam WRITEBACK = 2'b11;

reg[1:0] current_state;
reg[1:0] next_state;

//matching operation codes
localparam ALU_PASS = 3'b000;
localparam ALU_ADD = 3'b001;
localparam ALU_SUB = 3'b010;
localparam ALU_AND = 3'b011;
localparam ALU_OR = 3'b100;

//state transition logic
always @(posedge clk) begin
    if(reset)begin
        current_state <= FETCH;
    end
    else begin
        current_state <= next_state;
    end
end

//defining next state for each current state
always @(*)begin
    case(current_state)
        FETCH: next_state = DECODE;
        DECODE: next_state = EXECUTE;
        EXECUTE: next_state = WRITEBACK;
        WRITEBACK: next_state = FETCH;
        default: next_state = FETCH;
    endcase
end

//output control signal generation
always @(*)begin
    //setting default values for all control lines firstly
    reg_write_en = 1'b0;
    alu_op = ALU_PASS;
    pc_inc = 1'b0;
    pc_load = 1'b0;
    ir_load = 1'b0;
    mem_read = 1'b0;

    case(current_state)
        FETCH: begin
            ir_load = 1'b1;
            pc_inc = 1'b1;
            mem_read = 1'b1;
        end

        DECODE: begin
            //there is no change in the control signal lines during decoding
        end

        EXECUTE: begin
            case(opcode)
                4'b0001: alu_op = ALU_PASS; // mov
                4'b0010: alu_op = ALU_ADD;  // add
                4'b0011: alu_op = ALU_SUB;  // subtact
                4'b0100: alu_op = ALU_AND;  // and
                4'b0101: alu_op = ALU_OR;   // or
                4'b0110: alu_op = ALU_PASS; // direct loading
                default: alu_op = ALU_PASS;
            endcase
        end

        WRITEBACK: begin
            //keep alu_op active during writeback so ALU result doesn't revert to ALU_PASS
            case(opcode)
                4'b0001: alu_op = ALU_PASS; // mov
                4'b0010: alu_op = ALU_ADD;  // add
                4'b0011: alu_op = ALU_SUB;  // subtract
                4'b0100: alu_op = ALU_AND;  // and
                4'b0101: alu_op = ALU_OR;   // or
                4'b0110: alu_op = ALU_PASS; // direct loading
                default: alu_op = ALU_PASS;
            endcase
            
            case(opcode)
            4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110: begin     //mov, add, sub, and, or, ldi have writeback
                        reg_write_en = 1'b1;
                    end
            4'b0111: begin      //jmp leads to change in pc value
                pc_load = 1'b1;
            end
            default: begin
                reg_write_en = 1'b0;
                pc_load = 1'b0;
            end
            endcase
        end
    endcase
end

endmodule