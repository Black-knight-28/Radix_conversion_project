`timescale 1ns / 1ps

module tb_radix_converter;

    // ============================================================
    // INPUTS
    // ============================================================

    logic clk;
    logic reset_n;
    logic btn_center;
    logic [15:0] SW;
    logic btn_right;
    logic btn_left;

    // ============================================================
    // OUTPUTS
    // ============================================================

    logic [6:0] seg;
    logic [7:0] an;

    // ============================================================
    // DUT
    // ============================================================

    radix_converter dut (
        .clk(clk),
        .reset_n(reset_n),
        .btn_center(btn_center),
        .SW(SW),
        .btn_right(btn_right),
        .btn_left(btn_left),
        .seg(seg),
        .an(an)
    );

    // ============================================================
    // 100 MHz CLOCK
    // Period = 10 ns
    // ============================================================

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ============================================================
    // FAST CENTER PRESS
    //
    // We bypass the real 10 ms debouncer.
    //
    // CENTER is HIGH for exactly ONE clock edge.
    // Therefore one simulated press causes exactly one
    // FSM transition and one data capture.
    // ============================================================

    task center;
        begin

            $display(">>> CENTER = 1");

            force dut.center_pressed = 1'b1;

            // One clock edge = one button press
            @(posedge clk);

            // Allow nonblocking assignments to update
            #1;

            force dut.center_pressed = 1'b0;

            $display(">>> CENTER = 0");

            // Give the design time to settle
            #10;

            release dut.center_pressed;

        end
    endtask

    // ============================================================
    // PRINT DISPLAY
    //
    // Physical display order:
    //
    // [8] [9] [10] [11] [12] [13] [14] [15]
    // LEFT                                      RIGHT
    // ============================================================

    task print_display;
        integer i;

        begin

            $write("Display LEFT -> RIGHT = ");

            for(i = 8; i <= 15; i = i + 1)
            begin

                if(dut.display_data[i] <= 9)
                    $write("%0d", dut.display_data[i]);

                else
                    $write(
                        "%c",
                        "A" + (dut.display_data[i] - 10)
                    );

            end

            $display("");

        end
    endtask

    // ============================================================
    // MAIN TEST
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // INITIAL VALUES
        // --------------------------------------------------------

        reset_n    = 1'b0;
        btn_center = 1'b0;
        btn_right  = 1'b0;
        btn_left   = 1'b0;
        SW         = 16'h0000;

        // --------------------------------------------------------
        // RESET
        // --------------------------------------------------------

        #20;

        reset_n = 1'b1;

        #20;

        $display("");
        $display("========================================");
        $display("RADIX CONVERTER TEST START");
        $display("========================================");

        $display("FSM after reset = %b", dut.fsm_state);

        // ========================================================
        // STEP 1: NUMBER = 1234
        // ========================================================

        $display("");
        $display("========================================");
        $display("STEP 1: NUMBER = 1234");
        $display("========================================");

        SW = 16'h1234;

        #10;

        $display("SW = %h", SW);

        print_display();

        // Press CENTER once
        center();

        $display("");
        $display("After CENTER:");

        $display("Captured digit3 = %h", dut.digit3);
        $display("Captured digit2 = %h", dut.digit2);
        $display("Captured digit1 = %h", dut.digit1);
        $display("Captured digit0 = %h", dut.digit0);

        $display(
            "Captured number = %h%h%h%h",
            dut.digit3,
            dut.digit2,
            dut.digit1,
            dut.digit0
        );

        $display("FSM = %b", dut.fsm_state);

        // ========================================================
        // STEP 2: INPUT RADIX = 10
        // ========================================================

        $display("");
        $display("========================================");
        $display("STEP 2: INPUT RADIX = 10");
        $display("========================================");

        SW = 16'h000A;

        #10;

        $display("SW = %h", SW);

        print_display();

        // Press CENTER once
        center();

        $display("");
        $display("After CENTER:");

        $display("Input radix = %d", dut.input_radix);
        $display("FSM = %b", dut.fsm_state);

        // ========================================================
        // STEP 3: OUTPUT RADIX = 15
        // ========================================================

        $display("");
        $display("========================================");
        $display("STEP 3: OUTPUT RADIX = 15");
        $display("========================================");

        SW = 16'h000F;

        #10;

        $display("SW = %h", SW);

        print_display();

        // Press CENTER once
        center();

        $display("");
        $display("After CENTER:");

        $display("Output radix = %d", dut.output_radix);
        $display("FSM = %b", dut.fsm_state);

        // ========================================================
        // STEP 4: CHECK CONVERSION
        // ========================================================

        $display("");
        $display("========================================");
        $display("STEP 4: CHECK CONVERSION");
        $display("========================================");

        #20;

        $display(
            "Decimal value = %d",
            dut.dec_val
        );

        print_display();

        // ========================================================
        // OUTPUT DIGITS
        // ========================================================

        $display("");
        $display("Output digits:");

        $display(
            "output_digit[15] = %h",
            dut.output_digit[15]
        );

        $display(
            "output_digit[14] = %h",
            dut.output_digit[14]
        );

        $display(
            "output_digit[13] = %h",
            dut.output_digit[13]
        );

        $display(
            "output_digit[12] = %h",
            dut.output_digit[12]
        );

        // ========================================================
        // CHECK FSM
        // ========================================================

        if(dut.fsm_state == 2'b11)
            $display("PASS: FSM reached S_ready");

        else
            $display("FAIL: FSM did not reach S_ready");

        // ========================================================
        // CHECK NUMBER CAPTURE
        // ========================================================

        if(dut.digit3 == 4'd1 &&
           dut.digit2 == 4'd2 &&
           dut.digit1 == 4'd3 &&
           dut.digit0 == 4'd4)
        begin

            $display(
                "PASS: Number 1234 captured correctly"
            );

        end

        else
        begin

            $display(
                "FAIL: Number was not captured correctly"
            );

        end

        // ========================================================
        // CHECK INPUT RADIX
        // ========================================================

        if(dut.input_radix == 4'd10)
            $display("PASS: Input radix = 10");

        else
            $display(
                "FAIL: Input radix = %d",
                dut.input_radix
            );

        // ========================================================
        // CHECK OUTPUT RADIX
        // ========================================================

        if(dut.output_radix == 4'd15)
            $display("PASS: Output radix = 15");

        else
            $display(
                "FAIL: Output radix = %d",
                dut.output_radix
            );

        // ========================================================
        // CHECK DECIMAL VALUE
        // ========================================================

        if(dut.dec_val == 16'd1234)
            $display("PASS: dec_val = 1234");

        else
            $display(
                "FAIL: dec_val = %d",
                dut.dec_val
            );

        // ========================================================
        // CHECK CONVERSION
        //
        // 1234 decimal = 574 in base 15
        //
        // output_digit[15] = 4
        // output_digit[14] = 7
        // output_digit[13] = 5
        // ========================================================

        if(dut.output_digit[15] == 4 &&
           dut.output_digit[14] == 7 &&
           dut.output_digit[13] == 5)
        begin

            $display(
                "PASS: Output = 574 (base 15)"
            );

        end

        else
        begin

            $display(
                "FAIL: Output is incorrect"
            );

            $display(
                "output_digit[15] = %h",
                dut.output_digit[15]
            );

            $display(
                "output_digit[14] = %h",
                dut.output_digit[14]
            );

            $display(
                "output_digit[13] = %h",
                dut.output_digit[13]
            );

        end

        // ========================================================
        // DONE
        // ========================================================

        $display("");
        $display("========================================");
        $display("TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule