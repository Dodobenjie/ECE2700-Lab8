module decoder4_16 (
    input  wire [3:0]  d,
    input  wire        en,
    output wire [15:0] o
);

    wire en_lower;
    wire en_upper;

    assign en_lower = en & ~d[3];
    assign en_upper = en &  d[3];

    decoder3_8 lower_decoder (
        .d(d[2:0]),
        .en(en_lower),
        .o(o[7:0])
    );

    decoder3_8 upper_decoder (
        .d(d[2:0]),
        .en(en_upper),
        .o(o[15:8])
    );

endmodule