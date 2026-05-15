`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/15/2026
// Design Name:
// Module Name: tb_spi
// Project Name:
// Target Devices:
// Tool Versions:
//
// Description:
// Testbench for SPI State Machine
//
//////////////////////////////////////////////////////////////////////////////////

module tb_spi();

    //========================================================
    // Inputs
    //========================================================
    reg         clk;
    reg         reset;
    reg [15:0]  datain;

    //========================================================
    // Outputs
    //========================================================
    wire        spi_cs_l;
    wire        spi_sclk;
    wire        spi_data;
    wire [4:0]  counter;

    //========================================================
    // Instantiate DUT
    //========================================================
    spi_state dut (
        .clk(clk),
        .reset(reset),
        .datain(datain),

        .spi_cs_l(spi_cs_l),
        .spi_sclk(spi_sclk),
        .spi_data(spi_data),
        .counter(counter)
    );

    //========================================================
    // Clock Generation
    //========================================================
    always #5 clk = ~clk;

    //========================================================
    // Initial Block
    //========================================================
   initial begin

    clk    = 1'b0;
    reset  = 1'b1;
    datain = 16'h0000;

    // Reset
    #20;
    reset = 1'b0;

    // Test patterns
    #10  datain = 16'hA569;
    #350 datain = 16'h2563;
    #350 datain = 16'h9B63;
    #350 datain = 16'h6A61;
    #350 datain = 16'hA265;
    #350 datain = 16'h7564;

    // Wait enough time
    #360;

   $finish;
end

endmodule