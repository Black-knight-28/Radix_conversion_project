`timescale 1ns / 1ps

module radix_converter(
    
    input logic clk,
    input logic reset_n,
    input logic btn_center,
    input logic [15:0] SW,
    input logic btn_right,
    input logic btn_left,
    
    output logic [6:0] seg,
    output logic [7:0] an
    
    );
    
    logic reset;
    assign reset = ~reset_n;
    
    // all the inputs and outputs are the physical 
    // inputs. 
    // all the other signals are generated inside the 
    // module itself
    
    logic [3:0] digit3;  // signals for the number 
    logic [3:0] digit2;
    logic [3:0] digit1;
    logic [3:0] digit0;
    
    logic [3:0] input_radix; // signals for the radix
    logic [3:0] output_radix;
    
    logic convert_enable; // flag to start converting
    
    // for capturing the signal that i/p to int. module 
    // produces 
    
    logic [15:0] dec_val;
    
    // for the int. to oouput module's output 
    
    logic [3:0] output_digit [0:15];
    
    // getting the FSM state
    logic [1:0] fsm_state;
    
    // getting the live digits from the switches
    
    logic [3:0] live_digit [0:15];
    
    //adding the disp data, the data we wannan display
    logic [3:0] display_data [0:15];
    
    // debouncer variables
    logic center_pressed;
    logic right_pressed;
    logic left_pressed;
    
    // mapping the switches to the 7 seg disp
    
    always_comb 
    begin 
        
            // clear all the live display
            for(int i = 0; i < 16; i = i+1)
            begin
            
                    live_digit[i] = 4'b0000;
            
            end
            
            // mapping the switches to the display
            live_digit[15] = SW[3:0];
            live_digit[14] = SW[7:4];
            live_digit[13] = SW[11:8];
            live_digit[12] = SW[15:12];
            
    
    end
    
    
    // choosing which data will be sent to the 7-seg disp based
    // on the FSM state
    
    always_comb
    begin 
            
            //clear the display by default 
            for(int i = 0; i < 16; i=i+1)
            begin 
                    
                    display_data[i] = 4'b0000;
                    
            end
            
            case(fsm_state)
            
                    
                    // S numebr: show the input number
                    2'b00: 
                    begin 
                            
                            for(int i = 0; i<16; i=i+1)
                            begin 
                            
                                    display_data[i] = live_digit[i];
                            
                            end
                            
                    end
                    
                    // for the input radix, S_radix
                    2'b01:
                    begin 
                            display_data[15] = SW[3:0];
                    end
                    
                    //for the output radix, S_output_radix
                    2'b10:
                    begin 
                            display_data[15] = SW[3:0];
                    end
                    
                    //for the output, show the ocnverted numbers
                    2'b11: 
                    begin
                            for(int i=0; i<16;i=i+1)
                            begin
                                    display_data[i] = output_digit[i];
                            end
                    end
                    
                    default: 
                    begin 
                            //keep the displ cleared
                    end
            
            endcase
            
    end
    
    // getting the input controller
    input_controller input_ctrl (
            
            .clk(clk),
            .reset(reset),
            .btn_center(center_pressed),
            .SW(SW),
            
            .digit3(digit3),
            .digit2(digit2),
            .digit1(digit1),
            .digit0(digit0),
            .input_radix(input_radix),
            .output_radix(output_radix),
            .convert_enable(convert_enable),
            .fsm_state(fsm_state)      
    );
    
    // getting the input_to_integer, second module 
    input_to_integer input_int(
            
            .digit3(digit3),
            .digit2(digit2),
            .digit1(digit1),
            .digit0(digit0),
            .input_radix(input_radix),
            
            .dec_val(dec_val)
    );
    
    //getting the integer_to_output module
    integer_to_output int_out(
            
            .dec_val(dec_val),
            .output_radix(output_radix),
            
            .output_digit(output_digit)
    );
    
    // controls which display is ON and for how much
    
    display_controller display_ctrl(
            
            .clk(clk),
            .reset(reset),
            
            .output_digit(display_data),
            
            .btn_right(right_pressed),
            .btn_left(left_pressed),
            
            .seg(seg),
            .an(an)     
    );
    
    // adding the debouncer circuits 
    button_debouncer center_debouncer(
            
            .clk(clk),
            .reset(reset),
            .button(btn_center),
            
            .button_pressed(center_pressed)
            
    );
    
    button_debouncer right_debouncer(
            
            .clk(clk),
            .reset(reset),
            .button(btn_right),
            
            .button_pressed(right_pressed)
            
    );
    
    button_debouncer left_debouncer(
            
            .clk(clk),
            .reset(reset),
            .button(btn_left),
            
            .button_pressed(left_pressed)
            
    );
endmodule
