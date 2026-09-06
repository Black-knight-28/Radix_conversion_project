`timescale 1ns / 1ps

module integer_to_output_tb;

    // Inputs to DUT
    logic [15:0] dec_val;
    logic [3:0]  output_radix;

    // Outputs from DUT
    logic [3:0] output_digit [0:15];

    // Instantiate DUT
    integer_to_output uut (
        .dec_val(dec_val),
        .output_radix(output_radix),
        .output_digit(output_digit)
    );

    initial begin

        // ==========================================
        // Test 1: 194 decimal to radix 8
        // Expected: 302
        // ==========================================

        dec_val = 16'd194;
        output_radix = 4'd8;

        #10;

        // ==========================================
        // Test 2: 11 decimal to radix 2
        // Expected: 1011
        // ==========================================

        dec_val = 16'd11;
        output_radix = 4'd2;

        #10;

        // ==========================================
        // Test 3: 1234 decimal to radix 10
        // Expected: 1234
        // ==========================================

        dec_val = 16'd1234;
        output_radix = 4'd10;

        #10;

        // ==========================================
        // Test 4: 50624 decimal to radix 2
        // Expected: 1100010110000000
        // ==========================================

        dec_val = 16'd50624;
        output_radix = 4'd2;

        #10;

        // ==========================================
        // Test 5: 0 decimal to radix 5
        // Expected: 0
        // ==========================================

        dec_val = 16'd0;
        output_radix = 4'd5;

        #10;

        // ==========================================
        // Test 6: Invalid radix (0)
        // Expected: all output digits = 0
        // ==========================================

        dec_val = 16'd194;
        output_radix = 4'd0;

        #10;

        $finish;

    end

endmodule