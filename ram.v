module ram(
	input [0:31] address,
	input [0:31] data,
	input write,
	input clk,
	output response,
	output [0:31] out
);

parameter size = 4096;
reg [0:size - 1] ram [0:31];

reg [0:31] prev_address;
reg [0:31] prev_data;
reg [0:31] prev_out;
reg prev_write;
reg prev_response;

initial 
begin
	prev_address = 0;
	prev_data = 0;
	prev_response = 0;
	prev_write = 0;
end

always @(posedge clk)
begin
	if ((prev_address != address % size) || (prev_data != data) || (prev_write != write))
	begin
		prev_address = address % size;
		prev_data = data;
		prev_write = write;
		prev_response = 1;
	end
	else
		if (prev_response) 
		begin
			if (write)
				ram[address] = data;
			else
				prev_out = ram[address];
			prev_response = 0;
		end
end

assign out = prev_out;
assign response = prev_response;

endmodule
