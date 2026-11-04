# FPGA Lab 3: Simple VGA Display

EIE330 FPGA-based System Design, Lab 3.

| Folder | Task | Contents |
|---|---|---|
| RTL | Display MUST on a 640 × 480 VGA screen | pll.v, vga_ctrl.v, vga_pic.v, vga_MUST.v (top) + complete RTL views |
| sim | Module and top-level simulation | Four testbenches + simulation data (CSV) + waveforms |
| Evidence | Board test and result checks | Display and reset images, reconstructed screen, synthesis statistics and verification records |

Clock: 50 MHz on `sys_clk`, divided to a 25 MHz pixel clock. Active-low asynchronous reset: `sys_rst_n`. The letters disappear during reset and return after release. M is red, U green, S blue and T white on a black background.

Simulation (run inside the repository folder):

```bash
iverilog -o sim/tb_vga_MUST.vvp -y RTL sim/tb_vga_MUST.v
vvp sim/tb_vga_MUST.vvp
gtkwave tb_vga_MUST.vcd
```

For module tests, replace `tb_vga_MUST` with `tb_pll`, `tb_vga_ctrl` or `tb_vga_pic`.

Synthesis:

```bash
yosys -p 'read_verilog RTL/*.v; hierarchy -top vga_MUST; proc; opt; stat'
```

Board: Intel/Altera Cyclone IV EP4CE10F17C8N. Virtual-board mapping: clk → sys_clk, reset → sys_rst_n, h_sync → hsync, v_sync → vsync, rgb → rgb.

Tools: Icarus Verilog, Yosys, GTKWave, Simple-VGA-Simulator.

Group members: Zheng Mengxu, Wang Minglun, Ding Zhaoheng.
