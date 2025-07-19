module mem(
    input wire clk,
    input wire we,                // Global write enable
    input wire [7:0] we_mask,    // Bit-wise write enable mask
    input wire [5:0] addr,        // Address (6-bit for 64 locations)
    input wire [7:0] data_in,     // Data input for write
    output reg [7:0] data_out     // Data output for read
);

    reg [7:0] mem [0:63];
    integer i;

always @(posedge clk) begin
    reg [7:0] temp;

    temp = mem[addr]; // Read current contents

    if (we) begin
        for (i = 0; i < 8; i = i + 1) begin
            if (we_mask[i])
                temp[i] = data_in[i];
        end
        mem[addr] <= temp;
    end

    data_out <= mem[addr]; // <-- Always update data_out, even during write
end



endmodule
