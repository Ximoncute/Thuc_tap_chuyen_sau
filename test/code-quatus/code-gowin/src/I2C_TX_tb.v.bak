`timescale 1ns / 1ps

module I2C_TX_tb;
    reg clk;
    reg rst;
    reg enable;
    reg [7:0] data;
    reg [7:0] add;
    reg [7:0] add_reg;
    reg [2:0] num_byte;

    wire scl_i2c;
    wire sda;
    
    // Instantiate the I2C_TX module
    I2C_TX uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data(data),
        .add(add),
        .add_reg(add_reg),
        .num_byte(num_byte),
        .done(),
        .scl_i2c(scl_i2c),
        .sda(sda)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        enable = 0;
        data = 8'hA5;
        add = 8'h50;      // Example slave address
        add_reg = 8'h10;  // Example register address
        num_byte = 3'b001; // Sending 1 byte

        // Reset pulse
        #20;
        rst = 1;

        // Enable transmission
        #20;
        enable = 1;

        // Wait for transmission
        #2000;

        // Finish simulation
        $stop;
    end
endmodule
