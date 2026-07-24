//this is an array of size 256 with each element being 16 bits wide
module instruction_memory(
    input [7:0] address,    //gets it from pc
    output [15:0] instruction
);

reg [15:0] rom [0:255];     //array of 256 location of 16 bits width each

initial begin       //Here, we prelead the ROM with my program. For testing, I'm inputting a small program that adds two numbers
        rom[0] = 16'b0110_0000_0000_1010; // LDI AL, 10
        rom[1] = 16'b0110_0100_0000_0101; // LDI BL, 5
        rom[2] = 16'b0010_0001_0000_0000; // ADD AL, BL
        rom[3] = 16'b0001_1000_0000_0000; // MOV CL, AL
        rom[4] = 16'b0011_1001_0000_0000; // SUB CL, BL
        rom[5] = 16'b0100_0001_0000_0000; // AND AL, BL
        rom[6] = 16'b0101_1110_0000_0000; // OR  DL, CL
        rom[7] = 16'b0000_0000_0000_0000; // NOP

        begin : fill
            integer i;
            for(i=8; i<256; i =i +1)
                rom[i] = 16'b0000_0000_0000_0000; //nop

        end
end

assign instruction = rom[address];   //Assigning the output according to the address received by PC

endmodule
