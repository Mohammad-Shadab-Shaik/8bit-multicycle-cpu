module instruction_register(
    input clk,
    input reset,
    input ir_load,  //this is a control signal that allows the register to load data into it during the fetch cycle
    input [15:0] ir_in,     //the 16 bit instruction code
    output reg [15:0] ir_out    //the same code that is then given to the control unit
);

always @(posedge clk) begin
        if (reset) begin
            ir_out <= 16'b0000_0000_0000_0000;
        end 
        else if (ir_load) begin
            ir_out <= ir_in;
        end
    end

endmodule