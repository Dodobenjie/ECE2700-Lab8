`timescale 1ns / 1ps

module tb_MUXarray;

    reg  [3:0] a4;
    reg  [3:0] b4;
    reg        sel4;
    wire [3:0] o4;

    reg  [7:0] a8;
    reg  [7:0] b8;
    reg        sel8;
    wire [7:0] o8;

    integer av;
    integer bv;
    integer sv;
    integer errors;

    // Default SIZE = 4.
    MUXarray dut4 (
        .a(a4),
        .b(b4),
        .sel(sel4),
        .o(o4)
    );

    // Parameter override: SIZE = 8.
    MUXarray #(
        .SIZE(8)
    ) dut8 (
        .a(a8),
        .b(b8),
        .sel(sel8),
        .o(o8)
    );

    task check8;
        input [7:0] test_a;
        input [7:0] test_b;

        integer s;
        reg [7:0] expected;

        begin
            a8 = test_a;
            b8 = test_b;

            for (s = 0; s < 2; s = s + 1) begin
                sel8 = s;
                expected = sel8 ? b8 : a8;

                #10;

                if (o8 !== expected) begin
                    errors = errors + 1;
                    $display(
                        "FAIL SIZE=8: a=%h b=%h sel=%b o=%h expected=%h",
                        a8, b8, sel8, o8, expected
                    );
                end
            end
        end
    endtask

    initial begin
        a4 = 0;
        b4 = 0;
        sel4 = 0;

        a8 = 0;
        b8 = 0;
        sel8 = 0;

        errors = 0;

        for (av = 0; av < 16; av = av + 1) begin
            for (bv = 0; bv < 16; bv = bv + 1) begin
                for (sv = 0; sv < 2; sv = sv + 1) begin

                    a4 = av;
                    b4 = bv;
                    sel4 = sv;

                    #10;

                    if (o4 !== (sel4 ? b4 : a4)) begin
                        errors = errors + 1;
                        $display(
                            "FAIL SIZE=4: a=%h b=%h sel=%b o=%h",
                            a4, b4, sel4, o4
                        );
                    end
                end
            end
        end

        check8(8'h00, 8'hFF);
        check8(8'hAA, 8'h55);
        check8(8'h12, 8'hE7);
        check8(8'h80, 8'h01);
        check8(8'hFF, 8'h00);

        if (errors == 0)
            $display("PASS: MUXarray, SIZE=4 and SIZE=8");
        else
            $display("FAIL: MUXarray, errors=%0d", errors);

        $finish;
    end

endmodule