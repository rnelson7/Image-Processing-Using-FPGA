`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 04:48:21 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
input clock_100mhz, reset,
input pixel_data,
output hsync_out, vsync_out, rgb_out);
// 8 Bit color data input from swtiches
wire [11:0] pixel_data;
// Interconnecting clock divide wire from vga_sync
wire clock_25Mhz;
// hysnc & vsync from vga_sync
wire hysnc, vsync;
// video_on from vga_sync
wire video_on_out;
// Pixel locations from vga_sync
wire [9:0] pixel_x_out, pixel_y_out;
// RGB data from pixel_gen
wire [11:0] rgb_out;
vga_sync VGASYNC0  (clock_100mhz, reset, hsync_out, vsync_out, video_on_out,
                    clock_25Mhz, pixel_x_out, pixel_y_out);
pixel_gen PIXELGEN0 (clock_25Mhz, video_on_out, pixel_x_out, pixel_y_out,
                     pixel_data, rgb_out);
endmodule
