`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 05:00:40 PM
// Design Name: 
// Module Name: pixel_gen
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


module pixel_gen(
input wire clk, video_on,
input wire [9:0] pixel_x, pixel_y,
input wire [11:0] pixel_data_in,
output reg [11:0] rgb);
always @(*)
    // When video_on signal is low no color
    rgb = (~video_on) ? 12'b0000_0000_0000 : pixel_data_in;
endmodule
