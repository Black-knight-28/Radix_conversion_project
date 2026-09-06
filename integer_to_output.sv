`timescale 1ns / 1ps


module integer_to_output(
    
    input logic [15:0] dec_val,
    input logic [3:0] output_radix,
    
    output logic [3:0] output_digit [0:15]
    );
    
     logic [15:0] quotient;
     logic [4:0] remainder;
     
     // an index 
     integer i;
     
     always_comb 
     begin 
        // clearing out the array
        for(i = 0 ; i < 16; i = i+1)
        begin 
                output_digit[i] = 4'b0;
        end
        
        quotient = dec_val;
        
        // putting out another loop for the division 
        // algorithm 
        if(output_radix >= 4'd2)
        begin
                for(i = 0; i < 16; i=i+1)
                begin 
                        remainder = quotient % output_radix;
                        output_digit[15-i] = remainder;
                        quotient = quotient / output_radix;
                end
        end
     end
     
     
endmodule
