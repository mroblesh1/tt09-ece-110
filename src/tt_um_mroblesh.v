/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_mroblesh (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out[7:0] = 8'b0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, 1'b0};

  // One idea is to have a Decoder, Encoder on one chip
  // uio_in[0] selects between these 2
  // 0 - Frequency Decoder
  // 1 - Frequency Encoder
  // When FreqDecode selected, there will be additional inputs added to select between
  // different sampling periods (ui_in)
  //

  wire [0:0] signal_in;
  wire [1:0] sample_rate;
  wire [7:0] in_bus;
  assign signal_in = uio_in[0] ? 1'b0 : ui_in[0]; // 0 unless in decode mode, in which case takes LSB of ui_in
  assign sample_rate = uio_in[0] ? 2'b0 : uio_in[7:6];  // 0 unless in decode mode
  assign in_bus = uio_in[0] ? ui_in : 8'b0; // 0 unless in encode mode, takes ui_in bus

  wire [7:0] freq_out;
  wire [0:0] out;
  assign uo_out[0] = uio_in[0] ? out : freq_out[0];
  assign uo_out[7:1] = uio_in[0] ? 7'b0 : freq_out[7:1];

  // Instantiate FreqDecode module
  FrequencyDecoder decoder_inst (
    .clk(clk),
    .reset(~rst_n),
    .signal_in(signal_in),
    .sample_rate(sample_rate),

    //.freq_range(uio_out[5]),
    .freq_out(freq_out)
  );

  FrequencyEncoder encoder_inst (
    .clk(clk),
    .reset(~rst_n),
    .in_bus(in_bus),
    .out(out)
  );

endmodule
