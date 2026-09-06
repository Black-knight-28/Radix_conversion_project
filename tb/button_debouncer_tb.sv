`timescale 1ns / 1ps

module button_debouncer_tb;

    // ==========================================
    // Inputs to DUT
    // ==========================================

    logic clk;
    logic reset;
    logic button;

    // ==========================================
    // Output from DUT
    // ==========================================

    logic button_pressed;


    // ==========================================
    // Instantiate DUT
    // ==========================================

    button_debouncer uut (

        .clk(clk),
        .reset(reset),
        .button(button),
        .button_pressed(button_pressed)

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
    // Monitor button press
    // ==========================================

    always @(posedge clk) begin

        if (button_pressed) begin

            $display(
                ">>> BUTTON PRESS DETECTED at time = %0t ns",
                $time
            );

        end

    end


    // ==========================================
    // MAIN TEST
    // ==========================================

    initial begin

        // --------------------------------------
        // Initial conditions
        // --------------------------------------

        reset  = 1'b1;
        button = 1'b0;


        // --------------------------------------
        // Reset
        // --------------------------------------

        #100;

        reset = 1'b0;


        // ======================================
        // TEST 1
        // Short button pulse
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 1: SHORT BUTTON PULSE");
        $display("Expected: NO button press");
        $display("==========================================");

        button = 1'b1;

        // Button HIGH for only 1 us
        #1000;

        button = 1'b0;

        // Wait a little
        #5000;


        // ======================================
        // TEST 2
        // Button bounce
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 2: BUTTON BOUNCE");
        $display("Expected: NO button press");
        $display("==========================================");

        button = 1'b1;
        #100;

        button = 1'b0;
        #100;

        button = 1'b1;
        #150;

        button = 1'b0;
        #80;

        button = 1'b1;
        #120;

        button = 1'b0;
        #100;

        button = 1'b1;
        #200;

        button = 1'b0;

        // Give the debouncer enough time to
        // settle back to LOW
        #15000000;


        // ======================================
        // TEST 3
        // Valid button press
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 3: VALID BUTTON PRESS");
        $display("Expected: EXACTLY ONE button press");
        $display("==========================================");

        // Press button
        button = 1'b1;

        // Hold for 15 ms
        #15000000;

        // Release button
        button = 1'b0;

        // IMPORTANT:
        // Give the debouncer 15 ms to recognize
        // that the button has been released.
        #15000000;


        // ======================================
        // TEST 4
        // Long button hold
        // ======================================

        $display("");
        $display("==========================================");
        $display("TEST 4: LONG BUTTON HOLD");
        $display("Expected: EXACTLY ONE button press");
        $display("==========================================");

        // Press again
        button = 1'b1;

        // Hold for 30 ms
        #30000000;

        // Release
        button = 1'b0;

        // Give debouncer time to recognize release
        #15000000;


        // ======================================
        // FINISH
        // ======================================

        $display("");
        $display("==========================================");
        $display("BUTTON DEBOUNCER TEST COMPLETE");
        $display("==========================================");

        $finish;

    end

endmodule