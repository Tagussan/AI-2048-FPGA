module monteCarloStat(clk, rst, restrected, restrect_prob, max_move_count, total_move_count, total_trial_count, initial_board, seed);
input clk;
input rst;
input [1:0] restrected;
input [2:0] restrect_prob;
input [79:0] initial_board;
input [7:0] seed;
output [15:0] max_move_count;
output [31:0] total_move_count;
output [31:0] total_trial_count;
reg [2:0] state;
reg [15:0] max_move_count;
reg [31:0] total_move_count;
reg [31:0] total_trial_count;
reg logicRst;
reg random_rst;
wire stuck;
wire logic_calc_done;
wire random_clk;
wire [31:0] random;
wire [14:0] move_count;
xorshift32 rnd(.clk(random_clk), .rst(random_rst), .res(random), .seed(seed));
logic2048 logic2048(.clk(clk), .rst(logicRst), .calc_done(logic_calc_done), .random(random[22:0]), .random_clk(random_clk), .initial_board(initial_board), .restrected(restrected), .restrect_prob(restrect_prob), .stuck(stuck), .move_count(move_count));
always @(posedge clk) begin
    if(rst) begin
        max_move_count <= 0;
        total_move_count <= 0;
        total_trial_count <= 0;
        state <= 0;
        logicRst <= 0;
        random_rst <= 1;
    end else begin
        if(state == 0) begin
            state <= 1;
            logicRst <= 1;
        end else if(state == 1) begin
            logicRst <= 0;
            random_rst <= 0;
            state <= 2;
        end else if(state == 2 && stuck == 1) begin
            total_move_count <= total_move_count + move_count;
            if (move_count > max_move_count) begin
                max_move_count <= move_count;
            end
            total_trial_count <= total_trial_count + 1;
            state <= 0;
        end
    end
end
endmodule
