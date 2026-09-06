`timescale 1ns / 1ps

module display_controller_tb;

    // ==========================================
    // Inputs to DUT
    // ==========================================

    logic clk;
    logic reset;

    logic btn_right;
    logic btn_left;

    logic [3:0] output_digit [0:15];


    // ==========================================
    // Outputs from DUT
    // ==========================================

    logic [6:0] seg;
    logic [7:0] an;


    // ==========================================
    // Instantiate DUT
    // ==========================================

    display_controller uut (

        .clk(clk),
        .reset(reset),

        .output_digit(output_digit),

        .btn_right(btn_right),
        .btn_left(btn_left),

        .seg(seg),
        .an(an)

    );


    // ==========================================
    // 100 MHz clock
    // Period = 10 ns
    // ==========================================

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ==========================================
    // Function to print digit nicely
    // ==========================================

    function automatic [7:0] digit_to_char(input logic [3:0] digit);

        case (digit)

            4'd0:  digit_to_char = "0";
            4'd1:  digit_to_char = "1";
            4'd2:  digit_to_char = "2";
            4'd3:  digit_to_char = "3";
            4'd4:  digit_to_char = "4";
            4'd5:  digit_to_char = "5";
            4'd6:  digit_to_char = "6";
            4'd7:  digit_to_char = "7";
            4'd8:  digit_to_char = "8";
            4'd9:  digit_to_char = "9";
            4'd10: digit_to_char = "A";
            4'd11: digit_to_char = "B";
            4'd12: digit_to_char = "C";
            4'd13: digit_to_char = "D";
            4'd14: digit_to_char = "E";

            default: digit_to_char = "?";

        endcase

    endfunction


    // ==========================================
    // Print whenever the active display changes
    // ==========================================

    always @(posedge clk) begin

        if (!reset) begin

            if (uut.refresh_counter == 17'd0) begin

                $display(
                    "Time = %0t ns | Window = %0d | Display = AN%0d | Digit = %s",
                    $time,
                    uut.scroll_select,
                    uut.display_select,
                    digit_to_char(uut.selected_digit)
                );

            end

        end

    end


    // ==========================================
    // Main test
    // ==========================================

    initial begin

        // --------------------------------------
        // Initial conditions
        // --------------------------------------

        reset = 1'b1;

        btn_right = 1'b0;
        btn_left  = 1'b0;


        // --------------------------------------
        // Test number:
        //
        // 123456789ABCDEE0
        //
        // No F because our maximum digit is E.
        // --------------------------------------

        output_digit[0]  = 4'd1;
        output_digit[1]  = 4'd2;
        output_digit[2]  = 4'd3;
        output_digit[3]  = 4'd4;

        output_digit[4]  = 4'd5;
        output_digit[5]  = 4'd6;
        output_digit[6]  = 4'd7;
        output_digit[7]  = 4'd8;

        output_digit[8]  = 4'd9;
        output_digit[9]  = 4'd10;    // A
        output_digit[10] = 4'd11;    // B
        output_digit[11] = 4'd12;    // C

        output_digit[12] = 4'd13;    // D
        output_digit[13] = 4'd14;    // E
        output_digit[14] = 4'd14;    // E
        output_digit[15] = 4'd0;


        // --------------------------------------
        // Reset
        // --------------------------------------

        #50;

        reset = 1'b0;


        // ======================================
        // TEST 1
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 1: INITIAL WINDOW");
        $display("Expected physical display: 9 A B C D E E 0");
        $display("==========================================");
        $display("");

        // Run for one complete display scan
        #8000000;


        // ======================================
        // TEST 2
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 2: PRESS RIGHT");
        $display("Expected physical display: 1 2 3 4 5 6 7 8");
        $display("==========================================");
        $display("");

        btn_right = 1'b1;

        #10;

        btn_right = 1'b0;


        // Run for one complete scan
        #8000000;


        // ======================================
        // TEST 3
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 3: PRESS LEFT");
        $display("Expected physical display: 9 A B C D E E 0");
        $display("==========================================");
        $display("");

        btn_left = 1'b1;

        #10;

        btn_left = 1'b0;


        // Run for one complete scan
        #8000000;


        // ======================================
        // END
        // ======================================

        $display("");
        $display("==========================================");
        $display("DISPLAY CONTROLLER TEST COMPLETE");
        $display("==========================================");

        $finish;

    end

endmodule