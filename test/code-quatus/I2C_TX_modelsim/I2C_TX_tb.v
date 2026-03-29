`timescale 1ns/1ps

module I2C_TX_tb;

    // Tín hiệu điều khiển
    reg clk;
    reg rst;
    reg enable;
    reg [7:0] data;
    reg [7:0] add;
    reg [7:0] add_reg;
    reg [2:0] num_byte;

    wire done;

    // Tín hiệu SDA và SCL trung gian
    wire scl_wire;
    wire sda_wire;

    // Dây bus I2C thả nổi
    wire scl_i2c;
    wire sda;

    // Giả lập pull-up 
    assign scl_i2c = scl_wire;
    assign sda = sda_wire;

    // Module cần test
    I2C_TX uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .data(data),
        .add(add),
        .add_reg(add_reg),
        .num_byte(num_byte),
        .done(done),
        .scl_i2c(scl_wire),
        .sda(sda_wire)
    );

    // Clock 100ns -> 10MHz
    initial begin
        clk = 0;
        forever #50 clk = ~clk;
    end

    // Test logic
    initial begin
        // Giá trị ban đầu
        rst = 0;
        enable = 0;
        data = 8'h10;           // Lệnh gửi cho BH1750
        add = 8'h46;            // 0x23 << 1 (Write)
        add_reg = 8'hff;        // Không gửi thanh ghi
        num_byte = 3'd1;        // Gửi 1 byte

        #200;
        rst = 1;
        #500;
        enable = 1;

        wait (done == 1);
        #2000;

        enable = 0;
        $display("Transmission finished.");
        $stop;
    end

endmodule

