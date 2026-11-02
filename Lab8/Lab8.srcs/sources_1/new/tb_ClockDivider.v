`timescale 1ns / 1ps

module tb_ClockDivider;

    localparam integer TEST_PRESCALER = 3;

    reg clk;
    wire sel;

    reg expected_sel;

    integer cycle;
    integer errors;

    ClockDivider #(
        .PRESCALER(TEST_PRESCALER)
    ) dut (
        .clk(clk),
        .sel(sel)
    );

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk;

    initial begin
        errors = 0;

        #1;

        if (sel !== 1'b0) begin
            errors = errors + 1;
            $display("FAIL: divider startup state");
        end

        for (cycle = 1;
             cycle <= 24;
             cycle = cycle + 1) begin

            @(posedge clk);

            // Wait for nonblocking assignments to settle.
            #1;

            expected_sel = (cycle / TEST_PRESCALER) % 2;

            if (sel !== expected_sel) begin
                errors = errors + 1;
                $display(
                    "FAIL: cycle=%0d sel=%b expected=%b",
                    cycle, sel, expected_sel
                );
            end
        end

        if (errors == 0)
            $display("PASS: ClockDivider");
        else
            $display("FAIL: ClockDivider, errors=%0d", errors);

        $finish;
    end

endmodule