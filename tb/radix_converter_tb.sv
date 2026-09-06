`timescale 1ns / 1ps

module radix_converter_tb;

    // =====================================================
    // Inputs to top module
    // =====================================================

    logic clk;
    logic reset;

    logic btn_center;
    logic btn_right;
    logic btn_left;

    logic [15:0] SW;


    // =====================================================
    // Outputs from top module
    // =====================================================

    logic [6:0] seg;
    logic [7:0] an;


    // =====================================================
    // Instantiate complete radix converter
    // =====================================================

    radix_converter uut (

        .clk(clk),
        .reset(reset),

        .btn_center(btn_center),
        .btn_right(btn_right),
        .btn_left(btn_left),

        .SW(SW),

        .seg(seg),
        .an(an)

    );


    // =====================================================
    // 100 MHz clock
    //
    // Period = 10 ns
    // =====================================================

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end


    // =====================================================
    // Convert digit value to printable character
    // =====================================================

    function automatic [7:0] digit_to_char(
        input logic [3:0] digit
    );

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


    // =====================================================
    // CENTER BUTTON PRESS
    //
    // Keep button HIGH for 15 ms so that the
    // debouncer accepts it.
    //
    // Then keep it LOW for 15 ms so that the
    // debouncer recognizes the release.
    // =====================================================

    task automatic press_center;

        begin

            $display("");
            $display("Pressing CENTER...");

            btn_center = 1'b1;

            #15000000;

            btn_center = 1'b0;

            #15000000;

            $display("CENTER released.");

        end

    endtask


    // =====================================================
    // RIGHT BUTTON PRESS
    // =====================================================

    task automatic press_right;

        begin

            $display("");
            $display("Pressing RIGHT...");

            btn_right = 1'b1;

            #15000000;

            btn_right = 1'b0;

            #15000000;

            $display("RIGHT released.");

        end

    endtask


    // =====================================================
    // LEFT BUTTON PRESS
    // =====================================================

    task automatic press_left;

        begin

            $display("");
            $display("Pressing LEFT...");

            btn_left = 1'b1;

            #15000000;

            btn_left = 1'b0;

            #15000000;

            $display("LEFT released.");

        end

    endtask


    // =====================================================
    // Print the 16 output digits
    // =====================================================

    task automatic print_output_digits;

        integer i;

        begin

            $write("Output digits [0 -> 15]: ");

            for (i = 0; i < 16; i = i + 1) begin

                $write(
                    "%s ",
                    digit_to_char(uut.output_digit[i])
                );

            end

            $display("");

        end

    endtask


    // =====================================================
    // Print current conversion result
    // =====================================================

    task automatic print_conversion_result;

        begin

            $display("");
            $display("------------------------------------------");

            $display(
                "Input digits  : %s%s%s%s",
                digit_to_char(uut.digit3),
                digit_to_char(uut.digit2),
                digit_to_char(uut.digit1),
                digit_to_char(uut.digit0)
            );

            $display(
                "Input radix   : %0d",
                uut.input_radix
            );

            $display(
                "Decimal value : %0d",
                uut.dec_val
            );

            $display(
                "Output radix  : %0d",
                uut.output_radix
            );

            $display(
                "Convert enable: %0d",
                uut.convert_enable
            );

            print_output_digits();

            $display("------------------------------------------");

        end

    endtask


    // =====================================================
    // MAIN TEST
    // =====================================================

    initial begin

        // -------------------------------------------------
        // Initial conditions
        // -------------------------------------------------

        reset      = 1'b1;

        btn_center = 1'b0;
        btn_right  = 1'b0;
        btn_left   = 1'b0;

        SW         = 16'd0;


        // -------------------------------------------------
        // Reset
        // -------------------------------------------------

        #100;

        reset = 1'b0;

        // Give reset some time to settle
        #100;


        // =================================================
        // TEST 1
        //
        // 1011 base 2 -> base 10
        //
        // Expected:
        //
        // Decimal value = 11
        // Output = 11
        // =================================================

        $display("");
        $display("==========================================");
        $display("TEST 1: 1011 base 2 -> base 10");
        $display("==========================================");


        // -------------------------------------------------
        // Enter number
        // -------------------------------------------------

        SW = 16'h1011;

        press_center();


        // -------------------------------------------------
        // Enter input radix = 2
        // -------------------------------------------------

        SW = 16'h0002;

        press_center();


        // -------------------------------------------------
        // Enter output radix = 10
        // 10 = hexadecimal A in SW representation
        // -------------------------------------------------

        SW = 16'h000A;

        press_center();


        // Give combinational logic time to settle

        #100;


        // Print result

        print_conversion_result();


        // =================================================
        // TEST RIGHT BUTTON
        // =================================================

        $display("");
        $display("==========================================");
        $display("TEST 1 DISPLAY: RIGHT");
        $display("==========================================");

        press_right();

        $display(
            "Scroll select after RIGHT = %0d",
            uut.display_ctrl.scroll_select
        );


        // =================================================
        // TEST LEFT BUTTON
        // =================================================

        $display("");
        $display("==========================================");
        $display("TEST 1 DISPLAY: LEFT");
        $display("==========================================");

        press_left();

        $display(
            "Scroll select after LEFT = %0d",
            uut.display_ctrl.scroll_select
        );


        // =================================================
        // TEST 2
        //
        // 1234 base 5 -> base 8
        //
        // Expected:
        //
        // Decimal value = 194
        // Output = 302
        // =================================================

        $display("");
        $display("");
        $display("==========================================");
        $display("TEST 2: 1234 base 5 -> base 8");
        $display("==========================================");


        // -------------------------------------------------
        // Reset complete system
        // -------------------------------------------------

        reset = 1'b1;

        #100;

        reset = 1'b0;

        #100;


        // -------------------------------------------------
        // Enter number = 1234
        // -------------------------------------------------

        SW = 16'h1234;

        press_center();


        // -------------------------------------------------
        // Enter input radix = 5
        // -------------------------------------------------

        SW = 16'h0005;

        press_center();


        // -------------------------------------------------
        // Enter output radix = 8
        // -------------------------------------------------

        SW = 16'h0008;

        press_center();


        // Give combinational logic time to settle

        #100;


        // Print result

        print_conversion_result();


        // =================================================
        // TEST RIGHT
        // =================================================

        $display("");
        $display("==========================================");
        $display("TEST 2 DISPLAY: RIGHT");
        $display("==========================================");

        press_right();

        $display(
            "Scroll select after RIGHT = %0d",
            uut.display_ctrl.scroll_select
        );


        // =================================================
        // TEST LEFT
        // =================================================

        $display("");
        $display("==========================================");
        $display("TEST 2 DISPLAY: LEFT");
        $display("==========================================");

        press_left();

        $display(
            "Scroll select after LEFT = %0d",
            uut.display_ctrl.scroll_select
        );


        // =================================================
        // FINISH
        // =================================================

        $display("");
        $display("==========================================");
        $display("RADIX CONVERTER INTEGRATION TEST COMPLETE");
        $display("==========================================");

        $finish;

    end

endmodule