module register_file(
    input clk,
    input reset,
    input reg_write,    //allows destination register to store write_data during writeback
    input [1:0] dest_reg_sel,
    input [1:0] src_reg_sel,
    input [7:0] write_data, //data that goes into the destination register (from alu or immediate value)
    output [7:0] reg_data_dest, //current data in destination register
    output [7:0] reg_data_src   //current data in source register
);

reg [7:0] registers[0:3];   //4 registers of 8 bits each
always @(posedge clk)begin
    if(reset)begin  //reset all general purpose registers to 0
        registers[0] <= 8'h00;
        registers[1] <= 8'h00;
        registers[2] <= 8'h00;
        registers[3] <= 8'h00;
    end
    else if (reg_write) begin   //sequential write logic
        registers[dest_reg_sel] <= write_data;
    end
end

//combinational read logic
assign reg_data_dest = registers[dest_reg_sel];
assign reg_data_src = registers[src_reg_sel];

wire [7:0] al = registers[0];
wire [7:0] bl = registers[1];
wire [7:0] cl = registers[2];
wire [7:0] dl = registers[3];
endmodule