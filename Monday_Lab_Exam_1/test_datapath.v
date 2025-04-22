module test_datapath();

    reg clk;
    reg rst;
    reg Instr_Write;
    reg Instr_Addr;
    reg Instr_Data;
    
    initial begin
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 0;
        clk = 0;
        Instr_Write = 0;
        Instr_Addr = 0;
        Instr_Data = 0;

        #20
        rst = 1;

        #40
        rst = 0;

        #200

        $stop;
    end

    datapath(clk, rst, Instr_Write, Instr_Addr, Instr_Data);

endmodule