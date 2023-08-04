.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    blt zero a1 loop_start # a1>=0
    li a0 36
    j exit

loop_start:
    li t0 0 #index
    lw t1 0(a0) #t1=*a0
    li t2 0 #argmax index

loop_continue:
    beq t0 a1 loop_end
    addi t0 t0 1
    lw t3 0(a0) #t2=*a0
    addi a0 a0 4 #a0++
    
    bge t1 t3 loop_continue # if t1>=t3 continue
    mv t1 t3
    addi t2 t0 -1
    
    j loop_continue

loop_end:
    # Epilogue
    mv a0 t2
    
    jr ra
