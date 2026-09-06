`timescale 1ns / 1ps


module input_to_integer(

    input logic [3:0] digit3,
    input logic [3:0] digit2,
    input logic [3:0] digit1,
    input logic [3:0] digit0,
    input logic [3:0] input_radix,
    
    output logic [15:0] dec_val   // this is the integer decimal value
    );
    
    // we should use a combinational block over here because 
    // there is nothing to be remembered. 
    
    // it is better to create smaller equations with intermidiate rather than using 
    // one big equation
    
    // getting the intermidiate values
    
    logic [15:0] val_1;
    logic [15:0] val_2;
    logic [15:0] val_3;
    
    always_comb 
    begin 
        val_1 = digit3 * input_radix + digit2;
        val_2 = val_1 * input_radix + digit1;
        val_3 = val_2 * input_radix + digit0;
        
        // assigning val_3 as the output
        
        dec_val = val_3;
    end
    
    
endmodule
