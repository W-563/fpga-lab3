`timescale 1ns / 1ns

module tb_vga_MUST;

reg sys_clk = 1'b0;
reg sys_rst_n = 1'b0;
wire hsync, vsync;
wire [15:0] rgb;

wire [9:0] cnt_h = dut.vga_ctrl_inst.cnt_h;
wire [9:0] cnt_v = dut.vga_ctrl_inst.cnt_v;
wire [9:0] pix_x = dut.pix_x;
wire [9:0] pix_y = dut.pix_y;
wire [15:0] pix_data = dut.pix_data;

vga_MUST dut (
    .sys_clk (sys_clk),
    .sys_rst_n (sys_rst_n),
    .hsync (hsync),
    .vsync (vsync),
    .rgb (rgb)
);

always #10 sys_clk = ~sys_clk;

initial begin
$dumpfile("tb_vga_MUST.vcd");

//Extra usage: select signals; record sync and colour continuously.
$dumpvars(0, tb_vga_MUST.sys_rst_n, tb_vga_MUST.hsync, tb_vga_MUST.vsync, tb_vga_MUST.pix_data, tb_vga_MUST.rgb);
$timeformat(-9, 0, " ns", 6);
$monitor("t=%t rst_n=%b vsync=%b", $time, sys_rst_n, vsync);

//T1 reset: no characters
#40 sys_rst_n = 1'b1;

//T2 screen pixel (144,208), one ns after its display edge
#7787491;              //t=7787531: h=288, v=243, rgb=F800
$display("T2 t=%t h=%d v=%d request_x=%d request_y=%d data=%h rgb=%h",
         $time, cnt_h, cnt_v, pix_x, pix_y, pix_data, rgb);

//T3 reset while M is red; hold reset for 80 ns
#9 sys_rst_n = 1'b0;   //t=7787540: rgb=0000 immediately
#80 sys_rst_n = 1'b1;  //t=7787620: restart the divider and scanning

//T4 the same displayed pixel after recovery
#7787491;              //t=15575111: h=288, v=243, rgb=F800
$display("T4 t=%t h=%d v=%d request_x=%d request_y=%d data=%h rgb=%h",
         $time, cnt_h, cnt_v, pix_x, pix_y, pix_data, rgb);

//Continue until two full frames and the second sync pulse are recorded
#25912509;
$display("END tb_vga_MUST: measure sync and inspect reset/recovery.");
$finish;               //t=41487620
end

endmodule