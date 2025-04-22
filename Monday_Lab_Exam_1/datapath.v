module datapath(
    input clk,
    input rst,
    input Instr_Write,
    input Instr_Addr,
    input Instr_Data
);

    reg [9:0] PC;
    wire [9:0] PCPlus1;
    wire [9:0] PCNext;
    wire [31:0] Instruction;

    wire [31:0] Data_Read_1;
    wire [31:0] Data_Read_2;
    wire Data_Write;

    wire [31:0] ALU_Result;
    wire PCNext_Ctrl;

    assign PCPlus1 = PC + 1;

    assign PCNext = (PCNext_Ctrl) ? Instruction[10:1] : PCPlus1;

    always@(posedge clk)
    begin
        if(rst) begin
            PC <= 9'b0;
        end
        else begin
            PC <= PCNext;
        end
    end

    dist_mem_gen_1 instruction_mem(
        .a(Instr_Addr),
        .d(Instr_Data),
        .dpra(PC),
        .clk(clk),
        .we(Instr_Write),
        .dpo(Instruction)
    );

    assign Data_Write = Instruction[31];
    

    dist_mem_gen_0 data_mem(
        .a(Instruction[30:21]),
        .d(ALU_Result),
        .dpra(Instruction[20:11]),
        .clk(clk),
        .we(Data_Write),
        .spo(Data_Read_1),
        .dpo(Data_Read_2)
    );

    ALU alu(
        .A(Data_Read_1),
        .B(Data_Read_2),
        .sub(ALUResult),
        .overflow(PCNext_Ctrl)
    );


endmodule


module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] sub,
    output overflow
);

    assign {overflow, sub} = A - B;

endmodule