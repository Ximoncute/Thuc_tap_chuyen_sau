/*      
Module chia tan cung cap tan so 1500kHz
Tan so dau vao hien tai la 27MHz
*/

module clk_1500k(
    input clk27m,
    input rst,
    output clk1500k
);
    parameter Devision = 18; 

    reg clk1500ktemp = 0;
    integer countclk = 0;
    always @(posedge clk27m) begin
            if (countclk  < (Devision/2) - 1) countclk <= countclk + 1;  
            else begin
                countclk <= 0;
                clk1500ktemp <= ~clk1500ktemp;
            end
        //end
    end
    assign clk1500k = clk1500ktemp;
endmodule