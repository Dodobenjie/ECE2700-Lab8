module ClockDivider #(
    parameter integer PRESCALER = 50000
) (
    input  wire clk,
    output reg  sel
);

    // At least one counter bit, including PRESCALER = 1.
    localparam integer COUNTER_WIDTH =
        (PRESCALER <= 1) ? 1 : $clog2(PRESCALER);

    reg [COUNTER_WIDTH-1:0] count;

    initial begin
        count = 0;
        sel = 1'b0;
    end

    always @(posedge clk) begin
        if (count == PRESCALER - 1) begin
            count <= 0;
            sel <= ~sel;
        end
        else begin
            count <= count + 1'b1;
        end
    end

endmodule