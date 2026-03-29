module BH1750_convert(
    input clk,                                                  
    input enable,
    input rst,

    output reg [15:0] data,
    output reg done,

    inout sda,
    inout scl
);
    parameter clock = 1500; //1500k

    parameter BH1750_address = 7'h23;
    parameter NON_add_reg = 8'hff;
    parameter MODE_READ = 1'b1;
    parameter MODE_WRITE = 1'b0;

    parameter ON_SENSOR = 0;
    parameter RESET_SENSOR = 1;
    parameter CONVERT_LUX = 2;
    parameter IDLE = 3;
    parameter READ_LUX = 4;
    parameter OFF_SENSOR = 5;
    parameter END_READ = 6;
    

    parameter Power_Down = 8'h00;
    parameter Power_on = 8'h01;
    parameter Reset = 8'h07;
    parameter Con_H_Resolution_Mode = 8'h10;
    parameter Con_H_Resolution_Mode2 = 8'h11;
    parameter Con_L_Resolution_Mode = 8'h13;
    parameter ONET_H_Resolution_Mode = 8'h20;
    parameter ONET_H_Resolution_Mode2 = 8'h21;
    parameter ONET_L_Resolution_Mode = 8'h23;
    

    integer state = 0;
    integer count = 0;
    reg enable_send = 0, enable_receive = 0;
    reg [7:0] address;
    reg [7:0] datain;
    wire [15:0] lux;
    
    wire done_send, done_receice;

    I2C_RX uut1(.clk(clk), .data(lux), .enable(enable_receive), .rst(rst), .scl_i2c(scl), .sda(sda), .done(done_receice), .add(address));
    I2C_TX uut2(.clk(clk), .rst(rst), .enable(enable_send), .add_reg(NON_add_reg), .num_byte(1), .data(datain), .add(address), .done(done_send), .scl_i2c(scl), .sda(sda)); 

    always @(posedge clk) begin
        if (~rst || ~ enable) begin
            state <= 0;
            done <= 0;
            count <= 0;
            enable_receive <= 0;
            enable_send <= 0;
        end
        else begin
            done <= 0;
            case (state) 
                ON_SENSOR: begin
                    address <= {BH1750_address , MODE_WRITE};
                    enable_send <= 1;
                    datain <= Power_on;
                    if (done_send) begin
                        enable_send <= 0;
                        state <= CONVERT_LUX;
                    end
                end
                RESET_SENSOR: begin
                    address <= {BH1750_address , MODE_WRITE};
                    enable_send <= 1;
                    datain <= Reset;
                    if (done_send) begin
                        enable_send <= 0;
                        state <= CONVERT_LUX;
                    end
                end
                CONVERT_LUX: begin
                    address <= {BH1750_address , MODE_WRITE};
                    enable_send <= 1;
                    datain <= ONET_H_Resolution_Mode;
                    if (done_send) begin
                        enable_send <= 0;
                        state <= IDLE;
                    end
                end
                IDLE: begin
                    count <= count + 1;
                    if (count >= 120*clock) begin           //120ms
                        count <= 0;
                        state <= READ_LUX;
                    end
                end
                READ_LUX: begin
                    address <= {BH1750_address , MODE_READ};
                    enable_send <= 0;
                    enable_receive <= 1;
                    if (done_receice) begin
                        data <= (lux)*10/12;
                        enable_receive <= 0;
                        state <= END_READ;
                    end
                end
                OFF_SENSOR: begin
                    address <= {BH1750_address , MODE_WRITE};
                    enable_send <= 1;
                    datain <= Power_Down;
                    if (done_send) begin
                        enable_send <= 0;
                        state <= END_READ;
                    end
                end
                END_READ: done <= 1;
            endcase
        end
    end
endmodule