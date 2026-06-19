module program_counter(
    input clk,
    input reset,
    input pc_inc,   //increments pc by 1
    input pc_load,  //used in jmp instrucn
    input [7:0] jmp_addr,
    output reg [7:0] pc_out //giving the current instruction address to memory
);

always @(posedge clk) begin
    if(reset)
        pc_out <= 8'h00;
    else if(pc_load)
        pc_out <= jmp_addr;     //this ensures that jmp takes priority over increment
    else if(pc_inc)
        pc_out <= pc_out + 1;   //incrementing pc
end


endmodule