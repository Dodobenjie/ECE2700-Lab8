`timescale 1ns / 1ps

module tb_DoubleSevenSegment;

    localparam integer TEST_PRESCALER = 3;

    reg        CLK;
    reg  [7:0] SW;

    wire [6:0] SEG;
    wire [3:0] AN;
    wire       DP;

    reg        expected_sel;
    reg  [3:0] expected_digit;
    reg  [3:0] expected_anodes;

    wire [6:0] expected_seg_high;

    integer cycle;
    integer errors;
    integer value;

    DoubleSevenSegment #(
        .PRESCALER(TEST_PRESCALER)
    ) dut (
        .CLK(CLK),
        .SW(SW),
        .SEG(SEG),
        .AN(AN),
        .DP(DP)
    );

    SevenSegmentReference reference_decoder (
        .d(expected_digit),
        .seg(expected_seg_high)
    );

    initial begin
        CLK = 1'b0;
    end

    always #5 CLK = ~CLK;

    task check_cycle;
        begin
            @(posedge CLK);

            cycle = cycle + 1;

            // Independently predict divider state.
            expected_sel = (cycle / TEST_PRESCALER) % 2;

            expected_digit =
                expected_sel ? SW[7:4] : SW[3:0];

            expected_anodes =
                expected_sel ? 4'b1101 : 4'b1110;

            // Allow DUT and reference outputs to settle.
            #1;

            if (AN !== expected_anodes) begin
                errors = errors + 1;
                $display(
                    "FAIL AN: cycle=%0d AN=%b expected=%b",
                    cycle, AN, expected_anodes
                );
            end

            if (SEG !== (~expected_seg_high)) begin
                errors = errors + 1;
                $display(
                    "FAIL SEG: cycle=%0d SW=%h digit=%h SEG=%b expected=%b",
                    cycle, SW, expected_digit,
                    SEG, ~expected_seg_high
                );
            end

            if (DP !== 1'b1) begin
                errors = errors + 1;
                $display("FAIL: decimal point must remain OFF");
            end
        end
    endtask

    task test_switches;
        input [7:0] test_value;
        integer k;

        begin
            // Change switches away from the active clock edge.
            @(negedge CLK);
            SW = test_value;

            // Two complete select periods.
            for (k = 0;
                 k < 4 * TEST_PRESCALER;
                 k = k + 1) begin

                check_cycle;
            end
        end
    endtask

    initial begin
        SW = 8'hA3;

        expected_sel = 0;
        expected_digit = 4'h3;
        expected_anodes = 4'b1110;

        cycle = 0;
        errors = 0;

        // Initial pair: A and 3.
        repeat (12) begin
            check_cycle;
        end

        // Test 0-F on the lower nibble, upper nibble fixed at A.
        for (value = 0;
             value < 16;
             value = value + 1) begin

            test_switches({4'hA, value[3:0]});
        end

        // Test 0-F on the upper nibble, lower nibble fixed at 5.
        for (value = 0;
             value < 16;
             value = value + 1) begin

            test_switches({value[3:0], 4'h5});
        end

        if (errors == 0)
            $display("PASS: DoubleSevenSegment");
        else
            $display("FAIL: DoubleSevenSegment, errors=%0d", errors);

        $finish;
    end

endmodule