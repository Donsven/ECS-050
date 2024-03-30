## Constants
.equ READ_DEC  10       #Function to read input
.equ PRINT_DEC 0        #Function to print integers
.equ PRINT_STR 4        #Function to print Strings

.data
  #Put data in here
  arr: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  nextline: .asciz "\n"
  MAX_LEN: .word 9
  four: .word 4
  notfoundmessage: .asciz "Not found\n"
  foundat: .asciz "Found at index "

    .text
    .globl main
main:

    # REMEMBER TO CHANGE JUMP LABELS ON FUNCTIONS
    #
    #GLOBAL VARIABLES:
    #
    #s0 = MAX_LEN
    #s1 = counter
    #s2 = arr[0]
    #s6 = 4
    #

    #Store the value max_len in s0
    lw s0, MAX_LEN
    
    #int counter = 0;
    li s1, 0

    #Load address of arr[0] in t2
    la s2, arr

    #duplicate address of arr[0] into t0
    mv t0, s2

    #Load constant of 4 into s6
    lw s6, four
    
    j load


load:

    #Read user input
    li a7, READ_DEC
    ecall

    #If user input < 0 branch to terminate
    bltz a0, insertionsort

    #Store a0 in arr[counter * 4]
    sw a0, 0(t0)
    addi t0, t0, 4

    #increment counter
    addi s1, s1, 1

    #If counter > max_len terminate loop
    bgt s1, s0, insertionsort

    #Restart loop
    j load
    

#Function to perform insertion sort
insertionsort:

    #int i = 1;
    li t0, 1
    
    #while i < arr.length()

    while1:

    #in case i >= arr.length() end loop
    ble s1, t0, find

    #j = i;
    mv t1, t0

        #while j > 0 && arr[j-1] > arr[j]
        while2:

        #while j > 0 (Condition 1)
        blez t1, endinnerloop

        #Load values of arr[j] and arr[j - 1]
        
        #Get address of arr[j]
        mul t3, t1, s6  #Get added offset
        add t3, t3, s2  #Get *arr + offset

        lw t2, 0(t3)       #t2 = arr[j]
        lw t4, -4(t3)      #t3 = arr[j - 1]

        #If arr[j - 1] is not > arr[j], branch
        blt t4, t2, endinnerloop

        #Swap arr[j] and arr[j - 1]
        sw t2, -4(t3)
        sw t4, 0(t3)
        
        #j = j - 1
        addi t1, t1, -1

        j while2


    endinnerloop:

    #i = i + 1;
    addi t0, t0, 1

    #Restart loop since ((i < arr.length()) == TRUE)
    j while1



#Insert code to conitnue after calling sort()
find:

    #Read user input
    li a7, READ_DEC
    ecall

    #If users input is < 0, jump to terminate
    bltz a0, terminate

    #put the users input into t0
    mv t0, a0

    #t1 = * arr
    mv t1, s2

    #initialize index counter
    li s8, 0

    checkloop:

    #t2 = arr[i]
    lw t2, 0(t1)

    #If user input is found in array[i], jump to printfound
    beq t0, t2, printfound

    #If value not found jump to notfound
    bge s8, s1, notfound

    #incrememnt arr[i]
    addi t1, t1, 4

    #increment index counter
    addi s8, s8, 1

    j checkloop


    printfound:

    #Print "Found at index"
    la a0, foundat
    li a7, PRINT_STR
    ecall

    #print found values index
    mv a0, s8
    li a7, PRINT_DEC
    ecall

    #Print newline
    la a0, nextline
    li a7, PRINT_STR
    ecall

    #restart prompt
    j find

    notfound:
    #in case value not found, print "not found" and restart prompt
    la a0, notfoundmessage
    li a7, PRINT_STR
    ecall

    j find
    
terminate:

    li  x10, 0        #Return 0 from main
    jr  x1            #Return 0 from main
