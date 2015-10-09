//---------------------------------------------------------------------------------------
// uart test bench   
//
//---------------------------------------------------------------------------------------

`include "uart_bench/timescale.v"

module test;
//---------------------------------------------------------------------------------------
// include uart tasks 
`include "uart_bench/uart_tasks.v" 

// internal signal  
reg clock, clock_fast;		// global clock 
reg reset;		// global reset 
reg [6:0] counter;

//---------------------------------------------------------------------------------------
// test bench implementation 
// global signals generation  
initial
begin
	counter = 0;
	reset = 1;
        clock = 0;
        clock_fast = 0;
	#40 reset = 0;
end 

// clock generator - 40MHz clock 
always 
begin 
    begin
        //40MHz
	#12 clock = 0;
	#13 clock = 1;
    end
end 

always
begin
    begin
        //100MHz
        #5 clock_fast = 0;
        #5 clock_fast = 1;
    end
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
        // data 'd1, addr 'd0
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
        //addr 'd 16 data 'd 1
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
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
        //read banmen
	send_serial (8'h72, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); //r
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); //sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h33, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
	#100;

	//addr 'd16 data 'd0
        send_serial (8'h77, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//w
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
	#100;
        #1000;
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
        //addr 'd 16 data 'd 1
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
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
	// transmit a read command from register file 
	// command string: "r addr(xxxx)" + CR 
	send_serial (8'h72, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); //r
	#100;
	send_serial (8'h20, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0); //sp
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h30, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//0
	#100;
	send_serial (8'h31, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h33, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//1
	#100;
	send_serial (8'h0d, `BAUD_115200, `PARITY_EVEN, `PARITY_OFF, `NSTOPS_1, `NBITS_8, 0);//<CR>
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
top top(.rst(reset), .ser_in(ser_in), .ser_out(ser_out), .calc_clk(clock_fast), .uart_clk(clock));

// serial interface to test bench 
assign ser_in = serial_out;
always @ (posedge clock) serial_in = ser_out;


endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
