//---------------------------------------------------------------------------------------
// uart test bench   
//
//---------------------------------------------------------------------------------------

`include "timescale.v"

module test;
//---------------------------------------------------------------------------------------
// include uart tasks 
`include "uart_tasks.v" 

// internal signal  
reg clock;		// global clock 
reg reset;		// global reset 
reg [6:0] counter;

//---------------------------------------------------------------------------------------
// test bench implementation 
// global signals generation  
initial
begin
	counter = 0;
	reset = 1;
	#40 reset = 0;
end 

// clock generator - 40MHz clock 
always 
begin 
	#12 clock = 0;
	#13 clock = 1;
end 

// test bench dump variables 
initial 
begin 
	$dumpfile("test.vcd");
	//$dumpall;
	$dumpvars(0, test);
end 

//------------------------------------------------------------------
// test bench transmitter and receiver 
// uart transmit - test bench control 

initial 
begin 
	// defualt value of serial output 
	serial_out = 1;

	// transmit a write command to internal register file 
	// command string: "w data(xx) addr(xxxx)" + CR 
	send_serial (8'h77, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//w
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
	#100;
	send_serial (8'h77, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//w
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h36, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//6
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
	#100;
        #10000000
	// transmit a read command from register file 
	// command string: "r 1a" + CR 
	send_serial (8'h72, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); 
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);
	#100;
	send_serial (8'h61, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);
	#100;

	// delay and finish 
	#900000;
	$finish;
end 

// uart receive 
initial 
begin 
	// default value for serial receiver and serial input 
	serial_in = 1;
	get_serial_data = 0;		// data received from get_serial task 
	get_serial_status = 0;		// status of get_serial task  
end 

// serial sniffer loop 
always 
begin 
	// call serial sniffer 
	get_serial(`BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8);
	
	// check serial receiver status 
	// byte received OK 
	if (get_serial_status & `RECEIVE_RESULT_OK)
	begin
		// check if not a control character (above and including space ascii code)
		if (get_serial_data >= 8'h20) 
			$display("received byte 0x%h (\"%c\") at %t ns", get_serial_data, get_serial_data, $time);
		else 
			$display("received byte 0x%h (\"%c\") at %t ns", get_serial_data, 8'hb0, $time);
	end 
	
	// false start error 
	if (get_serial_status & `RECEIVE_RESULT_FALSESTART)
		$display("Error (get_char): false start condition at %t", $realtime);

	// bad parity error 		
	if (get_serial_status & `RECEIVE_RESULT_BADPARITY)
		$display("Error (get_char): bad parity condition at %t", $realtime);

	// bad stop bits sequence 	
	if (get_serial_status & `RECEIVE_RESULT_BADSTOP)
		$display("Error (get_char): bad stop bits sequence at %t", $realtime);
end 

//------------------------------------------------------------------
// device under test 
// DUT interface 
wire ser_in, ser_out;
// DUT instance 
top top(.clk(clock), .rst(reset), .ser_in(ser_in), .ser_out(ser_out));

// serial interface to test bench 
assign ser_in = serial_out;
always @ (posedge clock) serial_in = ser_out;


endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
