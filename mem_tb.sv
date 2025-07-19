`timescale 1ns / 1ps

module mem_tb;

    reg clk;
    reg we;
    reg [7:0] we_mask;
    reg [5:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate your SRAM module here (replace with your module name if different)
    mem uut (
        .clk(clk),
        .we(we),
        .we_mask(we_mask),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to write single bit at address, bit position
    task write_bit(input [5:0] w_addr, input integer bit_pos, input bit val);
    begin
        @(negedge clk);
        we = 1'b1;
        addr = w_addr;
        data_in = val ? (1 << bit_pos) : 8'b0;
        we_mask = (1 << bit_pos);
    end
    endtask

    // Task to read and check single bit
    task read_bit_check(input [5:0] r_addr, input integer bit_pos, input bit expected);
        reg [7:0] full_byte;
        bit actual_bit;
    begin
		  @(negedge clk);
        we = 1'b0;
        addr = r_addr;
		  @(negedge clk);  // Wait 1 cycle for memory read latency
        full_byte = data_out;
        actual_bit = (full_byte >> bit_pos) & 1'b1;
        if (actual_bit !== expected) begin
            $display("March C FAIL at addr %0d bit %0d: expected %b, STUCK AT %b", r_addr, bit_pos, expected, actual_bit);
		  end
//			else begin   
//				$display("March C PASS at addr %0d bit %0d: expected %b, got %b", r_addr, bit_pos, expected, actual_bit);
//				end
   
    end
    endtask

    // Bitwise March C test task
    task march_c_bitwise;
        integer addr_i, bit_i;
    begin
        $display("Starting bitwise March C test...");

        // 1. Write 0 ascending
        for (addr_i = 0; addr_i < 64; addr_i = addr_i + 1) begin
            for (bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
                write_bit(addr_i[5:0], bit_i, 0);
					  @(negedge clk); 
            end
        end
		#2;
        // 2. Read 0, Write 1  ascending
        for (addr_i = 0; addr_i < 64; addr_i = addr_i + 1) begin
            for (bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
                read_bit_check(addr_i[5:0], bit_i, 0);
            end
        end
		   for (addr_i = 0; addr_i < 64; addr_i = addr_i + 1) begin
            for(bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
				    write_bit(addr_i[5:0], bit_i, 1);
					 @(negedge clk); 
            end
        end
		  

//		  // 2. Read 1,Write 0ascending
        for (addr_i = 0; addr_i < 64; addr_i = addr_i + 1) begin
            for (bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
                read_bit_check(addr_i[5:0], bit_i, 1);
            end
        end
		   for (addr_i = 0; addr_i < 64; addr_i = addr_i + 1) begin
            for (bit_i = 0; bit_i < 8; bit_i = bit_i + 1) begin
				    write_bit(addr_i[5:0], bit_i, 0);
					   @(negedge clk); 
            end
        end
		  
        // 3. Read 0, Write 1 descending
        for (addr_i = 63; addr_i >= 0; addr_i = addr_i - 1) begin
            for (bit_i = 7; bit_i >= 0; bit_i = bit_i - 1) begin
                read_bit_check(addr_i[5:0], bit_i, 0);
                
            end
        end
		   for (addr_i = 63; addr_i >= 0; addr_i = addr_i - 1) begin
            for (bit_i = 7; bit_i >= 0; bit_i = bit_i - 1) begin
               write_bit(addr_i[5:0], bit_i, 1);
					@(negedge clk); 
            end
        end
		  
		   // 4. Read 1, Write 0 descending
        for (addr_i = 63; addr_i >= 0; addr_i = addr_i - 1) begin
            for (bit_i = 7; bit_i >= 0; bit_i = bit_i - 1) begin
                read_bit_check(addr_i[5:0], bit_i, 1);
                
            end
        end
		   for (addr_i = 63; addr_i >= 0; addr_i = addr_i - 1) begin
            for (bit_i = 7; bit_i >= 0; bit_i = bit_i - 1) begin
               write_bit(addr_i[5:0], bit_i, 0);
					@(negedge clk); 
            end
        end
		  
		// Read 0 descending
        for (addr_i = 63; addr_i >= 0; addr_i = addr_i - 1) begin
            for (bit_i = 7; bit_i >= 0; bit_i = bit_i - 1) begin
                read_bit_check(addr_i[5:0], bit_i, 0);
            end
        end
//
//        $display("Bitwise March C test completed!");
    end
    endtask
	 
	 
	 bit prev_value;

	initial begin
		 prev_value = 0;
		 forever begin
			  @(uut.mem[15][5]); // Wait for a change
			  if (prev_value == 0 && uut.mem[15][5] == 1) begin
					// Block the 0 → 1 transition
					force uut.mem[15][5] = 1'b0;
			  end else begin
					release uut.mem[15][5]; // Allow normal operation
			  end
			  prev_value = uut.mem[15][5];
		 end
	end
		 
	 bit prev_value2;
	initial begin
		 prev_value2 = 1;
		 forever begin
			  @(uut.mem[25][5]); // Wait for a change
			  if (prev_value2 == 1 && uut.mem[25][5] == 0) begin
					// Block the 1 → 0 transition
					force uut.mem[25][5] = 1'b1;
			  end else begin
					release uut.mem[25][5]; // Allow normal operation
			  end
			  prev_value2 = uut.mem[25][5];
		 end
	end
	
	 bit prev_value3;
	
		initial begin
		 prev_value3 = 1;
		 forever begin
			  @(uut.mem[20][6]); // Wait for a change
			  if (prev_value3 == 1 && uut.mem[20][6] == 0) begin
					// Block the 1 → 0 transition
					force uut.mem[33][7] = 1'b1;
			  end else begin
					release uut.mem[33][7]; // Allow normal operation
			  end
			  prev_value3 = uut.mem[20][6];
		 end
	end

    initial begin
        // Initialize control signals
        we = 0;
        we_mask = 0;
        addr = 0;
        data_in = 0;
		  force uut.mem[60][3] = 1'b0;
		  force uut.mem[10][2] = 1'b1;

        // Run the March C test
        march_c_bitwise();

        // Finish simulation
        $stop;
    end

endmodule
