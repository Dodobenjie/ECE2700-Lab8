module DoubleSevenSegment #(
    parameter integer PRESCALER = 50000
) (
    input  wire       CLK,
    input  wire [7:0] SW,

    output wire [6:0] SEG,
    output wire [3:0] AN,
    output wire       DP
);

    wire       sel;
    wire [3:0] selected_digit;
    wire [6:0] seg_active_high;

    ClockDivider #(
        .PRESCALER(PRESCALER)
    ) divider (
        .clk(CLK),
        .sel(sel)
    );

    MUXarray #(
        .SIZE(4)
    ) digit_mux (
        .a(SW[3:0]),
        .b(SW[7:4]),
        .sel(sel),
        .o(selected_digit)
    );

    DecodedSevenSegment segment_decoder (
        .d(selected_digit),
        .seg(seg_active_high)
    );

    // Basys 3 segment outputs are active-low.
    assign SEG = ~seg_active_high;

    // sel = 0: show SW[3:0] on digit 0.
    // sel = 1: show SW[7:4] on digit 1.
    assign AN[0] =  sel;
    assign AN[1] = ~sel;

    // Unused digits OFF.
    assign AN[3:2] = 2'b11;

    // Decimal point OFF.
    assign DP = 1'b1;

endmodule