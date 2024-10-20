`include "HardFloat_consts.vi"
module Adder_module_tb;

reg [(`floatControlWidth - 1):0] control;
reg [2:0] subOp;
reg [31:0] a;
reg [31:0] b;
reg [31:0] c;
reg [31:0] d;
reg [2:0] roundingMode;
wire [31:0] out;
wire [4:0] exceptionFlags;

Adder_module dut(
    .control(control),
    .subOp(subOp),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .roundingMode(roundingMode),
    .out(out),
    .exceptionFlags(exceptionFlags)
);

task check;
        input [31:0] a_in;
        input [31:0] b_in;
        input [31:0] c_in;
        input [31:0] d_in;
        input [2:0] sub_in;
        input [31:0] expected;
        begin
            subOp <= sub_in;
            a <= a_in;
            b <= b_in;
            c <= c_in;
            d <= d_in;
            #1;
            if (out !== expected) begin
                $display("Test failed for: ");
                $display("a = 0x%0h; b = 0x%0h;", a_in, b_in);
                $display("c = 0x%0h; d = 0x%0h;", c_in, d_in);
                $display("subOp = 0x%0h;", sub_in);
                $display("Result: 0x%0h; Expected: 0x%0h", out, expected);
                $display(" ");
            end else begin
                $display("Test passed; Result: 0x%0h", out);
            end
        end
    endtask


initial begin
    roundingMode <= 3'b000;
    a <= 32'h00000000;
    b <= 32'h00000000;
    c <= 32'h00000000;
    d <= 32'h00000000;
    #1;
    check(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000, 3'b000, 32'h00000000);
    check(32'h3f800000, 32'h3f800000, 32'h3f800000, 32'h3f800000, 3'b000, 32'h40800000);
    check(32'h3f800000, 32'hbf800000, 32'h3f800000, 32'h3f800000, 3'b100, 32'h40800000);
    check(32'h3f800000, 32'h3f800000, 32'h00000000, 32'h00000000, 3'b101, 32'h00000000);
    check(32'hc1200000, 32'h41200000, 32'h3f800000, 32'h3f800000, 3'b100, 32'hc1900000);
    $finish;
end

endmodule