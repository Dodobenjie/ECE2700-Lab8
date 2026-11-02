`timescale 1ns / 1ps

module tb_decoder3_8;

    reg  [2:0] d;
    reg        en;
    wire [7:0] o;

    reg [7:0] expected;

    integer enable_value;
    integer address;
    integer errors;

    decoder3_8 dut (
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
                 address < 8;
                 address = address + 1) begin

                en = enable_value;
                d = address;

                expected = en ? (8'b00000001 << d) : 8'b0;

                #10;

                if (o !== expected) begin
                    errors = errors + 1;
                    $display(
                        "FAIL: en=%b d=%d o=%b expected=%b",
                        en, d, o, expected
                    );
                end
            end
        end

        if (errors == 0)
            $display("PASS: decoder3_8");
        else
            $display("FAIL: decoder3_8, errors=%0d", errors);

        $finish;
    end

endmodule