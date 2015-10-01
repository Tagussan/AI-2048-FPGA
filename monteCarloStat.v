module monteCarloStat(clk, rst, restrected, restrect_prob, max_move_count, initial_board);
input clk;
input rst;
input [1:0] restrected;
input [2:0] restrect_prob;
input [79:0] initial_board;
output [14:0] max_move_count;
output [31:0] total_move_count;
output [31:0] total_trial_count;
reg state [2:0];
reg [14:0] max_move_count;
reg [31:0] total_move_count;
reg [31:0] total_trial_count;
reg logicRst;
wire stuck;
wire logic_calc_done;
wire [14:0] succ_count
logic2048 logic(.clk(clk), .rst(logicRst), .calc_done(logic_calc_done), .random(), .random_clk(), .initial_board(initial_board), .restrected(restrected), .restrected_prob(restrected_prob), .stuck(stuck), .succ_count(succ_count));
always @(posedge clk) begin
    if(rst) begin
        max_move_count <= 0;
        total_move_count <= 0;
        total_trial_count <= 0;
        state <= 0;
        logicRst <= 0;
    end else begin
        if(state == 0) begin
            logicRst <= 1;
            state <= 1;
        end else if(state == 1) begin
            logicRst <= 0;
            state <= 2;
        end else if(state == 2 && stuck == 1) begin
            total_move_count <= total_move_count + succ_count;
            if (succ_count > max_succcess_times) begin
                max_succcess_times <= succ_count;
            end
            total_trial_count <= total_trial_count + 1;
            state <= 0;
        end
    end
end
endmodule


