`timescale 1ns / 1ps

module input_controller_tb;

    // Inputs to DUT
    logic clk;
    logic reset;
    logic btn_center;
    logic [15:0] SW;

    // Outputs from DUT
    logic [3:0] digit3;
    logic [3:0] digit2;
    logic [3:0] digit1;
    logic [3:0] digit0;

    logic [3:0] input_radix;
    logic [3:0] output_radix;
    logic convert_enable;


    // Instantiate the Unit Under Test
    input_controller uut (
        .clk(clk),
        .reset(reset),
        .btn_center(btn_center),
        .SW(SW),

        .digit3(digit3),
        .digit2(digit2),
        .digit1(digit1),
        .digit0(digit0),

        .input_radix(input_radix),
        .output_radix(output_radix),
        .convert_enable(convert_enable)
    );


    // Clock generation
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end


    // Test sequence
    initial begin

        // Initial values
        reset = 1;
        btn_center = 0;
        SW = 16'b0;

        // Hold reset for two clock cycles
        #20;

        reset = 0;

        // ==========================================
        // STEP 1: Enter number 1234
        // ==========================================

        SW = 16'b0001_0010_0011_0100;

        // Press BTNC
        #5;
        btn_center = 1;

        #10;
        btn_center = 0;

        // ==========================================
        // STEP 2: Enter input radix 5
        // ==========================================

        SW = 16'b0000_0000_0000_0101;

        #5;
        btn_center = 1;

        #10;
        btn_center = 0;

        // ==========================================
        // STEP 3: Enter output radix 8
        // ==========================================

        SW = 16'b0000_0000_0000_1000;

        #5;
        btn_center = 1;

        #10;
        btn_center = 0;

        // Wait so we can observe S_READY
        #20;

        $finish;

    end

endmodule