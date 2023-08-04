.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
    bge zero a2 error_36
    bge zero a3 error_37
    bge zero a4 error_37
    
    li t2 0
    li t0 4
    mul a3 a3 t0
    mul a4 a4 t0
    j loop_start
error_36:
    li a0 36
    j exit
error_37:
    li a0 37
    j exit

loop_start:
    beq a2 zero loop_end
    addi a2 a2 -1
    lw t0 0(a0)
    lw t1 0(a1)
    mul t0 t0 t1
    add t2 t2 t0
    
    add a0 a0 a3
    add a1 a1 a4
    j loop_start

loop_end:
    # Epilogue
    mv a0 t2

    jr ra
