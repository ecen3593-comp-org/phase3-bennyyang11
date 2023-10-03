/*
 * phase3_test.s
 *
 * Author: Benjamin Yang
 * Date:
 *
 */

  // Section .crt0 is always placed from address 0
	.section .crt0, "ax"

_start:
	.global _start

    // Result register
    li x1, 0
    // x30 = 1 or 0x00000001 - DO NOT MODIFY
    li x30, 1
    // x31 = -1 or 0xffffffff - DO NOT MODIFY
    li x31, -1 

    //XOR Test
    li x5, 0x1
    xor x4, x30, x30 
    li x6, 0x0  // Load immediate 0 to a register
    bne x4, x6, XOR_ERROR  // Compare registers

    XOR_ERROR:
        or x1, x1, x5  

    //AND Test
    slli x5, x5, 1 //before starting shift x5 by one byte
    andi x4, x30, 0
    bne x4, x30, ANDI_ERROR

    ANDI_ERROR:
        or x1, x1, x5 


    //ORI Test
    slli x5, x5, 1
    ori x4, x30, 0
    li x6, 0
    bne x4, x6, ORI_ERROR

    ORI_ERROR:
        or x1, x1, x5  

    //SLT Test
    slli x5, x5, 1
    slt x4, x31, x30 
    bne x4, x30, SLT_ERROR  // Use register x7 as the second operand
    
    SLT_ERROR:
        or x1, x1, x5  


    //SLTU Test
    slli x5, x5, 1 
    sltu x4, x30, x31
    bne x4, x30, SLTU_ERROR  // Use register x7 as the second operand
    
    SLTU_ERROR:
     or x1, x1, x5  

    //AUIPC Test
    slli x5, x5, 1
    jal x4, NEXT_LINE
    NEXT_LINE:
    auipc x5, 0 
    bne x4, x5, AUIPC_ERROR

    AUIPC_ERROR:
        or x1, x1, x5  


    //BLT
    slli x5, x5, 1
    blt x31, x30, NO_BLT_ERROR
    or x1, x1, x5 
    NO_BLT_ERROR:

    //BLTU Test
    slli x5, x5, 1
    li x2, 5
    li x3, -1  // Represented as 0xFFFFFFFF in Two's Complement
    bltu x2, x3, NO_BLTU_ERROR  // Should branch as 5 is less than 0xFFFFFFFF unsigned
    or x1, x1, x5  // If it doesn’t branch, set Bit 7 in x1
    NO_BLTU_ERROR:


    //ADD Test
    slli x5, x5, 1  // Prepare x5 for ADD test error bit
    li x2, 0x00
    li x3, 0x01
    li x4, 0x01
    li x6, 0  // Initialize a counter for the bit position
    ADD_LOOP:
        add x5, x2, x3  // Add x2 and x3 and store the result in x5
        bne x5, x4, ADD_ERROR  // If x5 is not equal to x4, branch to ADD_ERROR
        slli x2, x2, 1  // Shift x2 left by 1 bit
        slli x3, x3, 1  // Shift x3 left by 1 bit
        slli x4, x4, 1  // Shift x4 left by 1 bit
        addi x6, x6, 1  // Increment the bit position counter
        li x7, 32  // Load 32 into register x7
        blt x6, x7, ADD_LOOP  // Use register x7 as the second operand
    
    ADD_ERROR:
        li x7, 0x2000  // 0x2000 represents the error bit for ADD instruction (bit 13)
        slli x6, x6, 8  // Shift the bit position counter to the correct position (bits 12:8)
        or x1, x1, x7  // Set the error bit in x1
        or x1, x1, x6  // Set the failing bit number in x1

    
    ADD_SUCCESS:



    //SRA Test
    slli x5, x5, 1
    li x2, 0x80000000  // Set the MSB
    li x6, 31  // Load immediate 31 to a register
    sra x4, x2, x6  // Shift right arithmetic
    li x6, 0xFFFFFFFF  // Expected result is all 1s due to sign extension
    bne x4, x6, SRA_ERROR
    
    SRA_ERROR:
        or x1, x1, x5  // Set the corresponding bit in x1

    //SRL Test
    slli x5, x5, 1
    lui x2, 0x8000  // Load the upper 20 bits
    ori x2, x2, 0x0000  // Set the lower 12 bits
    li x7, 31  // Load 31 into register x7
    srl x4, x2, x7  // Use register x7 as the second operand
    bne x4, x6, SRL_ERROR
    SRL_ERROR:
        or x1, x1, x5  // Set the corresponding bit in x1

    //LW Test
    slli x5, x5, 1  // Shift left x5 by 1 to prepare for the next test
    
    // Store each byte of the word
    li x6, 0x12
    sb x6, 0x103(x0)  // Store byte to memory address 0x103
    
    li x6, 0x34
    sb x6, 0x102(x0)  // Store byte to memory address 0x102
    
    li x6, 0x56
    sb x6, 0x101(x0)  // Store byte to memory address 0x101
    
    li x6, 0x78
    sb x6, 0x100(x0)  // Store byte to memory address 0x100
    
    // Load the word and compare
    lw x4, 0x100(x0)  // Load word from memory address 0x100
    li x7, 0x12345678  // Expected value after loading the word
    bne x4, x7, LW_ERROR  // If x4 is not equal to x7, branch to LW_ERROR
    
    LW_ERROR:
        or x1, x1, x5  // Set the corresponding bit in x1



    //SW Test
    slli x5, x5, 1  // Shift left x5 by 1 to prepare for the next test
    li x2, 0x12345678  // Word value to store
    sw x2, 0x200(x0)  // Store word to memory address 0x200
    
    // Load and check each byte of the stored word
    lb x4, 0x200(x0)  // Load byte from memory address 0x200
    li x6, 0x78  // Expected value for the first byte
    bne x4, x6, SW_ERROR  // If x4 is not equal to x6, branch to SW_ERROR
    
    lb x4, 0x201(x0)  // Load byte from memory address 0x201
    li x6, 0x56  // Expected value for the second byte
    bne x4, x6, SW_ERROR  // If x4 is not equal to x6, branch to SW_ERROR
    
    lb x4, 0x202(x0)  // Load byte from memory address 0x202
    li x6, 0x34  // Expected value for the third byte
    bne x4, x6, SW_ERROR  // If x4 is not equal to x6, branch to SW_ERROR
    
    lb x4, 0x203(x0)  // Load byte from memory address 0x203
    li x6, 0x12  // Expected value for the fourth byte
    bne x4, x6, SW_ERROR  // If x4 is not equal to x6, branch to SW_ERROR
    
    j END_SW_TEST  // Jump to the end of the SW test if no error occurred
    
    SW_ERROR:
        or x1, x1, x5  // Set the corresponding bit in x1
    
    END_SW_TEST:




    //SUB Test
    slli x5, x5, 1
    li x2, 0x10
    li x3, 0x5
    sub x4, x2, x3  // Subtract x3 from x2 and store the result in x4
    li x6, 0x5
    bne x4, x6, SUB_ERROR
    
    SUB_ERROR:
        or x1, x1, x5  // Set the corresponding bit in x1



    FINISH:
        nop
        nop
        nop
        nop
        nop
        halt
        nop
        nop
        nop