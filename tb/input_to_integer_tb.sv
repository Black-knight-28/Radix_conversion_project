`timescale 1ns / 1ps

module input_to_integer_tb;

    // Inputs to DUT
    logic [3:0] digit3;
    logic [3:0] digit2;
    logic [3:0] digit1;
    logic [3:0] digit0;
    logic [3:0] input_radix;

    // Output from DUT
    logic [15:0] dec_val;


    // Instantiate the DUT
    input_to_integer uut (
        .digit3(digit3),
        .digit2(digit2),
        .digit1(digit1),
        .digit0(digit0),
        .input_radix(input_radix),
        .dec_val(dec_val)
    );


    initial begin

        // ==========================================
        // Test 1: 1234 in radix 5
        // Expected: 194
        // ==========================================

        digit3 = 4'd1;
        digit2 = 4'd2;
        digit1 = 4'd3;
        digit0 = 4'd4;
        input_radix = 4'd5;

        #10;


        // ==========================================
        // Test 2: 1011 in radix 2
        // Expected: 11
        // ==========================================

        digit3 = 4'd1;
        digit2 = 4'd0;
        digit1 = 4'd1;
        digit0 = 4'd1;
        input_radix = 4'd2;

        #10;


        // ==========================================
        // Test 3: 1234 in radix 10
        // Expected: 1234
        // ==========================================

        digit3 = 4'd1;
        digit2 = 4'd2;
        digit1 = 4'd3;
        digit0 = 4'd4;
        input_radix = 4'd10;

        #10;


        // ==========================================
        // Test 4: 1111 in radix 15
        // Expected: 3375
        // ==========================================

        digit3 = 4'd1;
        digit2 = 4'd1;
        digit1 = 4'd1;
        digit0 = 4'd1;
        input_radix = 4'd15;

        #10;


        // ==========================================
        // Test 5: 0000 in radix 5
        // Expected: 0
        // ==========================================

        digit3 = 4'd0;
        digit2 = 4'd0;
        digit1 = 4'd0;
        digit0 = 4'd0;
        input_radix = 4'd5;

        #10;


        $finish;

    end

endmodule