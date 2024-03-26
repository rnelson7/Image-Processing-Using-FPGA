`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 04:58:09 PM
// Design Name: 
// Module Name: vga_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync(
input wire clk, reset,
output wire hsync, vsync, video_on, cnt3,
output wire [9:0] pixel_x, pixel_y
);
// Constant declaration
// VGA 640x480 sync parameters
parameter HD = 640, // horizontal display area
          HF = 16,  // left border/front porch
          HB = 48, // right border/back porch
          HR = 96, // horizontal retrace
          VD = 480, // vertical display area
          VF = 10, // bottom border/front porch
          VB = 33, // top border/back porch
          VR = 2; // vertical retrace
reg [1:0] ccount;

// clock divider enable (25MHz)
assign cnt3 = ccount == 2'b11;
always @ (posedge clk, posedge reset)
    if (reset) ccount <= 2'b0; else
        if (cnt3) ccount <= 2'b0; else
        ccount <= ccount + 2'b1;

// VGA circuitry
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;

// Output buffer
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;

// Status signal
wire h_end, v_end;

// Body registers
always @ (posedge clk, posedge reset)
    if (reset)
        begin
            v_count_reg <= 10'b0;
            h_count_reg <= 10'b0;
            v_sync_reg <= 1'b0;
            h_sync_reg <= 1'b0;
        end
    else
    begin
        v_count_reg <= v_count_next;
        h_count_reg <= h_count_next;
        v_sync_reg <= ~v_sync_next;
        h_sync_reg <= ~h_sync_next;
    end
    
// Status signals
// End of horizontal counter (799)
assign h_end = (h_count_reg == (HD+HF+HB+HR-1));

// End of vertical counter (524)
assign v_end = (v_count_reg == (VD+VF+VB+VR-1));

// Next state logic of mod 800 horizontal sync counter
always @(*)
    if (cnt3)
        if (h_end)
            h_count_next = 0;
        else
            h_count_next = h_count_reg + 10'b1;
    else
        h_count_next = h_count_reg;
            
// Next state logic of mod 525 vertical sync counter
always @(*)
    if (cnt3)
        if (h_end)
            if (v_end)
                v_count_next = 10'b0;
            else
                v_count_next = v_count_reg + 10'b1;
         else
              v_count_next = v_count_reg;
    else
        v_count_next = v_count_reg;
        
// Horizontal and vertical sync, buffered to avoid glitch

// h_sync_next asserted between 656 and 751
assign h_sync_next = (h_count_reg >= (HD+HF) &&
h_count_reg <= (HD+HF+HR-1));

// v_sync_next asserted between 656 and 751
assign v_sync_next = (v_count_reg >= (VD+VF) &&
v_count_reg <= (VD+VF+VR-1));

// Video on/off
assign video_on = (h_count_reg < HD) && (v_count_reg < VD);

// Output
assign hsync = h_sync_reg;
assign vsync = v_sync_reg;
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;

endmodule