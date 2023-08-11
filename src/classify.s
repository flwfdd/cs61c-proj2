.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5
    bne a0 t0 error_argnum
    
    addi sp sp -48
    sw ra 0(sp)
    sw s0 4(sp) #argv
    sw s1 8(sp) #silent mode
    # 12(sp) N
    # 16(sp) 784
    # 20(sp) 10
    # 24(sp) 1
    sw s2 28(sp) # m0
    sw s3 32(sp) # m1
    sw s4 36(sp) # input
    sw s5 40(sp) # h
    sw s6 44(sp) # output
    
    mv s0 a1 #argv
    mv s1 a2 #silent mode
    
    # Read pretrained m0 N*784
    addi t0 s0 4
    lw a0 0(t0)
    addi a1 sp 12
    addi a2 sp 16
    jal read_matrix
    mv s2 a0


    # Read pretrained m1 10*N
    addi t0 s0 8
    lw a0 0(t0)
    addi a1 sp 20
    addi a2 sp 12
    jal read_matrix
    mv s3 a0


    # Read input matrix 784*1
    addi t0 s0 12
    lw a0 0(t0)
    addi a1 sp 16
    addi a2 sp 24
    jal read_matrix
    mv s4 a0


    # Compute h = matmul(m0, input) N*1
    lw a0 12(sp)
    li t0 4
    mul a0 a0 t0
    jal malloc
    beq a0 zero error_malloc
    mv s5 a0
    
    mv a0 s2
    lw a1 12(sp)
    lw a2 16(sp)
    mv a3 s4
    lw a4 16(sp)
    lw a5 24(sp)
    mv a6 s5
    jal matmul


    # Compute h = relu(h)
    mv a0 s5
    lw a1 12(sp)
    jal relu


    # Compute o = matmul(m1, h) 10*1
    lw a0 20(sp)
    li t0 4
    mul a0 a0 t0
    jal malloc
    beq a0 zero error_malloc
    mv s6 a0
    
    mv a0 s3
    lw a1 20(sp)
    lw a2 12(sp)
    mv a3 s5
    lw a4 12(sp)
    lw a5 24(sp)
    mv a6 s6
    jal matmul


    # Write output matrix o
    addi t0 s0 16
    lw a0 0(t0)
    mv a1 s6
    lw a2 20(sp)
    lw a3 24(sp)
    jal write_matrix


    # Compute and return argmax(o)
    mv a0 s6
    lw a1 20(sp)
    jal argmax
    mv s0 a0

    # If enabled, print argmax(o) and newline
    beq s1 zero print_argmax
print_argmax_back:
    
    mv a0 s5
    jal free
    mv a0 s6
    jal free
    
    mv a0 s0
    
    lw ra 0(sp)
    lw s0 4(sp) #argv
    lw s1 8(sp) #silent mode
    # 12(sp) N
    # 16(sp) 784
    # 20(sp) 10
    # 24(sp) 1
    lw s2 28(sp) # m0
    lw s3 32(sp) # m1
    lw s4 36(sp) # input
    lw s5 40(sp) # h
    lw s6 44(sp) # output
    addi sp sp 48
    
    jr ra

print_argmax:
    mv a0 s0
    jal print_int
    li a0 '\n'
    jal print_char
    j print_argmax_back
error_argnum:
    li a0 31
    j exit
error_malloc:
    li a0 26
    j exit