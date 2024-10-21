module Shift_reg_tb;

reg serial_in;
reg clk_in;
reg rst_in;
reg wr_in;
wire input_rdy;
wire [31:0] parallel_out;

integer i;

Shift_reg dut(
    .serial_in(serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .wr_in(wr_in),
    .input_rdy(input_rdy),
    .parallel_out(parallel_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [31:0] in;  // Inputs to apply
        input [31:0] expected;  // Expected result
        begin
            wr_in <= 1'b1;
            for(i = 0; i < 32; i = i + 1) begin
                serial_in = in[i];
                if (input_rdy == 1'b1 && i > 0) begin
                    $display("Test failed for in = 0x%0h: input_rdy = %d; expected: 0; iteration: %d", in, input_rdy, i);
                end
                #10;
            end
            wr_in <= 1'b0;
            #10;
            if (parallel_out !== expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, parallel_out);
            end else begin
                $display("Test passed for in = 0x%0h; Result: 0x%0h", in, parallel_out);
            end
            if (input_rdy == 0) begin
                $display("Test failed for in = 0x%0h: input_rdy = %d; expected: 1;", in, input_rdy);
            end
        end
    endtask

initial begin
    serial_in = 1'b0;
    clk_in = 1'b0;
    rst_in = 1'b1;
    wr_in = 1'b0;
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