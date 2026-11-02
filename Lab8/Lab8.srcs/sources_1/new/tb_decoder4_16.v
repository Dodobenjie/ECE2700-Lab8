`timescale 1ns / 1ps

module tb_decoder4_16;

    reg  [3:0]  d;
    reg         en;
    wire [15:0] o;

    reg [15:0] expected;

    integer enable_value;
    integer address;
    integer errors;

    decoder4_16 dut (
        .d(d),
        .en(en),
        .o(o)
    );

    initial begin
        d = 0;
        en = 0;
        errors = 0;

        for (enable_value = 0;
             enable_value < 2;
             enable_value = enable_value + 1) begin

            for (address = 0;
                 address < 16;
                 address = address + 1) begin

                en = enable_value;
                d = address;

                expected = en ? (16'b1 << d) : 16'b0;

                #10;

                if (o !== expected) begin
                    errors = errors + 1;
                    $display(
                        "FAIL: en=%b d=%h o=%h expected=%h",
                        en, d, o, expected
                    );
                end
            end
        end

        if (errors == 0)
            $display("PASS: decoder4_16");
        else
            $display("FAIL: decoder4_16, errors=%0d", errors);

        $finish;
    end

endmodule
