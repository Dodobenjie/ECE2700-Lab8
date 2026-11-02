module MUXarray #(
    parameter SIZE = 4
) (
    input  wire [SIZE-1:0] a,
    input  wire [SIZE-1:0] b,
    input  wire            sel,
    output wire [SIZE-1:0] o
);

    genvar k;

    generate
        for (k = 0; k < SIZE; k = k + 1) begin : mux_bits

            mux2_1 bit_mux (
                .i({b[k], a[k]}),
                .sel(sel),
                .o(o[k])
            );

        end
    endgenerate

endmodule