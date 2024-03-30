## Constants
.equ READ_DEC  10       #Function to read input
.equ PRINT_DEC 0        #Function to print integers
.equ PRINT_STR 4        #Function to print Strings
.equ PRINT_FLOAT 2      #Function to print Float

.data
  tempf: .asciz "Temperature in Fahrenheit is: "
  tempc: .asciz "Temperature in Celsius is: "
  nextline: .asciz "\n"
  five: .float 5.00000
  nine: .float 9.00000
  thirtytwo: .float 32.00000

    .text
    .globl main
main:

  #Print "Temperature in Farneheit is: "
  la    x10, tempf
  li    x17, PRINT_STR
  ecall
  
  #Read and display inputted value (F)
  li x17, READ_DEC
  ecall
  li x17, PRINT_DEC
  ecall

  #Store input value into available storage register
  mv  x22, x10

  #Print to next line
  la    x10, nextline
  li    x17, PRINT_STR
  ecall
  

  #Print "Temperature in Celsius is: "
  la    x10, tempc
  li    x17, PRINT_STR
  ecall


  #Store the value of 5/9 in f19
  lw       x11, five
  fmv.w.x  f12, x11
  lw       x11, nine
  fmv.w.x  f13, x11
  fdiv.s   f19, f12, f13

  #Get (Input value) - 32:
  
  fcvt.s.w  f10, x22
  lw        x11, thirtytwo
  fmv.w.x   f12, x11
  fsub.s    f10, f10, f12

  #Multiply the two for final result
  fmul.s    f10, f10, f19

  li  x17, PRINT_FLOAT
  ecall

  #Formatting for ease of view
  la    x10, nextline
  li    x17, PRINT_STR
  ecall

  li  x10, 0        #Return 0 from main
  jr  x1            #Return 0 from main
