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
  assign uio_oe  = 1;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in, 1'b0};

  // One idea is to have a Decoder, Encoder, and Delta Modulator on one chip
  // There will be 2 dedicated uio inputs to select between these 3
  // 00 - Frequency Decoder
  // 01 - Frequency Encoder
  // 10 - Delta Modulator
  // 11 - Delta Modulator
  // When FreqDecode selected, there will be additional inputs added to select between
  // different sampling periods (ui_in)
  //

  // Instantiate FreqDecode module
  FrequencyDecoder decoder_inst (
    .clk(clk),
    .reset(~rst_n),
    .signal_in(ui_in[0]),
    .sample_rate(uio_in[7:6]),

    //.freq_range(uio_out[5]),
    .freq_out(uo_out)
  );

endmodule
