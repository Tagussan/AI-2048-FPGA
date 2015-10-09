module top(clk, rst, ser_in, ser_out, calc_clk, uart_clk);
input clk, rst, ser_in;
output ser_out;
wire [15:0] int_address;
wire [7:0] int_wr_data, int_rd_data;
wire int_write, int_read;
wire int_req, int_gnt;
wire calc_clk, uart_clk;
//.c0 calc_clk = 100MHz, .c1 uart_clk = 40MHz
//clk_src clk_src(.areset(rst), .inclk0(clk), .c0(calc_clk), .c1(uart_clk));
uart2bus_top uart(.clock(calc_clk), .reset(rst), .ser_in(ser_in), .ser_out(ser_out), .int_address(int_address), .int_wr_data(int_wr_data), .int_write(int_write), .int_read(int_read), .int_rd_data(int_rd_data), .int_req(int_req), .int_gnt(1'b1));
virtualBusControler cntr(.clk(uart_clk), .rst(rst), .int_address(int_address), .int_wr_data(int_wr_data), .int_write(int_write), .int_read(int_read), .int_rd_data(int_rd_data), .int_req(int_req), .int_gnt(int_gnt));
endmodule

module virtualBusControler(.clk(clk), .rst(rst), int_address, int_wr_data, int_write, int_read, int_rd_data, int_req, int_gnt);
input clk, rst;
input [5:0] int_address;
input [7:0] int_wr_data;
input int_write, int_read;
output [7:0] int_rd_data;
input int_req;
output int_gnt;
reg [5:0] grid [0:15];
reg [7:0] seed;
reg [7:0] int_rd_data;
reg monte_rst;
//reg [7:0] max_move_count[0:1];
//reg [7:0] total_move_count[0:3];
//reg [7:0] total_trial_count[0:3];
wire [15:0] max_move_count0, max_move_count1, max_move_count2, max_move_count3;
wire [31:0] total_move_count0, total_move_count1, total_move_count2, total_move_count3;
wire [31:0] total_trial_count0, total_trial_count1, total_trial_count2, total_trial_count3;
wire [79:0] initial_board;
assign initial_board = {grid[15], grid[14], grid[13], grid[12], grid[11], grid[10], grid[9], grid[8], grid[7], grid[6], grid[5], grid[4], grid[3], grid[2], grid[1], grid[0]};

monteCarloStat monte0(.clk(clk), .rst(monte_rst), .restrected(2'd0), .restrect_prob(3'd1), .max_move_count(max_move_count0), .total_move_count(total_move_count0), .total_trial_count(total_trial_count0), .initial_board(initial_board), .seed(seed));
monteCarloStat monte1(.clk(clk), .rst(monte_rst), .restrected(2'd1), .restrect_prob(3'd1), .max_move_count(max_move_count1), .total_move_count(total_move_count1), .total_trial_count(total_trial_count1), .initial_board(initial_board), .seed(seed));
monteCarloStat monte2(.clk(clk), .rst(monte_rst), .restrected(2'd2), .restrect_prob(3'd1), .max_move_count(max_move_count2), .total_move_count(total_move_count2), .total_trial_count(total_trial_count2), .initial_board(initial_board), .seed(seed));
monteCarloStat monte3(.clk(clk), .rst(monte_rst), .restrected(2'd3), .restrect_prob(3'd1), .max_move_count(max_move_count3), .total_move_count(total_move_count3), .total_trial_count(total_trial_count3), .initial_board(initial_board), .seed(seed));

always @(posedge clk) begin
    if(rst) begin
        grid[0] <= 0;
        grid[1] <= 0;
        grid[2] <= 0;
        grid[3] <= 0;
        grid[4] <= 0;
        grid[5] <= 0;
        grid[6] <= 0;
        grid[7] <= 0;
        grid[8] <= 0;
        grid[9] <= 0;
        grid[10] <= 0;
        grid[11] <= 0;
        grid[12] <= 0;
        grid[13] <= 0;
        grid[14] <= 0;
        grid[15] <= 0;
        int_rd_data <= 0;
        seed <= 0;
        monte_rst <= 1;
//        max_move_count[0] <= 0;
//        max_move_count[1] <= 0;
//        total_move_count[0] <= 0;
//        total_move_count[1] <= 0;
//        total_move_count[2] <= 0;
//        total_move_count[3] <= 0;
//        total_trial_count[0] <= 0;
//        total_trial_count[1] <= 0;
//        total_trial_count[2] <= 0;
//        total_trial_count[3] <= 0;
    end else begin
        if(0 <= int_address && int_address < 16 && int_write) begin
            grid[int_address] <= int_wr_data;
        end else if(int_address == 16 && int_write) begin
            if(seed == 0) begin
                monte_rst <= 1; //when seed is 0, reset;
            end else begin
                seed <= int_wr_data;
                monte_rst <= 0;//calc start
            end
        end else if(int_address <= 17 && int_address < 27 && int_read) begin
            case (int_address)
                (17): int_rd_data <= max_move_count0[7:0];
                (17+1): int_rd_data <= max_move_count0[15:8];
                (17+2): int_rd_data <= total_move_count0[7:0];
                (17+3): int_rd_data <= total_move_count0[15:8];
                (17+4): int_rd_data <= total_move_count0[23:16];
                (17+5): int_rd_data <= total_move_count0[31:24];
                (17+6): int_rd_data <= total_trial_count0[7:0];
                (17+7): int_rd_data <= total_trial_count0[15:8];
                (17+8): int_rd_data <= total_trial_count0[23:16];
                (17+9): int_rd_data <= total_trial_count0[31:24];
            endcase
        end else if(int_address <= 27 && int_address < 37 && int_read) begin
            case (int_address)
                (27): int_rd_data <= max_move_count1[7:0];
                (27+1): int_rd_data <= max_move_count1[15:8];
                (27+2): int_rd_data <= total_move_count1[7:0];
                (27+3): int_rd_data <= total_move_count1[15:8];
                (27+4): int_rd_data <= total_move_count1[23:16];
                (27+5): int_rd_data <= total_move_count1[31:24];
                (27+6): int_rd_data <= total_trial_count1[7:0];
                (27+7): int_rd_data <= total_trial_count1[15:8];
                (27+8): int_rd_data <= total_trial_count1[23:16];
                (27+9): int_rd_data <= total_trial_count1[31:24];
            endcase
        end else if(int_address <= 37 && int_address < 47 && int_read) begin
            case (int_address)
                (37): int_rd_data <= max_move_count2[7:0];
                (37+1): int_rd_data <= max_move_count2[15:8];
                (37+2): int_rd_data <= total_move_count2[7:0];
                (37+3): int_rd_data <= total_move_count2[15:8];
                (37+4): int_rd_data <= total_move_count2[23:16];
                (37+5): int_rd_data <= total_move_count2[31:24];
                (37+6): int_rd_data <= total_trial_count2[7:0];
                (37+7): int_rd_data <= total_trial_count2[15:8];
                (37+8): int_rd_data <= total_trial_count2[23:16];
                (37+9): int_rd_data <= total_trial_count2[31:24];
            endcase
        end else if(int_address <= 57 && int_address < 67 && int_read) begin
            case (int_address)
                (47): int_rd_data <= max_move_count3[7:0];
                (47+1): int_rd_data <= max_move_count3[15:8];
                (47+2): int_rd_data <= total_move_count3[7:0];
                (47+3): int_rd_data <= total_move_count3[15:8];
                (47+4): int_rd_data <= total_move_count3[23:16];
                (47+5): int_rd_data <= total_move_count3[31:24];
                (47+6): int_rd_data <= total_trial_count3[7:0];
                (47+7): int_rd_data <= total_trial_count3[15:8];
                (47+8): int_rd_data <= total_trial_count3[23:16];
                (47+9): int_rd_data <= total_trial_count3[31:24];
            endcase
        end else begin
            int_rd_data <= 255;
        end
    end
end
endmodule
