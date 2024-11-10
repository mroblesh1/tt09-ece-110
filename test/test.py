# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset


    # Test 1: Low frequency signal (low frequency input)
    dut._log.info("Testing low frequency signal")
    dut.ui_in.value = 0  # Initial signal input set to low (for a low frequency signal)
    await ClockCycles(dut.clk, 100)  # Wait for 100 clock cycles (simulate low frequency)

    # Test 2: High frequency signal (high frequency input)
    dut._log.info("Testing high frequency signal")
    for _ in range(50):  # Simulate for 50 high/low cycles (high frequency)
        dut.ui_in.value = 1  # Set input signal to high
        await ClockCycles(dut.clk, 5)  # Wait for 5 clock cycles (short period)
        dut.ui_in.value = 0  # Set input signal to low
        await ClockCycles(dut.clk, 5)  # Wait for 5 clock cycles (short period)


    # await ClockCycles(dut.clk, 20)
    # assert dut.ui_out.value == 128

    dut._log.info("Finished test")
