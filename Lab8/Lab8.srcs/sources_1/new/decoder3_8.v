module decoder3_8 (
    input  wire [2:0] d,
    input  wire       en,
    output wire [7:0] o
);

    assign o = en ? (8'b00000001 << d) : 8'b00000000;

endmodule