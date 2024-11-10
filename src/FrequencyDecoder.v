module FrequencyDecoder (
    input wire clk,                // System clock
    input wire reset,              // Reset signal
    input wire signal_in,          // 1-bit frequency input signal
    output reg [7:0] freq_out // 8-bit output representing frequency
);
    
    reg [31:0] counter;        // Counter to measure the number of clock cycles
    reg [31:0] sample_rate;    // Number of clock cycles per sampling period
    reg [31:0] frequency;      // Measured frequency (not scaled)
    
    // Initialize counter and sampling period on reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 32'b0;
            sample_rate <= 32'd100; // Set sample window size, adjust based on desired precision
            frequency <= 32'b0;
            freq_out <= 8'b0;
        end else begin
            // Update progression within sampling period
            counter <= counter + 1;

            // Count cycles of input signal 'signal_in'
            if (signal_in)
                frequency <= frequency + 1;
            
            // Check if sampling period is complete
            if (counter >= sample_rate) begin
                // Normalize the frequency value to fit in 8-bits
                // This depends on your expected frequency range and sample_rate
                freq_out <= (frequency > 255) ? 255 : frequency[7:0];
                
                // Reset counter after sampling
                counter <= 32'b0;
                // Reset frequency after sampling
                frequency <= 32'b0;
            end
        end
    end
endmodule