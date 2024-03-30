## Constants
.equ READ_DEC  10       #Function to read input
.equ PRINT_DEC 0        #Function to print integers
.equ PRINT_STR 4        #Function to print Strings


    .data
  amount: .asciz "Amount of cents to change: "
  numquar: .asciz "Number of quarters: "
  numdimes: .asciz "Number of dimes: "
  numnickels: .asciz "Number of nickels: "
  numpennies: .asciz "Number of pennies: "
  nextline: .asciz "\n"
  quarters: .word 25
  dimes: .word 10
  nickels: .word 5
  pennies: .word 1

    .text
    .globl main
main:

  #Print "Amount of cents to change:"
  la    x10, amount
  li    x17, PRINT_STR
  ecall

  #Read pre-established input
  li    x17, READ_DEC
  ecall

  #Print pre-established input (cents)
  li    x17, PRINT_DEC
  ecall

  #Store the input value into an avilable register
  mv    x11, x10

  #Print to the next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall

  #Print "Number of quarters: "
  la    x10, numquar
  li    x17, PRINT_STR
  ecall

  #Divise the total amount of cents by 25 to find amount of quarters
  lw    x10, quarters
  rem   x12, x11, x10
  div   x11, x11, x10
  mv    x10, x11
  li    x17, PRINT_DEC
  ecall

  #Print to the next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall
  
  #Print "Number of dimes: "
  la    x10, numdimes
  li    x17, PRINT_STR
  ecall

  #Calculate number of dimes:
  lw    x10, dimes
  rem   x13, x12, x10
  div   x12, x12, x10
  mv    x10, x12
  li    x17, PRINT_DEC
  ecall

  #Print to the next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall

  #Print "Number of nickels: "
  la    x10, numnickels
  li    x17, PRINT_STR
  ecall

  #Calculate number of nickels:
  lw    x10, nickels
  rem   x14, x13, x10
  div   x13, x13, x10
  mv    x10, x13
  li    x17, PRINT_DEC
  ecall

  #Print to the next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall

  #Print "Number of pennies: "
  la    x10, numpennies
  li    x17, PRINT_STR
  ecall

  #Print what's left over
  mv x10, x14
  li x17, PRINT_DEC
  ecall

  #Print to the next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall

  li  x10, 0        #Return 0 from main
  jr  x1            #Return 0 from main
