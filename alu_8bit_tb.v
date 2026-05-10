// ============================================================
//  Testbench for 8-Bit ALU (alu_8bit.v)
// ============================================================

`timescale 1ns/1ps

module alu_8bit_tb;

    // Inputs
    reg  [7:0] A;
    reg  [7:0] B;
    reg  [2:0] opcode;

    // Outputs
    wire [7:0] result;
    wire       zero;
    wire       carry;
    wire       negative;

    // Instantiate the DUT (Device Under Test)
    alu_8bit uut (
        .A        (A),
        .B        (B),
        .opcode   (opcode),
        .result   (result),
        .zero     (zero),
        .carry    (carry),
        .negative (negative)
    );

    // Task to display results
    task print_result;
        input [63:0] op_name; // operation name as ASCII
        begin
            $display("%-5s | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b",
                     op_name, A, B, result, zero, carry, negative);
        end
    endtask

    initial begin
        $display("=============================================================");
        $display(" 8-Bit ALU Testbench");
        $display("=============================================================");
        $display("OP    | A        B       | result   | zero carry neg");
        $display("-------------------------------------------------------------");

        // ----- ADD -----
        A = 8'h1A; B = 8'h2B; opcode = 3'b000; #10;
        $display("ADD   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // ADD with carry (overflow)
        A = 8'hFF; B = 8'h01; opcode = 3'b000; #10;
        $display("ADD   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (carry expected)", A, B, result, zero, carry, negative);

        // ADD resulting in zero
        A = 8'hFF; B = 8'h01; opcode = 3'b000; #10;
        $display("ADD   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (zero+carry expected)", A, B, result, zero, carry, negative);

        // ----- SUB -----
        A = 8'h50; B = 8'h20; opcode = 3'b001; #10;
        $display("SUB   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // SUB resulting in zero
        A = 8'hAB; B = 8'hAB; opcode = 3'b001; #10;
        $display("SUB   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (zero expected)", A, B, result, zero, carry, negative);

        // SUB with borrow (A < B)
        A = 8'h05; B = 8'h10; opcode = 3'b001; #10;
        $display("SUB   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (borrow+neg expected)", A, B, result, zero, carry, negative);

        // ----- AND -----
        A = 8'hF0; B = 8'hAA; opcode = 3'b010; #10;
        $display("AND   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // AND resulting in zero
        A = 8'hF0; B = 8'h0F; opcode = 3'b010; #10;
        $display("AND   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (zero expected)", A, B, result, zero, carry, negative);

        // ----- OR -----
        A = 8'hF0; B = 8'h0F; opcode = 3'b011; #10;
        $display("OR    | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // ----- XOR -----
        A = 8'hA5; B = 8'h5A; opcode = 3'b100; #10;
        $display("XOR   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // XOR same values -> zero
        A = 8'hCC; B = 8'hCC; opcode = 3'b100; #10;
        $display("XOR   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (zero expected)", A, B, result, zero, carry, negative);

        // ----- NOT -----
        A = 8'hAA; B = 8'h00; opcode = 3'b101; #10;
        $display("NOT   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        A = 8'hFF; B = 8'h00; opcode = 3'b101; #10;
        $display("NOT   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (zero expected)", A, B, result, zero, carry, negative);

        // ----- SHL (Shift Left) -----
        A = 8'hA5; B = 8'h00; opcode = 3'b110; #10;
        $display("SHL   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (carry expected=MSB of A)", A, B, result, zero, carry, negative);

        A = 8'h01; B = 8'h00; opcode = 3'b110; #10;
        $display("SHL   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        // ----- SHR (Shift Right) -----
        A = 8'hA5; B = 8'h00; opcode = 3'b111; #10;
        $display("SHR   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b (carry expected=LSB of A)", A, B, result, zero, carry, negative);

        A = 8'h80; B = 8'h00; opcode = 3'b111; #10;
        $display("SHR   | A=0x%02h  B=0x%02h | result=0x%02h | zero=%b  carry=%b  neg=%b", A, B, result, zero, carry, negative);

        $display("=============================================================");
        $display(" Simulation complete.");
        $display("=============================================================");
        $finish;
    end

endmodule
