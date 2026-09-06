`timescale 1ns / 1ps


module seven_segment_decoder(

        input logic [3:0] digit,
        output logic [6:0] seg
    );
    
    // this module is purely combinational 
    always_comb
    begin 
            case (digit)
            
                    4'd0: seg = 7'b0000001;
                    4'd1: seg = 7'b1001111;
                    4'd2: seg = 7'b0010010;
                    4'd3: seg = 7'b0000110;
                    4'd4: seg = 7'b1001100;
                    4'd5: seg = 7'b0100100;
                    4'd6: seg = 7'b0100000;
                    4'd7: seg = 7'b0001111;
                    4'd8: seg = 7'b0000000;
                    4'd9: seg = 7'b0000100;
                    4'd10:seg = 7'b0001000;  //A
                    4'd11:seg = 7'b1100000; // b
                    4'd12:seg = 7'b0110001; // C
                    4'd13:seg = 7'b1000010; // d
                    4'd14:seg = 7'b0110000; // E
                    
                    
            
            endcase
    end
    
endmodule
