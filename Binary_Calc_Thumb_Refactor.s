.global main
.func main

main:
	ldr r0, = startthumb + 1
	bx  r0
	.code 16 			@Make all this code thumb mode. Will not exit back out. 

startthumb:
     Menu:
	push    {r7, lr}		@ Push LR and r7 onto stack
        mov     r7, sp			@ Move SP to r7
        sub     sp, sp, #56		@ Creating space on the stack
        ldr     r0, = sWelcome		@ Load greeting msg into r0 
        blx     printf			@ Print msg to screen

	ldr     r1, = sUserHexInput	@ Load string for user input into r1

        sub     r2, r7, #4		@ sub from r7 and set to s2 for space
        mov     r0, r1			@ Copy contents of r1 into r0
        mov 	r5, r1			@ also copy r1 to r5 to create backup to pull from
        mov     r1, r2			@ now copy r2 over r1
        blx      scanf			@ call scanf for first user hex num
	
	ldr	r6, = #8		@ For thumb mode to avoid value out of range error
	sub     r1, r7, r6		@ creates space between r7 for r1
	mov	r0, r5			@ copy r5 over r0			
        blx      scanf			@ call scanf for second user hex num

        ldr     r1, = sMenuOptions	@ load menu options string into r1
        mov     r0, r1			@ mov r1 over r0
        blx      printf			@ call printf to print menu options to screen

	ldr     r1, = cUserMenuInput	@ load cUserMenuInput into r1 to grab user input\
	ldr	r6, = #12
        sub     r2, r7, r6		@ sup 12 from r7 and put into r2
        mov     r0, r1			@ move r1 over r0
        mov     r1, r2			@ move r2 over r1
        blx      scanf			@ call scanf
	
	ldr	r6, = #-12
	ldr     r1, [r7, r6]		@ Load user input to r1 grabbing *(r10 -12)
        cmp     r1, #1			@ Compare r1 to the number one
        bne     CompareIfTwo		@ if not equal to 1 branch to CompareIfTwo
		
        ldr     r0, = sBinaryAndMessage	@ if user input = 1 Load message confirming binary and selected
        blx      printf			@ print the message
	ldr	r6, = #-4		@ I hate you thumb mode
        ldr     r0, [r7, r6]		@ loads *(r10, -4) for hex 1 user num into r0
	ldr	r6, = #-8
        ldr     r1, [r7, r6]		@ loads *(r10, -8) for hex 2 user num into r1
        bl     BinaryAnd		@ Branch with link to Binary And for calculation


CompareIfTwo:
	ldr	r6, = #-12	
        ldr     r0, [r7, r6]		@ Load user input to r0 grabbing (r7 -12)
        cmp     r0, #2			@ Compare r0 to num 2
        bne     CompareIfThree		@ If not equal branch to Compare if Three

        ldr     r0, = sBinaryOrMessage	@ If it is 2 load Message for Binary Or
        blx      printf			@ Display message to screen
	ldr	r6, = #-4
        ldr     r0, [r7, r6]		@ loads *(r7, -4) for hex 1 user num into r0
	ldr	r6, = #-8
        ldr     r1, [r7, r6]		@ loads *(r7, -8) for hex 2 user num into r1
        b      BinaryOr			@ Branch with link to Binary Or for calculation

CompareIfThree:
	ldr	r6, = #-12	
        ldr     r0, [r7, r6]		@ Load user input to r0 grabbing (r7 -12)
        cmp     r0, #3			@ Compare r0 to num 3
        bne     CompareIfFour		@ If not equal branch to Compare if Four

        ldr     r0, = sBinaryXorMessage	@ If it is 3 load Message for Binary Xor
        blx      printf			@ Display message to screen
	ldr	r6, = #-4
        ldr     r0, [r7, r6]		@ loads *(r7, -4) for hex 1 user num into r0
	ldr	r6, = #-8
        ldr     r1, [r7, r6]		@ loads *(r7, -8) for hex 2 user num into r1
        b      BinaryXor		@ Branch with link to Binary Xor for calculation

CompareIfFour:
	ldr	r6, = #-12	
        ldr     r0, [r7, r6]		@ Load user input to r0 grabbing (r7 -12)
        cmp     r0, #4			@ Compare r0 to num 4
        bne     BadInput		@ If not equal branch to Bad Input

        ldr     r0, = sBinaryBicMessage	@ If it is 4 load Message for Binary Bic
        blx      printf			@ Display message to screen
	ldr	r6, = #-4
        ldr     r0, [r7, r6]		@ loads *(r7, -4) for hex 1 user num into r0
	ldr	r6, = #-8
        ldr     r1, [r7, r6]		@ loads *(r7, -8) for hex 2 user num into r1
        b      BinaryBic		@ Branch with link to Binary Bic for calculation

