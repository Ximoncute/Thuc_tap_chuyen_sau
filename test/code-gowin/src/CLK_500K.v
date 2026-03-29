/*      
Module chia tan cung cap tan so 500kHz
Tan so dau vao hien tai la 27MHz
*/

module clk_500k(
    input clk27m,
    input rst,
    output clk500k
);
    parameter Devision = 54; 

    reg clk500ktemp = 0;
    integer countclk = 0;
    always @(posedge clk27m) begin
            if (countclk  < (Devision/2) - 1) countclk <= countclk + 1;  
            else begin
                countclk <= 0;
                clk500ktemp <= ~clk500ktemp;
            end
        //end
    end
    assign clk500k = clk500ktemp;
endmodule