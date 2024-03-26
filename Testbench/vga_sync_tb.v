`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2024 08:33:19 PM
// Design Name: 
// Module Name: vga_sync_tb
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

module vga_sync_tb;

    // Inputs
    reg clk;
    reg reset;
    // Outputs
    wire hsync;
    wire vsync;
    wire video_on;
    wire cnt3;
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    // For TB
    time h_gohi;
    time h_golo;
    
    // Instantiate the Unit Under Test (UUT)
    vga_sync uut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .cnt3(cnt3),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        $timeformat(-9, 2, " ns", 10);
        // Wait 100 ns for global reset to finish
        #100 reset = 0;
    end
    
    // Check hsync, vsync
    always @(posedge hsync) begin
        $write("hsync hi : %d", pixel_x);
        $display(" At time %t ", $stime);
        h_gohi = $stime;
        @(negedge hsync)
        $write("hsync lo : %d", pixel_x);
        $display(" At time %t ", $stime);
        h_golo = $stime;
        $display("hsync high width: %t ", h_golo-h_gohi);
    end
    
    always @(posedge vsync) begin
        $write("vsync hi : %d", pixel_y);
        $display(" At time %t ", $stime);
        h_gohi = $stime;
        @(negedge vsync)
        $write("vsync lo : %d", pixel_y);
        $display(" At time %t ", $stime);
        h_golo = $stime;
        $display("vsync high width: %t ", h_golo-h_gohi);
    end
    
endmodule