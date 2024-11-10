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
    dut.uio_in.value = 0    # Decode mode

    dut.uio_in.value = 0    # assert that period = 100000
    await ClockCycles(dut.clk, 10)
    dut.uio_in.value = 64  # assert that period = 10000
    await ClockCycles(dut.clk, 10)
    dut.uio_in.value = 128  # assert that period = 1000
    await ClockCycles(dut.clk, 10)
    dut.uio_in.value = 192  # assert that period = 100
    await ClockCycles(dut.clk, 10)

    # Assume 10 MHz clock speed
    
    dut._log.info("Testing Decoder")


    # Test 1: High frequency signal (10 kHz)
    # @ 100 sampling period (should be 10 crossings)
    dut._log.info("Testing high frequency signal, 10 kHz @ 100 sampling period")
    for _ in range(50):  # Simulate for 50 high/low cycles (high frequency)
        dut.ui_in.value = 1  # Set input signal to high
        await ClockCycles(dut.clk, 5)  # Wait for 5 clock cycles (short period)
        dut.ui_in.value = 0  # Set input signal to low
        await ClockCycles(dut.clk, 5)  # Wait for 5 clock cycles (short period)

    assert dut.uo_out == 10

    # Test 2: Mid frequency signal (1 kHz)
    # @ 100 sampling period (should be 1 crossing)
    dut._log.info("Testing mid frequency signal, 1kHz @ 100 sampling period")
    for _ in range(5):  # Simulate for 50 high/low cycles (high frequency)
        dut.ui_in.value = 1  # Set input signal to high
        await ClockCycles(dut.clk, 50) 
        dut.ui_in.value = 0  # Set input signal to low
        await ClockCycles(dut.clk, 50)

    assert dut.uo_out == 1
    
    dut.uio_in.value = 128

    # Test 3: Mid frequency signal (1 kHz)
    # @ 1000 sampling period (should be 10 crossings)
    dut._log.info("Testing mid frequency signal, 1 kHz @ 1000 sampling period")
    for _ in range(10):  # Simulate for 50 high/low cycles (high frequency)
        dut.ui_in.value = 1  # Set input signal to high
        await ClockCycles(dut.clk, 50)
        dut.ui_in.value = 0  # Set input signal to low
        await ClockCycles(dut.clk, 50)

        
    assert dut.uo_out == 10

    # Test 4: Low frequency signal (500 Hz)
    # @ 100 sampling period (should be 5 crossings)
    dut._log.info("Testing low frequency signal, 1kHz @ 1000 sampling period")
    for _ in range(10):  # Simulate for 50 high/low cycles (high frequency)
        dut.ui_in.value = 1  # Set input signal to high
        await ClockCycles(dut.clk, 100)
        dut.ui_in.value = 0  # Set input signal to low
        await ClockCycles(dut.clk, 100)

    
    assert dut.uo_out == 5


    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset


    dut._log.info("Testing Encoder")

    dut.uio_in.value = 1    # Encode mode

    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1200)
    
    dut.ui_in.value = 16
    await ClockCycles(dut.clk, 1200)

    dut.ui_in.value = 64
    await ClockCycles(dut.clk, 1200)
    
    dut.ui_in.value = 128
    await ClockCycles(dut.clk, 1200)
    
    dut.ui_in.value = 255
    await ClockCycles(dut.clk, 50)

    dut._log.info("Finished test")
