module FP_Adder_tb;

reg serial1_in;
reg serial2_in;
reg serial3_in;
reg serial4_in;
reg wr_in;
reg setup_serial_in;
reg clk_in;
reg rst_in;
reg output_clk_in;
reg output_read_in;
wire input_rdy;
wire output_rdy;
wire serial_out;

integer i;
reg [31:0] result;

FP_Adder dut(
    .serial1_in(serial1_in),
    .serial2_in(serial2_in),
    .serial3_in(serial3_in),
    .serial4_in(serial4_in),
    .wr_in(wr_in),
    .setup_serial_in(setup_serial_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .output_clk_in(output_clk_in),
    .output_read_in(output_read_in),
    .input_rdy(input_rdy),
    .output_rdy(output_rdy),
    .serial_out(serial_out)
);

always begin
    clk_in = ~clk_in; #5;
end

task check;
    input [31:0] a_in;
    input [31:0] b_in;
    input [31:0] c_in;
    input [31:0] d_in;
    input [7:0] setup_in;
    input [31:0] expected;  // Expected result
    begin
        wr_in <= 1'b1;
        setup_serial_in <= 1'b0;
        result <= 32'h00000000;
        for (i = 0; i < 32; i = i + 1) begin
            serial1_in <= d_in[i];
            serial2_in <= c_in[i];
            serial3_in <= b_in[i];
            serial4_in <= a_in[i];
            if (i > 23) begin
                setup_serial_in <= setup_in[i - 24];
            end
            #10;
        end
        wr_in <= 1'b0;
        setup_serial_in <= 1'b0;
        #30;
        output_read_in <= 1'b1;
        #10;
        for (i = 0; i < 32; i = i + 1) begin
            result[i] <= serial_out;
            #10;
        end
        output_read_in <= 1'b0;
        #10;
        $display("Time: %0t", $time);
        if (result !== expected) begin
            $display("Test failed for: ");
            $display("a = 0x%0h; b = 0x%0h;", a_in, b_in);
            $display("c = 0x%0h; d = 0x%0h;", c_in, d_in);
            $display("Setup = 0x%0h;", setup_in);
            $display("Result: 0x%0h; Expected: 0x%0h", result, expected);
            $display(" ");
        end else begin
            $display("Test successful; Result: 0x%0h", result);
            $display(" ");
        end
    end
endtask

initial begin
    $dumpfile("FP_Adder_tb.vcd");  // Specify VCD file name
    $dumpvars(0, FP_Adder_tb);     // Dump all variables in the module
    serial1_in <= 1'b0;
    serial2_in <= 1'b0;
    serial3_in <= 1'b0;
    serial4_in <= 1'b0;
    wr_in <= 1'b0;
    setup_serial_in <= 1'b0;
    clk_in <= 1'b0;
    rst_in <= 1'b1;
    output_clk_in <= 1'b0;
    output_read_in <= 1'b0;
    #10;
    rst_in <= 1'b0;
    #10;
    check(32'h3f800000, 32'h3f800000, 32'h3f800000, 32'h3f800000, 8'b00011110, 32'h40800000);
    check(32'hbf800001, 32'h00000000, 32'h00000000, 32'h00000000, 8'b00011110, 32'hbf800001);
    check(32'hbf800000, 32'hbf800000, 32'hbf800000, 32'hbf800000, 8'b00011110, 32'hc0800000);
    check(32'h3f800000, 32'h3f800000, 32'h3f800000, 32'h3f800000, 8'b00011000, 32'h40000000);
    check(32'hc1200000, 32'hc1200000, 32'hc1200000, 32'hc1200000, 8'b10111110, 32'h00000000);
    check(32'h42810000, 32'h42010000, 32'h41020000, 32'h00000000, 8'b01011110, 32'h42b14000);
    $finish;
end


endmodule