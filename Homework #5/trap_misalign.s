
## Constants
.equ EXIT      20       #Syscall to terminate trap handler
.equ PRINT_STR 4        #Syscall to print String

## System data
    .kdata
panic:  .asciz  "Unhandled exception\n"
    .align 2

#uregs needs to allocate space needed for stack
uregs: .zero 124

## System code
    .ktext
### Boot code
    .globl __mstart
__mstart:
    la      t0, __mtrap
    csrw    mtvec, t0

    la      t0, __user_bootstrap
    csrw    mepc, t0

    la      t0, uregs
    csrw    mscratch, t0
    
    mret  # Enter user bootstrap

 
### Trap handler
__mtrap:
# 1. Prologue: save registers

    csrrw sp, mscratch, sp  #Swap sp with mscratch
    
    #Save entire programs registers
    sw   x1, 0(sp)
    sw   x2, 4(sp)
    sw   x3, 8(sp)
    sw   x4, 12(sp)
    sw   x5, 16(sp)
    sw   x6, 20(sp)
    sw   x7, 24(sp)
    sw   x8, 28(sp)
    sw   x9, 32(sp)
    sw   x10, 36(sp)
    sw   x11, 40(sp)
    sw   x12, 44(sp)
    sw   x13, 48(sp)
    sw   x14, 52(sp)
    sw   x15, 56(sp)
    sw   x16, 60(sp)
    sw   x17, 64(sp)
    sw   x18, 68(sp)
    sw   x19, 72(sp)
    sw   x20, 76(sp)
    sw   x21, 80(sp)
    sw   x22, 84(sp)
    sw   x23, 88(sp)
    sw   x24, 92(sp)
    sw   x25, 96(sp)
    sw   x26, 100(sp)
    sw   x27, 104(sp)
    sw   x28, 108(sp)
    sw   x29, 112(sp)
    sw   x30, 116(sp)
    sw   x31, 120(sp)
 
# 2. First check that it's an exception we can handle
    # Check exception code
    csrr t0, mcause     #Load exception code into t0
    li   t1, 4          #4 is exception code for misaligned load address
    bne  t0, t1, unhandled_exception        #If exception doesn't match opcode branch

    # Get faulty instruction
    csrr t0, mepc       #t0 = *mepc
    lw   t1, 0(t0)      #t1 = mepc

    # Check that it's a load (opcode == 0b0000011)
    andi t2, t1, 0x7F       #Mask
    li   t3, 0x03           #Mask
    bne  t2, t3, unhandled_exception    #If exception doesn't match opcode, branch


    # Check that it's a load word (funct3 == 0b010)
    li   t4, 0x7000     #Load mask
    and  t2, t1, t4     #Mask
    li   t3, 0x2000     #Mask
    bne  t2, t3, unhandled_exception    #If exception doens't match opcode, branch

# 3. At this point, we know it's a load word with a misalign address. Now
#    retrieve 4 consecutive bytes from unaligned memory address, and
#    reconstitute full word.

    csrr    t0, mtval       #Load the unaligned address
    lbu     t1, 0(t0)       #Load the first byte
    lbu     t2, 1(t0)       #Load the second byte
    lbu     t3, 2(t0)       #Load the third byte
    lbu     t4, 3(t0)       #Load the fourth byte

    # Shift and combine
    slli    t2, t2, 8
    slli    t3, t3, 16
    slli    t4, t4, 24

    #Bitwise operation to combine into one word
    or      t1, t1, t2
    or      t1, t1, t3
    or      t1, t1, t4

# 4. Now place the value into destination register
    # Determine destination register rd from instruction
    
    csrr t6, mepc       #t6 = *mepc
    lw   t6, 0(t6)      #t6 = mepc

    srli t2, t6, 7      #Shift to desired bits
    andi t2, t2, 0x1F   #Mask
    addi t2, t2, -1     #Deduct one since Prologue began at x1
        
    # Modify uregs[rd]
    slli t2, t2, 2      #Shift to modify
    add t3, sp, t2      #Add new values together
    sw t1, 0(t3)        #Store in uregs

# 5. Return to next instruction
    csrr t0, mepc       #t0 = *mepc
    addi t0, t0, 4      #t0 = * mepc + 4
    csrw mepc, t0       #mepc = t0

# 6. Epilogue: Restore registers and return
epilogue:

    lw   x1, 0(sp)
    lw   x2, 4(sp)
    lw   x3, 8(sp)
    lw   x4, 12(sp)
    lw   x5, 16(sp)
    lw   x6, 20(sp)
    lw   x7, 24(sp)
    lw   x8, 28(sp)
    lw   x9, 32(sp)
    lw   x10, 36(sp)
    lw   x11, 40(sp)
    lw   x12, 44(sp)
    lw   x13, 48(sp)
    lw   x14, 52(sp)
    lw   x15, 56(sp)
    lw   x16, 60(sp)
    lw   x17, 64(sp)
    lw   x18, 68(sp)
    lw   x19, 72(sp)
    lw   x20, 76(sp)
    lw   x21, 80(sp)
    lw   x22, 84(sp)
    lw   x23, 88(sp)
    lw   x24, 92(sp)
    lw   x25, 96(sp)
    lw   x26, 100(sp)
    lw   x27, 104(sp)
    lw   x28, 108(sp)
    lw   x29, 112(sp)
    lw   x30, 116(sp)
    lw   x31, 120(sp)

    csrrw sp, mscratch, sp      #Restore sp with mscratch

    mret                        #Return from trap handler

unhandled_exception:
    #Print error and quit
    la      a0, panic
    li      a7, PRINT_STR
    ecall

    #Return 1 and exit
    li      a0, 1
    li      a7, EXIT
    ecall

## User boot code
    .text
__user_bootstrap:
    # exit(main())
    jal     main
    li      a7, EXIT
    ecall
