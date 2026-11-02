`timescale 1ns / 1ps

module tb_DecodedSevenSegment;

    reg  [3:0] d;

    wire [6:0] seg_new;
    wire [6:0] seg_reference;

    wire [6:0] difference;
    wire       not_the_same;

    integer address;
    integer errors;

    DecodedSevenSegment dut (
        .d(d),
        .seg(seg_new)
    );

    SevenSegmentReference reference_decoder (
        .d(d),
        .seg(seg_reference)
    );

    assign difference = seg_new ^ seg_reference;
    assign not_the_same = |difference;

    initial begin
        d = 0;
        errors = 0;

        for (address = 0;
             address < 16;
             address = address + 1) begin

            d = address;
            #10;

            // !== also catches X or Z results.
            if (not_the_same !== 1'b0) begin
                errors = errors + 1;

                $display(
                    "FAIL: d=%h new=%b reference=%b",
                    d, seg_new, seg_reference
                );
            end
            else begin
                $display(
                    "MATCH: d=%h seg=%b",
                    d, seg_new
                );
            end
        end

        if (errors == 0)
            $display("PASS: all 16 seven-segment inputs match");
        else
            $display("FAIL: seven-segment decoder, errors=%0d", errors);

        $finish;
    end

endmodule
