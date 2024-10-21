// This module is an output register which has a parallel input and serial output
module Output_reg(
    input [31:0] parallel_in,  // Parallel input for data
    input clk_in,              // Clock input
    input rst_in,              // Reset input (active high)
    input wr_in,               // Write enable signal - used to write into the register
    input output_read_in,      // Output read signal - used to read from the register serially
    output reg output_rdy,     // Output ready signal - used to signal that the register can be read from
    output reg input_rdy,      // Input ready signal - used to signal that data can be written into the register
    output reg serial_out      // Serial output
);

reg [5:0] count;
reg [31:0] value;
integer i;

always @(posedge(clk_in) or rst_in) begin
    if (rst_in == 1'b1) begin
        serial_out <= 1'b0;
        count <= 6'b0;
        value <= 32'b0;
        input_rdy <= 1'b1;
        output_rdy <= 1'b0;
    end else begin
        if (wr_in == 1'b1 && input_rdy == 1'b1) begin
            value <= parallel_in;
            input_rdy <= 1'b0;
            output_rdy <= 1'b1;
            serial_out <= 1'b0;
        end else begin
            if (output_rdy == 1'b1) begin
                if (output_read_in == 1'b1) begin
                    if (count < 32) begin
                        serial_out <= value[0];
                        for (i = 0; i < 31; i = i + 1) begin
                            value[i] <= value[i + 1];
                        end
                        value[31] <= 1'b0;
                        count = count + 1;
                    end
                end
            end
            if (count > 31) begin
                output_rdy <= 1'b0;
                input_rdy <= 1'b1;
                count <= 6'b0;
            end
        end
    end
end

endmodule;