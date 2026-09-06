`timescale 1ns / 1ps

module button_debouncer (

    input  logic clk,
    input  logic reset,
    input  logic button,

    output logic button_pressed

);

    // ==========================================
    // Synchronizer
    // ==========================================

    logic sync_ff1;
    logic sync_ff2;


    // ==========================================
    // Debouncer
    // ==========================================

    logic stable_button;

    logic [19:0] counter;


    // ==========================================
    // Synchronize the asynchronous button
    // ==========================================

    always_ff @(posedge clk) begin

        if (reset) begin

            sync_ff1 <= 1'b0;
            sync_ff2 <= 1'b0;

        end

        else begin

            sync_ff1 <= button;
            sync_ff2 <= sync_ff1;

        end

    end


    // ==========================================
    // Debounce + one-clock pulse
    // ==========================================

    always_ff @(posedge clk) begin

        if (reset) begin

            stable_button <= 1'b0;
            counter       <= 20'd0;
            button_pressed <= 1'b0;

        end

        else begin

            // Default: no button press
            button_pressed <= 1'b0;


            // Button is different from our
            // currently accepted state
            if (sync_ff2 != stable_button) begin

                // Keep counting while the new
                // state remains stable

                if (counter == 20'd999999) begin

                    // Accept the new button state
                    stable_button <= sync_ff2;

                    counter <= 20'd0;


                    // Generate pulse only when
                    // button becomes HIGH
                    if (sync_ff2 == 1'b1)
                        button_pressed <= 1'b1;

                end

                else begin

                    counter <= counter + 1'b1;

                end

            end

            else begin

                // Nothing changed
                counter <= 20'd0;

            end

        end

    end

endmodule