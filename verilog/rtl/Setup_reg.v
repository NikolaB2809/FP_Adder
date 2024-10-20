module Setup_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    output reg [7:0] parallel_out);


always @(posedge(clk_in) or posedge(en_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 8'b0;
    end else begin
        if (en_in == 1'b1) begin
            parallel_out[0] = parallel_out[1];
            parallel_out[1] = parallel_out[2];
            parallel_out[2] = parallel_out[3];
            parallel_out[3] = parallel_out[4];
            parallel_out[4] = parallel_out[5];
            parallel_out[5] = parallel_out[6];
            parallel_out[6] = parallel_out[7];
            parallel_out[7] = serial_in;
        end
    end
end

endmodule