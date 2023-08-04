.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    bge zero a1 error_38
    bge zero a2 error_38
    bge zero a4 error_38
    bge zero a5 error_38
    bne a2 a4 error_38

    # Prologue
    addi sp sp -40
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    
    mv s0 a0 #*m0
    mv s1 a3 #*m1
    mv s2 a1 #a height of m0
    mv s3 a2 #b weight of m0, height of m1
    mv s4 a5 #c weight of m1
    mv s5 a6 #*d
    li s6 -1 #index
    li s7 -1 #i row
    
    li t0 4
    mul t0 t0 s3
    sub s0 s0 t0
    
    j outer_loop_start
    
error_38:
    li a0 38
    j exit

outer_loop_start:
    addi s7 s7 1 #i++
    beq s7 s2 outer_loop_end #i==a
    li s8 -1 #j column
    li t0 4
    mul t0 t0 s3
    add s0 s0 t0

inner_loop_start:
    addi s6 s6 1 #index++
    addi s8 s8 1 #j++
    beq s8 s4 inner_loop_end #j==c
    
    mv a0 s0
    mv a1 s1
    mv a2 s3
    li a3 1
    mv a4 s4
    jal dot
    sw a0 0(s5) #*d
    addi s5 s5 4 #d++
    
    addi s1 s1 4
    j inner_loop_start

inner_loop_end:
    li t0 4
    mul t0 t0 s4
    sub s1 s1 t0
    j outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    addi sp sp 40
    jr ra
