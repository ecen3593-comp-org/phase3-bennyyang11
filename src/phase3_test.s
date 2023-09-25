/*
 * phase3_test.s
 *
 * Author:
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

    // Add test program here





    // End of test sequence
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
