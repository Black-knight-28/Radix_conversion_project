`timescale 1ns / 1ps

module display_controller(
        
        input logic clk,
        input logic reset,
        input logic [3:0] output_digit [0:15],
        
        input logic btn_right,  // these buttons are for controlling the bit 
        input logic btn_left,   // width window
        
        output logic [6:0] seg,
        output logic [7:0] an
    );
    
    // choosing which display to choose
    logic [2:0] display_select; 
    
    // refresh counter 
    logic [16:0] refresh_counter;
    
    //selecting which part of the number to display
    logic scroll_select;
    
    always_ff @(posedge clk)
    begin 
            if (reset)
            begin
                    refresh_counter <= 17'd0;
                    display_select <= 3'd0;
            end
            
            else 
            begin 
                    // counter logic 
                    if (refresh_counter == 17'd99999)
                    begin
                            refresh_counter <= 17'd0;
                            
                            if(display_select == 3'd7)
                            begin 
                                    display_select <= 3'd0;
                            end
                            
                            else 
                                    display_select <= display_select +1'b1;
                    end
                    
                    else 
                    begin
                            refresh_counter <= refresh_counter +1'b1;
                    end
            end
    end
    
    // choosing the display
    always_comb
    begin 
            an = 8'b11111111;  //the anodes are active low, so this means no
                               // display is selected
                                          
            case (display_select)
                    // we mapped the display so we just havr to type 1 numebr 
                    // instead of the entire 'an' sequence. 
                    3'd0: an = 8'b11111110;
                    3'd1: an = 8'b11111101;
                    3'd2: an = 8'b11111011;
                    3'd3: an = 8'b11110111;
                    3'd4: an = 8'b11101111;
                    3'd5: an = 8'b11011111;
                    3'd6: an = 8'b10111111;
                    3'd7: an = 8'b01111111;
                    
                    default: an = 8'b11111111;
            endcase
    end
    
    logic [3:0] selected_digit;  // four bits as we are using 4 bits to 
                                 // represent 1 display
    // mapping the displays acc to our number system
    
    always_comb 
    begin 
    
            if (scroll_select == 1'b0)
            begin
            
                    case (display_select)
                    
                            3'd0: selected_digit = output_digit[15];
                            3'd1: selected_digit = output_digit[14];
                            3'd2: selected_digit = output_digit[13];
                            3'd3: selected_digit = output_digit[12];
                            3'd4: selected_digit = output_digit[11];
                            3'd5: selected_digit = output_digit[10];
                            3'd6: selected_digit = output_digit[9];
                            3'd7: selected_digit = output_digit[8];
                    
                            default: selected_digit = 4'd0;
                    
                    endcase
            end
            
            else
            begin 
                    case (display_select)
                    
                            3'd0: selected_digit = output_digit[7];
                            3'd1: selected_digit = output_digit[6];
                            3'd2: selected_digit = output_digit[5];
                            3'd3: selected_digit = output_digit[4];
                            3'd4: selected_digit = output_digit[3];
                            3'd5: selected_digit = output_digit[2];
                            3'd6: selected_digit = output_digit[1];
                            3'd7: selected_digit = output_digit[0];
                            
                            default: selected_digit = 4'd0;
                    
                    endcase
            end
                    
    end
    
    
    // we still have to display this on the seven segment display. 
    // instantiate that 7 segment decoder
    
    seven_segment_decoder decoder(
            
            .digit(selected_digit),
            .seg(seg)       
    );
    
    
    
    
    always_ff @(posedge clk)
    begin 
            
            if (reset)
            begin 
                    scroll_select <= 1'b0;
            end
            
            else 
            begin 
                    // implement the button logic here 
                    if (btn_right)
                    begin 
                            
                            scroll_select <= 1'b1;
                            
                    end
                    
                    else if (btn_left)
                    begin 
                            
                            scroll_select <= 1'b0;
                            
                    end
            end
            
    end
    
endmodule
