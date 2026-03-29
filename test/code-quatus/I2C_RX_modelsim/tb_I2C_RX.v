`timescale 1ns / 1ps

module tb_I2C_RX;

    reg clk;
    reg rst;
    reg enable;
    reg [7:0] add;

    wire [15:0] data;
    wire done;
    wire scl_i2c;
    wire sda;

    reg sda_in;
    reg scl_in;
    wire sda_wire;
    wire scl_wire;

    // Pull up for inout lines
    assign sda_wire = sda_in ? 1'bz : 0;
    assign scl_wire = scl_in ? 1'bz : 0;

    assign sda = sda_wire;
    assign scl_i2c = scl_wire;

    I2C_RX uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .add(add),
        .data(data),
        .done(done),
        .scl_i2c(scl_wire),
        .sda(sda_wire)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        // Init values
        rst = 0;
        enable = 0;
        add = 8'hA1; // Example address

        sda_in = 1;
        scl_in = 1;

        // Reset
        #20;
        rst = 1;

        #10;
        enable = 1;

        // Simulate some slave behavior for ACK
        // Simple emulation - for a real test, you would simulate actual I2C slave responses
        // Start sending ACKs or DATA after few cycles
        #200;
        sda_in = 0; // Simulate ACK from slave

        #100;
        sda_in = 1; // Release SDA

        // Let it run for a while
        #1000;

        // Stop simulation
        $finish;
    end

    initial begin
        $dumpfile("i2c_rx_tb.vcd");
        $dumpvars(0, tb_I2C_RX);
    end
	 
	 
	 // ... [giữ nguyên phần đầu testbench như trước]

    reg [15:0] fake_data = 16'hABCD;
    integer bit_index = 15;
    reg sending_data = 0;

    always @(negedge uut.scl_i2c) begin
        // Mô phỏng gửi dữ liệu từ slave khi ở trạng thái READ_DATA
        if (uut.state == uut.READ_DATA && sending_data == 1) begin
            sda_in = fake_data[bit_index];
            bit_index = bit_index - 1;
        end

        // Chuẩn bị gửi data khi vào READ_DATA
        if (uut.state == uut.READ_DATA && sending_data == 0) begin
            sending_data = 1;
            bit_index = 15;
        end

        // Sau khi gửi hết 16 bit
        if (bit_index < 0) begin
            sda_in = 1; // nhả SDA
            sending_data = 0;
        end
    end

    // ACK sau mỗi byte
    always @(posedge uut.scl_i2c) begin
        if (uut.state == uut.READ_ACK_NACK) begin
            sda_in = 0; // Giả lập ACK
        end
    end


endmodule
