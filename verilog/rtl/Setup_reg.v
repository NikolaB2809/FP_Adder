module Setup_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    output reg [7:0] parallel_out
);

integer i;


always @(posedge(clk_in) or posedge(en_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 8'b0;
        i = 0;
    end else begin
        if (en_in == 1'b1) begin
            if (i > 24) begin
                parallel_out[i - 25] <= serial_in;
            end 
            if (i < 32) begin
                i = i + 1;
            end else begin
                i = 0;
            end
        end
    end
end

endmodule