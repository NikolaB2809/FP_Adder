module Delay_module(
    input in,
    input clk_in,
    input rst_in,
    output reg out
);

reg [5:0] count;
reg start;

always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        count <= 6'b0;
        start <= 1'b0;
        out <= 1'b0;
    end else begin
        if (start == 1'b0) begin 
            out <= 1'b0;
        end
        if (in == 1'b1 & start == 1'b0) begin
            start = 1'b1;
            out <= 1'b0;
        end else if (start == 1'b1) begin
            if (count > 31) begin
                out <= 1'b1;
                start <= 1'b0;
                count <= 6'b0;
            end else begin
                out <= 1'b0;
                count = count + 1;
            end
        end
    end
end

endmodule