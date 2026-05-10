// ============================================================
//  8-Bit ALU
//  Supported Operations (opcode):
//    3'b000 - ADD   : result = A + B
//    3'b001 - SUB   : result = A - B
//    3'b010 - AND   : result = A & B
//    3'b011 - OR    : result = A | B
//    3'b100 - XOR   : result = A ^ B
//    3'b101 - NOT   : result = ~A
//    3'b110 - SHL   : result = A << 1 (shift left by 1)
//    3'b111 - SHR   : result = A >> 1 (shift right by 1)
// ============================================================

module alu_8bit (
    input  wire [7:0] A,        // Operand A
    input  wire [7:0] B,        // Operand B
    input  wire [2:0] opcode,   // Operation select
    output reg  [7:0] result,   // ALU result
    output reg        zero,     // Zero flag  (result == 0)
    output reg        carry,    // Carry flag (arithmetic overflow)
    output reg        negative  // Negative flag (MSB of result)
);

    reg [8:0] temp; // 9-bit temp to capture carry

    always @(*) begin
        // Default values
        temp     = 9'b0;
        carry    = 1'b0;

        case (opcode)
            3'b000: begin // ADD
                temp   = {1'b0, A} + {1'b0, B};
                result = temp[7:0];
                carry  = temp[8];
            end
            3'b001: begin // SUB
                temp   = {1'b0, A} - {1'b0, B};
                result = temp[7:0];
                carry  = temp[8]; // borrow bit
            end
            3'b010: begin // AND
                result = A & B;
            end
            3'b011: begin // OR
                result = A | B;
            end
            3'b100: begin // XOR
                result = A ^ B;
            end
            3'b101: begin // NOT
                result = ~A;
            end
            3'b110: begin // SHL (shift left by 1)
                carry  = A[7];    // MSB shifts out to carry
                result = A << 1;
            end
            3'b111: begin // SHR (shift right by 1)
                carry  = A[0];    // LSB shifts out to carry
                result = A >> 1;
            end
            default: begin
                result = 8'b0;
            end
        endcase

        // Update flags
        zero     = (result == 8'b0) ? 1'b1 : 1'b0;
        negative = result[7];
    end

endmodule
