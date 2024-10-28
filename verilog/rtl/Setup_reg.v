module Setup_reg(
    input serial_in,
    input clk_in,
    input rst_in,
    input en_in,
    output reg [7:0] parallel_out
);

reg [5:0] count;


always @(posedge(clk_in) or posedge(rst_in)) begin
    if (rst_in == 1'b1) begin
        parallel_out <= 8'b00000000;
        count <= 6'b000000;
    end else begin
        if (en_in == 1'b1) begin
            if (count > 23) begin
                parallel_out[count - 24] <= serial_in;
            end 
            if (count < 32) begin
                count <= count + 1;
            end
        end else if (count > 31) begin
            count <= 6'b000000;
        end
    end
end

endmodule