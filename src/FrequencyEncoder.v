module FrequencyEncoder(
    input [7:0] in_bus,    // 8-bit input bus
    input clk,              // System clock
    input wire reset,              // Reset signal
    output reg out         // 1-bit frequency output
);

    reg [15:0] counter;    // Counter for clock division (larger value for lower frequencies)
    reg [15:0] divide_value; // Division factor based on input bus

    // Update the divide_value on every clock cycle based on the input bus
    always @(posedge clk) begin
        if (reset) begin
            divide_value <= 0;
        end else begin
            divide_value <= 16'h00FF - {8'h00, in_bus};  // Lower input value corresponds to longer period (lower frequency)
        end
    end

    // Clock division and output toggling logic
    always @(posedge clk) begin
        // Increment the counter
        if (reset) begin
            counter <= 0;
            out <= 0;
        end else if (counter >= divide_value) begin
            counter <= 16'd0;    // Reset the counter when it exceeds the divide_value
            out <= ~out;         // Toggle the output signal
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end

endmodule
