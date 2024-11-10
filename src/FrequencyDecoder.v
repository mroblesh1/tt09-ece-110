module FrequencyDecoder (
    input wire clk,                // System clock
    input wire reset,              // Reset signal
    input wire signal_in,          // 1-bit frequency input signal
    input wire [1:0] sample_rate, // 00: 
    //output reg freq_range,        // 0 when low frequency (0-255), 1 when high frequency (0-66280)
    output wire [7:0] freq_out // 8-bit output representing frequency
);
    
    wire [31:0] sample_period;    // Number of clock cycles per sampling period
    reg [31:0] counter;        // Counter to measure the number of clock cycles
    reg [31:0] frequency;      // Measured frequency (not scaled)
    reg [7:0] freq_trunc; // trancated
    reg [0:0] signal_in_prev;  // Previous signal_in to detect rising edges

    assign freq_out = freq_trunc;


    // Assuming 10 MHz Clock Speed
    // 00: 100000 CC    100 Hz      10 ms
    // 01: 10000 CC     1 kHz       1 ms
    // 10: 1000 CC      10 kHz      100 us
    // 11: 100 CC       100 kHz     10 us
    // Multiply freq_out by sample rate to get frequency of input
    assign sample_period = sample_rate[1] ? (sample_rate[0] ? 32'd99 : 32'd999) 
                                          : (sample_rate[0] ? 32'd9999 : 32'd99999);


    
    // Initialize counter and sampling period on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 32'b0;
            frequency <= 32'b0;
            //freq_range <= 1'b0;
            freq_trunc <= 8'b0;
        end else begin
            // Update progression within sampling period
            counter <= counter + 1;

            // Count cycles of input signal 'signal_in'
            if (signal_in & ~signal_in_prev)    // Rising edge
                frequency <= frequency + 1;
            
            // Check if sampling period is complete
            if (counter >= sample_period) begin
                if (frequency > 255) begin
                    //freq_range <= 1;    // Set to high frequency range
                        
                    // Normalize the frequency value to fit in 8-bits, maximum of 66280
                    freq_trunc <= (frequency[15:8] > 255) ? 255 : frequency[15:8];
                end else begin
                    //freq_range <= 0;    // Set to low frequency range
                    // No need to normalize
                    freq_trunc <= frequency[7:0];
                end
                
                // Reset counter after sampling
                counter <= 32'b0;
                // Reset frequency after sampling
                frequency <= 32'b0;
            end

            // Record signal_in value
            signal_in_prev <= signal_in;
        end
    end
endmodule