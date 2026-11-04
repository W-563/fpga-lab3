`timescale 1ns / 1ns

module tb_vga_pic;

reg vga_clk = 1'b0;
reg sys_rst_n = 1'b0;
reg [9:0] pix_x = 10'd0;
reg [9:0] pix_y = 10'd0;
wire [15:0] pix_data;

vga_pic dut (
    .vga_clk (vga_clk),
    .sys_rst_n (sys_rst_n),
    .pix_x (pix_x),
    .pix_y (pix_y),
    .pix_data (pix_data)
);

always #20 vga_clk = ~vga_clk;

initial begin
$dumpfile("tb_vga_pic.vcd");
$dumpvars(0, tb_vga_pic);
$timeformat(-9, 0, " ns", 6);
$monitor("t=%t rst_n=%b x=%d y=%d pix_data=%h", $time, sys_rst_n, pix_x, pix_y, pix_data);

//T1 reset: pix_data=0000
//T2 apply coordinates at falling edges; check after the next rising edge
#40 sys_rst_n = 1'b1;
pix_x = 10'd144; pix_y = 10'd208; //t=60: F800, M lit pixel
#40 pix_x = 10'd160;             //t=100: 0000, hole inside M
#40 pix_x = 10'd175; pix_y = 10'd232; //t=140: F800
#40 pix_x = 10'd220; pix_y = 10'd240; //t=180: 0000, gap
#40 pix_x = 10'd207; pix_y = 10'd271; //t=220: F800, last M pixel
#40 pix_x = 10'd208;             //t=260: 0000, outside M
#40 pix_x = 10'd336; pix_y = 10'd216; //t=300: 001F, S
#40 pix_x = 10'd392;             //t=340: 0000, S hole
#40 pix_x = 10'd240; pix_y = 10'd208; //t=380: 07E0, U
#40 pix_x = 10'd464;             //t=420: FFFF, T
#40 pix_x = 10'd639; pix_y = 10'd479; //t=460: 0000, background
#40 pix_x = 10'd1023; pix_y = 10'd1023; //t=500: 0000, invalid
#40 pix_x = 10'd144; pix_y = 10'd208; //t=540: F800 again

//T3 reset between clock edges: red becomes black immediately
#30 sys_rst_n = 1'b0;   //t=550: 0000 now; do not wait until t=580
#80 sys_rst_n = 1'b1;   //t=630: still black until the next rising edge

//T4 recovery: t=660 gives F800 again
#90 pix_x = 10'd0; pix_y = 10'd0; //t=720: request the other screen corner
#60;                   //t=740 output is 0000; keep it visible until the end
$display("END tb_vga_pic: compare each expected pixel with the waveform.");
$finish;               //t=780

end

endmodule