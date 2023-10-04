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


     // Initialize for ADD check
    slli x5, x5, 1
    li x2, 0x00
    li x3, 0x01
    li x4, 0x01
    li x6, 0
    
    // Begin ADD Operation Loop
    ADD_CHK_LOOP:
        add x5, x2, x3
        bne x5, x4, ADD_ERR
        slli x2, x2, 1
        slli x3, x3, 1
        slli x4, x4, 1
        addi x6, x6, 1
        li x7, 32
        blt x6, x7, ADD_CHK_LOOP
    
    // On ADD Error
    ADD_ERR:
        li x7, 0x2000
        slli x6, x6, 8
        or x1, x1, x7
        or x1, x1, x6
    
    // Successful ADD Check
    ADD_PASS:
    
    //SRA Verification
    slli x5, x5, 1
    li x2, 0x80000000
    li x6, 31
    sra x4, x2, x6
    li x6, 0xFFFFFFFF
    bne x4, x6, SRA_FAIL
    
    SRA_FAIL:
        or x1, x1, x5
    
    //SRL Verification
    slli x5, x5, 1
    lui x2, 0x8000
    ori x2, x2, 0x0000
    li x7, 31
    srl x4, x2, x7
    bne x4, x6, SRL_FAIL
    
    SRL_FAIL:
        or x1, x1, x5
    
    //LW Verification
    slli x5, x5, 1
    
    // Prepare memory for LW Test
    li x6, 0x12
    sb x6, 0x103(x0)
    
    li x6, 0x34
    sb x6, 0x102(x0)
    
    li x6, 0x56
    sb x6, 0x101(x0)
    
    li x6, 0x78
    sb x6, 0x100(x0)
    
    // Execute LW and compare
    lw x4, 0x100(x0)
    li x7, 0x12345678
    bne x4, x7, LW_FAIL
    
    LW_FAIL:
        or x1, x1, x5
    
    //SW Verification
    slli x5, x5, 1
    li x2, 0x12345678
    sw x2, 0x200(x0)
    
    // Verify each byte after SW
    lb x4, 0x200(x0)
    li x6, 0x78
    bne x4, x6, SW_FAIL
    
    lb x4, 0x201(x0)
    li x6, 0x56
    bne x4, x6, SW_FAIL
    
    lb x4, 0x202(x0)
    li x6, 0x34
    bne x4, x6, SW_FAIL
    
    lb x4, 0x203(x0)
    li x6, 0x12
    bne x4, x6, SW_FAIL
    
    j SW_DONE
    
    SW_FAIL:
        or x1, x1, x5
    
    SW_DONE:


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