module DecodedSevenSegment (
    input  wire [3:0] d,
    output wire [6:0] seg
);

    localparam [15:0] MASK_A = 16'hB7EB;
    localparam [15:0] MASK_B = 16'hF9E4;
    localparam [15:0] MASK_C = 16'hDFF4;
    localparam [15:0] MASK_D = 16'hB6DE;
    localparam [15:0] MASK_E = 16'hA2BF;
    localparam [15:0] MASK_F = 16'h8EFB;
    localparam [15:0] MASK_G = 16'h3EF7;

    wire [15:0] decoded;
    wire [15:0] rows_for_masks;

    decoder4_16 decoder (
        .d(d),
        .en(1'b1),
        .o(decoded)
    );

    // Reverse decoder ordering to match the pre-lab masks:
    // input 0  -> rows_for_masks[15]
    // input 15 -> rows_for_masks[0]
    genvar k;

    generate
        for (k = 0; k < 16; k = k + 1) begin : reverse_rows
            assign rows_for_masks[15-k] = decoded[k];
        end
    endgenerate

    // Active-high internally: 1 means segment ON.
    assign seg[0] = |(rows_for_masks & MASK_A);
    assign seg[1] = |(rows_for_masks & MASK_B);
    assign seg[2] = |(rows_for_masks & MASK_C);
    assign seg[3] = |(rows_for_masks & MASK_D);
    assign seg[4] = |(rows_for_masks & MASK_E);
    assign seg[5] = |(rows_for_masks & MASK_F);
    assign seg[6] = |(rows_for_masks & MASK_G);

endmodule