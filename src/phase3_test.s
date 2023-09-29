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

    // Initialize result register
    li x1, 0
    li x30, 1  // 1 or 0x00000001 - DO NOT MODIFY
    li x31, -1 // -1 or 0xffffffff - DO NOT MODIFY

    // Test XOR instruction
    li x2, 0xA
    li x3, 0x5
    xor x4, x2, x3 // Expected 0xF
    li x5, 0xF
    bne x4, x5, XOR_FAILURE

XOR_SUCCESS:
    // Test ANDI instruction
    li x2, 0xF
    andi x4, x2, 0x3 // Expected 0x3
    li x5, 0x3
    bne x4, x5, ANDI_FAILURE

ANDI_SUCCESS:
    // Test ORI instruction
    li x2, 0x1
    ori x4, x2, 0x4 // Expected 0x5
    li x5, 0x5
    bne x4, x5, ORI_FAILURE

ORI_SUCCESS:
    // Test SLT instruction
    li x2, 0x5
    li x3, 0xA
    slt x4, x2, x3 // Expected 0x1 as x2 is less than x3
    li x5, 0x1
    bne x4, x5, SLT_FAILURE

SLT_SUCCESS:
    // Testing SLTU instruction
    li x2, 0xFFFFFFFF
    li x3, 0x1
    sltu x4, x2, x3 // Expected 0x1 as x2 is treated as a very large unsigned number
    li x5, 0x1
    bne x4, x5, SLTU_FAILURE

SLTU_SUCCESS:
    // Testing AUIPC instruction
    li x2, 0x100
    auipc x4, x2 // The value in x4 is the PC plus the immediate value
    li x5, ACTUAL_EXPECTED_VALUE // Replace with the actual value
    bne x4, x5, AUIPC_FAILURE

AUIPC_SUCCESS:
    j FINISH

XOR_FAILURE:
    ori x1, x1, 0x1 // Set bit 0 of x1 to 1
    j ANDI_SUCCESS

ANDI_FAILURE:
    ori x1, x1, 0x2 // Set bit 1 of x1 to 1
    j ORI_SUCCESS

ORI_FAILURE:
    ori x1, x1, 0x4 // Set bit 2 of x1 to 1
    j SLT_SUCCESS

SLT_FAILURE:
    ori x1, x1, 0x8 // Set bit 3 of x1 to 1
    j SLTU_SUCCESS

SLTU_FAILURE:
    ori x1, x1, 0x10 // Set bit 4 of x1 to 1
    j AUIPC_SUCCESS

AUIPC_FAILURE:
    ori x1, x1, 0x20 // Set bit 5 of x1 to 1
    j EXIT

// The below are placeholders and may be replaced with actual next instruction or test sequence.
EXIT:
    // Final Exit Point or clean-up
    j FINISH
 
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
