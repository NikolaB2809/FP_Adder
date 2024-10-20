module Output_reg_tb;

reg [31:0] parallel_in;
reg clk_in;
reg rst_in;
reg wr_in;
reg output_read_in;
wire output_rdy;
wire input_rdy;
wire serial_out;

reg [31:0] result;
integer i;

Output_reg dut(
    .parallel_in(parallel_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .wr_in(wr_in),
    .output_read_in(output_read_in),
    .output_rdy(output_rdy),
    .input_rdy(input_rdy),
    .serial_out(serial_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [31:0] in;  // Inputs to apply
        input [31:0] expected;  // Expected result
        begin
            wr_in <= 1'b1;
            parallel_in <= in;
            if (input_rdy == 1'b0) begin
                $display("Test failed for in = 0x%0h: input_rdy = 0x%0b; expected: 1", in, input_rdy);
            end
            if (output_rdy == 1'b1) begin
                $display("Test failed for in = 0x%0h: output_rdy = 0x%0b; expected: 0", in, output_rdy);
            end
            #10;
            wr_in <= 1'b0;
            output_read_in <= 1'b1;
            #10;
            for (i = 0; i < 32; i = i + 1) begin
                result[i] <= serial_out;
                if (output_rdy == 1'b0 && i < 31) begin
                    $display("Test failed for in = 0x%0h; output_rdy = 0x%0h; expected: 1; iteration: %d", in, output_rdy, i);
                end
                #10;
            end
            output_read_in <= 1'b0;
            if (result !== expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, result);
            end else begin
                $display("Test passed for in = 0x%0h; Result: 0x%0h", in, result);
            end
        end
    endtask

initial begin
    parallel_in = 32'h00000000;
    clk_in = 1'b0;
    rst_in = 1'b1;
    wr_in = 1'b0;
    output_read_in = 1'b0;
    #10;
    rst_in = 0;
    #10;
    check(32'h00000000, 32'h00000000);
    check(32'haaaaaaaa, 32'haaaaaaaa);
    check(32'habcd1110, 32'habcd1110);
    check(32'hf89123de, 32'hf89123de);
    $finish;
end

endmodule