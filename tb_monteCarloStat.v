`timescale 1ns/1ns
module tb_monteCarloStat();
    parameter STEP = 20;
    reg [79:0] initial_board;
    reg clk, rst;
    wire [14:0] max_move_count;
    wire [31:0] total_trial_count, total_move_count;
    monteCarloStat stat(.clk(clk), .rst(rst), .restrected(2'd0), .restrect_prob(3'd1), .max_move_count(max_move_count), .total_move_count(total_move_count), .total_trial_count(total_trial_count), .initial_board(initial_board), .seed(8'b1111));
    initial begin
        $dumpfile("tb_monteCarloStat.vcd");
        $dumpvars(0, tb_monteCarloStat);
        rst = 0;
        initial_board = {5'd0, 5'd0, 5'd0, 5'd0, 5'd0 ,5'd0, 5'd0, 5'd0, 5'd0 ,5'd0, 5'd0, 5'd0, 5'd0, 5'd1};
#STEP   clk = 0;
#STEP   rst = 1;
        toggleClk;
        toggleClk;
        rst = 0;
    end
    task showStatus;
        begin
            $display("max_move_count, %d", max_move_count);
            $display("total_move_count, %d", total_move_count);
            $display("total_trial_count, %d", total_trial_count);
        end
    endtask
    task toggleClk;
        begin
#STEP       clk <= ~clk;
        end
    endtask
    always #10 begin
        clk <= ~clk;
    end
    always #3000 begin
        $display("max_move_count, %d", max_move_count);
        $display("total_move_count, %d", total_move_count);
        $display("total_trial_count, %d", total_trial_count);
    end
endmodule
