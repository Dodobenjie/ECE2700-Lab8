module mux2_1 (
    input  wire [1:0] i,
    input  wire       sel,
    output wire       o
);

    assign o = sel ? i[1] : i[0];

endmodule