BadInput:
	ldr r0, = sMenuBadInput		@ If match not found load message to chatise the user to try again 
	blx printf			@ print the chastisement to the screen so the user may feel bad
	@ldr r1, = Menu
	b Menu				@ If user input isn't 1-4 go back to start of Menu

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BinaryAnd:	@ All the Binary functions are total copies of each other one except for which registers they push and which
		@ bitwise operation they call. All functions will be commented, but most comments will be repeats

        push    {r4, lr}		@ Push r4 and LR onto the stack
        mov     r4, sp			@ Move value of SP over r4
        sub     sp, sp, #24		@ Sub 24 from SP to create space on the stack

	mov	r5, r0			@ Copy r0 which holds Hex num 1 into r5 to keep copy after bitwise op
	mov	r6, r1			@ Copy r1 which holds Hex num 2 into r6 to keep copy after bitwise op		
        and     r0, r0, r1		@ Perform And bitwise op on r1 and r0 and store result in r3
	mov	r3, r0

	mov	r1, r5			@ mov r5 to r1 in order to print hex num 1 as part of answer
	mov	r2, r6			@ mov r6 to r2 in order to print hex num 2 as part of answer
        ldr     r0, = sBinaryAddAnswer	@ load the Answer message into r0 for display
        blx      printf			@ print the message to the screen where r0 is the message, r1 is hex num 1, r2 
					@ is hex num 2, and r3 is the answer generated by the bitwise operation

        ldr     r0, = sMenuOrExit	@ Load message asking if user wants to perform another calculation or quit
        blx      printf			@ Print said message to screen

        ldr     r0, = cUserMenuInput	@ load cUserMenuInput var into r1
        add     r1, sp, #12		@ set r1 to be value of sp + 12
        blx      scanf			@ Branch with link to scanf to grab user input

        ldr     r1, [sp, #12]		@ Grab number by the offset we set
        cmp     r1, #1			@ Compare the input to 1
        bne     QuitProgram		@ If not equal branch to Quit Program
	b 	Menu

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BinaryOr:	@ All the Binary functions are total copies of each other one except for which registers they push and which
		@ bitwise operation they call. All functions will be commented, but most comments will be repeats

        push    {r7, lr}		@ Push r7 and LR onto the stack
        mov     r7, sp			@ Move value of SP over r7
        sub     sp, sp, #24		@ Sub 24 from SP to create space on the stack

	mov	r5, r0			@ Copy r0 which holds Hex num 1 into r5 to keep copy after bitwise op
	mov	r6, r1			@ Copy r1 which holds Hex num 2 into r6 to keep copy after bitwise op		
        orr     r0, r0, r1		@ Perform Or bitwise op on r1 and r0 and store result in r3
	mov	r3, r0

	mov	r1, r5			@ mov r5 to r1 in order to print hex num 1 as part of answer
	mov	r2, r6			@ mov r6 to r2 in order to print hex num 2 as part of answer
        ldr     r0, = sBinaryOrAnswer	@ load the Answer message into r0 for display
        blx      printf			@ print the message to the screen where r0 is the message, r1 is hex num 1, r2 
					@ is hex num 2, and r3 is the answer generated by the bitwise operation

        ldr     r0, = sMenuOrExit	@ Load message asking if user wants to perform another calculation or quit
        blx      printf			@ Print said message to screen

        ldr     r0, = cUserMenuInput	@ load cUserMenuInput var into r1
        add     r1, sp, #12		@ set r1 to be value of sp + 12
        blx      scanf			@ Branch with link to scanf to grab user input

        ldr     r1, [sp, #12]		@ Grab number by the offset we set
        cmp     r1, #1			@ Compare the input to 1
        bne     QuitProgram		@ If not equal branch to Quit Program
	b 	Menu

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BinaryXor:@ All the Binary functions are total copies of each other one except for which registers they push and which
		@ bitwise operation they call. All functions will be commented, but most comments will be repeats

        push    {r6, lr}		@ Push r6 and LR onto the stack
        mov     r6, sp			@ Move value of SP over r6
        sub     sp, sp, #24		@ Sub 24 from SP to create space on the stack

	mov	r5, r0			@ Copy r0 which holds Hex num 1 into r5 to keep copy after bitwise op
	mov	r6, r1			@ Copy r1 which holds Hex num 2 into r6 to keep copy after bitwise op		
        eor     r0, r0, r1		@ Perform Eor bitwise op on r1 and r0 and store result in r3
	mov	r3, r0

	mov	r1, r5			@ mov r5 to r1 in order to print hex num 1 as part of answer
	mov	r2, r6			@ mov r6 to r2 in order to print hex num 2 as part of answer
        ldr     r0, = sBinaryXorAnswer	@ load the Answer message into r0 for display
        blx      printf			@ print the message to the screen where r0 is the message, r1 is hex num 1, r2 
					@ is hex num 2, and r3 is the answer generated by the bitwise operation

        ldr     r0, = sMenuOrExit	@ Load message asking if user wants to perform another calculation or quit
        blx      printf			@ Print said message to screen

        ldr     r0, = cUserMenuInput	@ load cUserMenuInput var into r1
        add     r1, sp, #12		@ set r1 to be value of sp + 12
        blx      scanf			@ Branch with link to scanf to grab user input

        ldr     r1, [sp, #12]		@ Grab number by the offset we set
        cmp     r1, #1			@ Compare the input to 1
        bne     QuitProgram		@ If not equal branch to Quit Program
	b 	Menu

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BinaryBic:@ All the Binary functions are total copies of each other one except for which registers they push and which
		@ bitwise operation they call. All functions will be commented, but most comments will be repeats

        push    {r5, lr}		@ Push r5 and LR onto the stack
        mov     r5, sp			@ Move value of SP over r5
        sub     sp, sp, #24		@ Sub 24 from SP to create space on the stack

	mov	r5, r0			@ Copy r0 which holds Hex num 1 into r5 to keep copy after bitwise op
	mov	r6, r1			@ Copy r1 which holds Hex num 2 into r6 to keep copy after bitwise op		
        bic     r0, r0, r1		@ Perform Bic bitwise op on r1 and r0 and store result in r3
	mov	r3, r0

	mov	r1, r5			@ mov r5 to r1 in order to print hex num 1 as part of answer
	mov	r2, r6			@ mov r6 to r2 in order to print hex num 2 as part of answer
        ldr     r0, = sBinaryBicAnswer	@ load the Answer message into r0 for display
        blx      printf			@ print the message to the screen where r0 is the message, r1 is hex num 1, r2 
					@ is hex num 2, and r3 is the answer generated by the bitwise operation

        ldr     r0, = sMenuOrExit	@ Load message asking if user wants to perform another calculation or quit
        blx      printf			@ Print said message to screen

        ldr     r0, = cUserMenuInput	@ load cUserMenuInput var into r1
        add     r1, sp, #12		@ set r1 to be value of sp + 12
        blx      scanf			@ Branch with link to scanf to grab user input

        ldr     r1, [sp, #12]		@ Grab number by the offset we set
        cmp     r1, #1			@ Compare the input to 1
        bne     QuitProgram		@ If not equal branch to Quit Program
	b 	Menu

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

QuitProgram:
        blx      exit			@ Branch to exit op

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ The rest of the file contents are the two input variables followed by the strings used for messages in the program

sUserHexInput:
        .asciz  "%x"

cUserMenuInput:
        .asciz  "%x"

sWelcome: 	
        .asciz  "Hello, welcome to the Binary Logic Calculator, please enter 2 32-bit Hexadecimal numbers (8 digits)\n"

sMenuOptions:
        .asciz  "Please choose from the following:\nEnter 1 for Binary And, 2 for Binary Or, 3 for Exclusive Or, and 4 for Binary Bitclear\n"

sBinaryAndMessage:
        .asciz  "Going to Binary And\n"

sBinaryOrMessage:
        .asciz  "Going to Binary Or\n"

sBinaryXorMessage:
        .asciz  "Going to Binary Exclusive Or\n"

sBinaryBicMessage:
        .asciz  "Going to Binary Bitclear\n"

sMenuBadInput:
	.asciz	"Please enter a valid number\n\n"

sBinaryAddAnswer:
        .asciz  "The Binary And of %x and %x is: %x\n"

sMenuOrExit:
        .asciz  "Enter 1 to continue, anything else to quit.\n"

sBinaryOrAnswer:
        .asciz  "The Binary Or of %x and %x is: %x\n"

sBinaryXorAnswer:
        .asciz  "The Binary Exclusive Or of %x and %x is: %x\n"

sBinaryBicAnswer:
        .asciz  "The Binary Bitclear of %x and %x is: %x\n"
