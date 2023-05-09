`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2023 06:50:51 PM
// Design Name: 
// Module Name: blinky_top
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


// Doug's practice is to name signals that enter/leave the FPGA
// in all capitals.

module blinky_top (
  input  logic       CLK_200_P,
  input  logic       CLK_200_N,
  output logic [7:0] LED
);

logic clk_200;

// Turn our differential clock into a single-ended clock
IBUFDS ibufds(
  .I  (CLK_200_P),
  .IB (CLK_200_N),
  .O  (clk_200)
);

localparam COUNTER_START = 32'd100_000_000;
logic [31:0] counter = COUNTER_START;
// It looks like the LEDs are inverted, so they are on when logic low.
initial LED = 8'b1111_1110; // 8'b0000_0001;

always_ff @(posedge clk_200) begin
  if (counter == 0) begin
    counter <= COUNTER_START;
    LED <= {LED[6:0], LED[7]};
  end else begin
    counter <= counter - 1'd1;
  end
end


endmodule
