`timescale 1ns / 1ps


module input_controller(
    
    input logic clk,
    input logic reset,
    input logic btn_center,
    input logic [15:0] SW,
    
    output  logic [3:0] digit3,
    output  logic [3:0] digit2,
    output  logic [3:0] digit1,
    output  logic [3:0] digit0,
    
    output logic [3:0] input_radix,
    output logic [3:0] output_radix,
    output logic convert_enable,
    output logic [1:0] fsm_state
    );
    
   // declaring the FSM datatype
   
   typedef enum logic [1:0] {
    
        S_number,
        S_input_radix,
        S_output_radix,
        S_ready
    
   }state_t;
   
   state_t state;
   state_t next_state;
   assign fsm_state = state;
   
   always_ff @(posedge clk) begin
    
    if(reset)
        state <= S_number;
    else
        state <= next_state;
    end
    
    
    always_comb begin
    
        next_state = state;  //unless stated, be where you are
        
        case (state)
        
            S_number: begin
                if(btn_center)
                    next_state = S_input_radix;
                    end
                    
            S_input_radix: begin
                
                if(btn_center)
                    next_state = S_output_radix;  
            end
            
            S_output_radix: begin
                if(btn_center)
                    next_state = S_ready;
            end
            
            S_ready: begin
                next_state = S_ready;
            end
        
        endcase
    end
    
    always_comb begin
        
        convert_enable = 1'b0;
        
        if(state == S_ready)
            convert_enable = 1'b1;
    end
    
    always_ff @(posedge clk) 
    begin
        // have to make code such that it will remember what you entered in each state
        if(reset) 
        begin
            // clear all the values 
            digit3 <= 4'b0000;
            digit2 <= 4'b0000;
            digit1 <= 4'b0000;
            digit0 <= 4'b0000;
            
            input_radix <= 4'b0000;
            output_radix <= 4'b0000;
        end
        
        else 
        begin 
            // capture all the values
            case (state)
            
            S_number:
            begin 
                if (btn_center)
                begin 
                    // capture all the degits
                    digit3 <= SW[15:12];
                    digit2 <= SW[11:8];
                    digit1 <= SW[7:4];
                    digit0 <= SW[3:0]; 
                end   
             end
             
             S_input_radix:
             begin
                if(btn_center)
                begin
                    input_radix <= SW[3:0];
                end
             end
             
             S_output_radix:
             begin
                if(btn_center)
                begin
                    output_radix <= SW[3:0];
                end
             end
             
             S_ready:
             begin
             // do nothing
             end
                
            endcase
          
        end
    end
endmodule
