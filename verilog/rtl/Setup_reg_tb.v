module Setup_reg_tb;

reg serial_in;
reg clk_in;
reg rst_in;
reg en_in;
wire [7:0] parallel_out;

Setup_reg dut(
    .serial_in(serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .en_in(en_in),
    .parallel_out(parallel_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
        input [7:0] in;  // Inputs to apply
        input [7:0] expected;  // Expected result
        begin
            // Apply stimulus
            serial_in = in[0];
            #10;
            serial_in = in[1];
            #10;
            serial_in = in[2];
            #10;
            serial_in = in[3];
            #10;
            serial_in = in[4];
            #10;
            serial_in = in[5];
            #10;
            serial_in = in[6];
            #10;
            serial_in = in[7];
            #10;
            // Compare expected and actual output
            if (parallel_out !== expected) begin
                $display("Test failed for in = 0x%0h: expected: 0x%0h, got: 0x%0h", in, expected, parallel_out);
            end else begin
                $display("Test passed for in = 0x%0h; Result: 0x%0h", in, parallel_out);
            end
        end
    endtask

initial begin
    serial_in = 0;
    clk_in = 0;
    en_in = 0;
    rst_in = 1;
    #10;
    rst_in = 0;
    en_in = 1;
    check(8'b00000000, 8'b00000000);
    check(8'b10101010, 8'b10101010);
    check(8'b11111111, 8'b11111111);
    check(8'b11110000, 8'b11110000);
    check(8'b00001111, 8'b00001111);
    $finish;
end

endmodule