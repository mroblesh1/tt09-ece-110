<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Frequency Encoder:
Takes an 1-bit oscillating input and outputs frequency (# of rising edges in a sampling period). Takes in a 2-bit input to determine sampling period (100, 1k, 10k, 100k CC)

Frequency Decoder:
Takes in an 8-bit number and outputs a frequency corresponding to the input. Higher values correspond to a higher output frequency.

## How to test

Provided testbench mostly checks if decoder and encoder behave roughly as expected for a given constant input.

## External hardware

NA
