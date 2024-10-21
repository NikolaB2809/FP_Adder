module Shift_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    input wr_in,
    output reg input_rdy,
    output reg [31:0] parallel_out
);

reg [5:0] count;
reg [31:0] value;
integer i;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 32'b0;
        input_rdy <= 1'b1;
        count <= 5'b0;
        value <= 32'h00000000;
    end else begin
        if (count > 31) begin
            input_rdy <= 1'b1;
            count <= 5'b0;
        end else if (wr_in == 1'b1) begin
            input_rdy <= 1'b0;
            for (i = 31; i > 0; i = i - 1) begin
                value[i - 1] <= value[i];
            end
            value[31] <= serial_in;
            count <= count + 1;
        end
        if (en_in == 1'b1) begin
            parallel_out <= value;
        end else begin
            parallel_out <= 32'h00000000;
        end
    end
end

endmodule;