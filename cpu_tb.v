`timescale 1ns / 1ps

module cpu_tb;

    
    reg clk;
    reg reset; //input signals

    cpu UUT (   //instantiating the cpu top module
        .clk(clk),
        .reset(reset)
    );

    //generating the clock (20ns period)
    always begin
        #10 clk = ~clk; // Toggles every 10ns, resulting in a 20ns period
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        // Initialize signals
        clk = 0;
        reset = 1;

        // Hold reset high for two full clock cycles to flush the core registers
        #40; 
        reset = 0;
        
        // Display a header in the simulation log terminal
        $display("Time\tPC\tIR\t\tOpcode\tAL\tBL\tCL\tDL");
        $display("-----------------------------------------------------------------");
        
        // run the simulation long enough to step through the preloaded instructions
        // 4 states per instruction * 20ns per state = 80ns per instruction.
        // 8 instructions total requires at least 640ns. I'll run it for 800ns.
      #800;
        
        $display("-----------------------------------------------------------------");
        $display("Simulation finished.");
        $stop;
    end

    //to print after WRITEBACK
    always @(posedge clk) begin
        if (UUT.CU_unit.current_state == 2'b11) begin
            #2; 
            $display("%0dns\t0x%h\t16'b%b_%b_%b_%b\t0x%h\t0x%h\t0x%h\t0x%h\t0x%h", 
                     $time,
                     UUT.PC_unit.pc_out,
                     UUT.IR_unit.ir_out[15:12], UUT.IR_unit.ir_out[11:10], UUT.IR_unit.ir_out[9:8], UUT.IR_unit.ir_out[7:0],
                     UUT.Decoder_unit.opcode,
                     UUT.RegFile_unit.registers[0], // AL
                     UUT.RegFile_unit.registers[1], // BL
                     UUT.RegFile_unit.registers[2], // CL
                     UUT.RegFile_unit.registers[3]  // DL
            );
        end
    end

endmodule