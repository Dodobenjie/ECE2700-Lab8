`timescale 1ns / 1ps

module tb_mux2_1;

    reg  [1:0] i;
    reg        sel;
    wire       o;

    reg expected;

    integer combination;
    integer errors;

    mux2_1 dut (
        .i(i),
        .sel(sel),
        .o(o)
    );

    initial begin
        i = 0;
        sel = 0;
        errors = 0;

        for (combination = 0;
             combination < 8;
             combination = combination + 1) begin

            {sel, i} = combination;

            expected = sel ? i[1] : i[0];

            #10;

            if (o !== expected) begin
                errors = errors + 1;
                $display(
                    "FAIL: sel=%b i=%b o=%b expected=%b",
                    sel, i, o, expected
                );
            end
        end

        if (errors == 0)
            $display("PASS: mux2_1");
        else
            $display("FAIL: mux2_1, errors=%0d", errors);

        $finish;
    end

endmodule
