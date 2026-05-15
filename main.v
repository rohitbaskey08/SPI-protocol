`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/15/2026
// Design Name: spi protocol
// Module Name: spi_state
// Project Name:
// Target Devices:
// Tool Versions:
//
// Description:
// Simple SPI Transmitter FSM
//
//////////////////////////////////////////////////////////////////////////////////

module spi_state (

    input  wire        clk,        // System clock
    input  wire        reset,      // Asynchronous reset
    input  wire [15:0] datain,     // 16-bit input data

    output wire        spi_cs_l,   // SPI chip select (active low)
    output wire        spi_sclk,   // SPI serial clock
    output wire        spi_data,   // SPI MOSI data
    output wire [4:0]  counter

);

    //========================================================
    // Internal Registers
    //========================================================
    reg [15:0] shift_reg;
    reg [4:0]  count;

    reg        cs_l;
    reg        sclk;
    reg        mosi;

    reg [1:0]  state;

    //========================================================
    // State Encoding
    //========================================================
    localparam IDLE  = 2'b00,
               LOAD  = 2'b01,
               SHIFT = 2'b10;

    //========================================================
    // FSM Logic
    //========================================================
    always @(posedge clk or posedge reset) begin

        if (reset) begin
            shift_reg <= 16'b0;
            count     <= 5'd16;

            cs_l      <= 1'b1;
            sclk      <= 1'b0;
            mosi      <= 1'b0;

            state     <= IDLE;
        end

        else begin
            case (state)

                //============================================
                // IDLE STATE
                //============================================
                IDLE: begin
                    cs_l  <= 1'b1;
                    sclk  <= 1'b0;
                    count <= 5'd16;

                    shift_reg <= datain;

                    state <= LOAD;
                end

                //============================================
                // LOAD DATA BIT
                //============================================
                LOAD: begin
                    cs_l <= 1'b0;
                    sclk <= 1'b0;

                    mosi <= shift_reg[count - 1];

                    state <= SHIFT;
                end

                //============================================
                // SHIFT STATE
                //============================================
                SHIFT: begin
                    sclk <= 1'b1;

                    if(count > 1) begin
                      count <= count - 1;
                      state <= LOAD;
                      end
                    else begin
                      count <= 16;
                      state <= IDLE;
                      end
                end

                //============================================
                // DEFAULT
                //============================================
                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

    //========================================================
    // Output Assignments
    //========================================================
    assign spi_cs_l = cs_l;
    assign spi_sclk = sclk;
    assign spi_data = mosi;
    assign counter  = count;

endmodule