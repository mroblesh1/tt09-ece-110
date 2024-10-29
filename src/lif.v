`default_nettype none

module lif(
    input wire          clk,
    input wire          rst_n,
    input wire [7:0]    current,
    output reg [7:0]    state,
    output wire         spike
);
    
    // We are going to implement a leaky-integrate and fire neuron
    // U[t+1] = B*U[t] + I_in

    wire [7:0] next_state;
    reg [7:0] threshold;
    //reg [7:0] beta;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 200;
        end else begin
            state <= next_state;
        end
    end

    // next state logic
    assign next_state = current + (spike ? 8'b0 : (state >> 1)); // right shift for Beta = 0.5, easier than division

    // spiking logic
    assign spike = (state >= threshold);


endmodule