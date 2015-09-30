module monteCarloStat(clk, rst, restrected, restrect_prob, max_succcess_times, initial_board);
input clk;
input rst;
input [1:0] restrected;
input [2:0] restrect_prob;
input [79:0] initial_board;
output [15:0] max_succcess_times;
reg state [2:0];
reg [15:0] max_succcess_times;
wire stuck;
logic2048 logic(.clk(), .rst(), .calc_done(), .random(), .random_clk(), .initial_board(), .restrected(restrected), .restrected_prob(restrected_prob), .stuck(stuck));
always @(posedge clk) begin
    if(rst) begin
        max_succcess_times <= 0;
        state <= 0;
    end else begin
        if(state == 0);
    end
    
end

endmodule
