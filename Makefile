MAIN = test
BENCH = test
SOURCES = Logic-2048-FPGA/random-seq-gen/*.v Logic-2048-FPGA/*.v uart2bus/*.v top.v monteCarloStat.v uart_bench/tb_txt_uart2bus_top.v uart_bench/timescale.v
VERILOG = iverilog
WAVE = gtkwave

.PHONY: all
all: $(MAIN).out

.PHONY: wave
wave: $(MAIN).out
	./$(MAIN).out
	$(WAVE) $(BENCH).vcd > /dev/null 2>&1 &

$(MAIN).out: $(SOURCES)
	$(VERILOG) -o $(MAIN).out -s $(BENCH) $(SOURCES)

.PHONY: clean
clean:
	rm -rf *.vcd *.out
