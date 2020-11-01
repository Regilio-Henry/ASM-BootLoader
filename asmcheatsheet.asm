jmp ;;jmp is a basic instruction that transfers control to another point in the program, by using jmp you can change the instruction pointer register to an assigned label

;;for example

jmp Mylabel

;;The label 
Mylabel:
;;instructions

ORG ;;sets the location where your program is expected to load from

mov ;; moves copies data from a source into a target destination this can be a hex number into a register, the contents of one register to another or data from a memory location into a register

;;for example
mov ax,bx
mov ax,10h
mov si,es:[bx]

xor ;; logical XOR (exclusive OR) between all bits of two operands. Result is stored in first operand. One of the common uses of XOR is to set a register to 0 by doing an XOR with itself, e.g. xor ax, ax will set ax to 0.

db ;;defines the byte value comonly used for strings or arrays

inc
test ;; The same as AND, but no result is stored. Only the flags register is affected.
je ;; same as jump but jumps if a condition has been met.

jnz ;jumps if an flag is not set to zero. It checks the register last modified

int
;; The int instruction is used to generate a software interrupt. It is very similar to a call instruction, but
;;instead of specifying the address to call, you specify a number which is used to look up an address in
;;the interrupt vector table. We will see more about this later in the module, but for now, you will see
;;the int instruction used to make calls to functions in the BIOS.

push ;is pushing a value to the stack 

pop ;is taking a value from the top of the stack and then puting it in a regiter

;;interupt: an interupt is a special routine which is an input signal for an even that requires immediate attention and serves as a request for the processor to  interupt the curently excuted code

int 10h ;; a short hand to call the adress in the vector table that provides vidoe serves such as character and string output, and graphics/primitives

mov ah, 0Eh ;; Writes one character at the current cursor location and advances the cursor.  This service responds to the ASCII meanings of characters
xchg 	bx, bx			  ; break point
ret
cli

eax;

call ;; The call instruction behaves very much like the jmp instruction, except that before it transfers control to the new location, the address of the instruction after the call is pushed on to the stack. 

buffer ;It's an allocation in memory that holds data before it gets processed

;;Registers

si ;;this is the source index registerused as apoint to a source of stream opperations used for string operations

Times ;;The TIMES directive allows multiple initializations to the same value. For example, an array named marks of size 9 can be defined and initialized to zero using the following statement 
;;The $ symbol denotes the current address of the statement, and the $$ denotes the address of the beginning of current section. 
;;So the lines with DUP and TIMES calculate the current address in the section and subtracts it from 510. This effectively just zeroes out the section from the beginning to the current address.