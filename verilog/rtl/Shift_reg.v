module Shift_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input wr_in,
    output reg input_rdy,
    output reg [31:0] parallel_out
);

reg [5:0] count;
integer i;

always @(posedge(clk_in) or rst_in) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 32'b0;
        input_rdy <= 1'b1;
        count <= 5'b0;
    end else begin
        if (count > 31) begin
            input_rdy <= 1'b1;
            count <= 5'b0;
        end else if (wr_in == 1'b1) begin
            input_rdy <= 1'b0;
            for (i = 31; i > 0; i = i - 1) begin
                parallel_out[i - 1] <= parallel_out[i];
            end
            parallel_out[31] <= serial_in;
            count = count + 1;
        end
    end
end

endmodule;