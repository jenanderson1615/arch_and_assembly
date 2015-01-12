TITLE Program 4~ Prime Numbers			(Program4.asm)

; Program Description:
; Author: Jen Anderson
; Date Created: 7/27/13
; Last Modification Date: 08/04/13

INCLUDE Irvine32.inc


;constants
UPPER_LIMIT = 200
LOWER_LIMIT = 1  

.data

info_Message_1	BYTE	"This is the Prime Numbers program by Jen Anderson.", 0
info_Message_2	BYTE	"Enter a number between 1 and 200 when prompted, ", 0
info_Message_3	BYTE	"and the program will show you that many prime numbers. ", 0
user_Prompt	BYTE	"Enter how many prime numbers you want displayed (between 1 and 200): ",0
not_In_Range	BYTE	"That number was not between 1 and 200.  Try again.", 0
current_Number	DWORD	2, 0
prime_Counter	DWORD	1, 0
loop_Counter	DWORD	1, 0
in_Line_Counter	DWORD	0, 0
number_Is_Prime	DWORD	0, 0 ;set to 1 if the number is a prime and remains 0 if number isn't prime
output_Message_1	BYTE	"Here are the first ", 0
output_Message_2	BYTE " prime numbers: ", 0
three_Spaces	BYTE	"   ", 0
user_Input	DWORD	?, 0
farewell_Message	BYTE	"Thanks for using the Prime Numbers program.  Goodbye!", 0
temp_Number	DWORD	0,0
divide_Counter	DWORD	0,0

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Calls the procedures to allow the program to run
;Receives: None
;Returns: None
;Preconditions: None
;Registers Changed: None
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main PROC

	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL farewell

exit		; exit to operating system
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Displays the introduction to the user
;Receives: None
;Returns: None
;Preconditions: None
;Registers Changed: EDX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
introduction PROC
	mov	edx, OFFSET	info_Message_1
	call	WriteString
	call CrLF
	call CrLF
	mov	edx, OFFSET	info_Message_2
	call	WriteString
	call	CrLF
	mov	edx, OFFSET	info_Message_3
	call	WriteString
	call CrLF
	call CrLF
	RET
introduction ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Gets the user's input
;Receives: A user input integer
;Returns: An integer within the correct range
;Preconditions: None
;Registers Changed: EDX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getUserData PROC
	mov	edx, OFFSET	user_Prompt
	call	WriteString
	call ReadInt
	mov	user_Input, eax
	call	CrLF
	call validate
	RET
getUserData	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Validates that the user input is between 1 and 200
;Receives: The user input integer
;Returns: Returns to the top of the getUserData if input is wrong.  Returns to the end of
;	     this method if the input is correct
;Preconditions: None
;Registers Changed: EAX, EDX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
validate PROC
	mov	eax, user_Input
	cmp	eax, UPPER_LIMIT
	jg	incorrectRange
	cmp eax, LOWER_LIMIT
	jl	incorrectRange
	jmp	correctRange

	incorrectRange:
		mov	edx, OFFSET not_In_Range
		call WriteString
		call CrLF
		CALL getUserData

	correctRange:
		RET
	
validate	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Displays primes with three spaces in between, ten to a line
;Receives: The user input variable
;Returns: None
;Preconditions: The user input is an integer between 1-200
;Registers Changed: EDX, EAX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showPrimes	PROC
	mov	edx, OFFSET	output_Message_1
	call	WriteString
	mov	eax, user_Input
	call	WriteDec
	mov	edx, OFFSET	output_Message_2
	call	WriteString
	call	CrLF

	;prints 2 because 2 is the first prime (and the program requires
	;at least 1 prime) and 2 doesn't follow the rules in isPrime
	mov	eax, current_Number
	call	WriteDec
	mov	edx, OFFSET three_Spaces
	call	WriteString
	mov	eax, in_Line_Counter
	add	eax, 1
	mov	in_Line_Counter, eax

	get_Next_Number_Loop:

	;increment current_Number
	mov	eax, current_Number
	add	eax, 1
	mov	current_Number, eax

	call isPrime

	mov	eax, number_Is_Prime
	cmp	eax, 0
	je	get_Next_Number_Loop
	mov	eax, in_Line_Counter
	cmp	eax, 10
	je	need_New_Line
	
	;print current and increment prime_Counter
	mov	eax, current_Number
	call	WriteDec
	mov	edx, OFFSET three_Spaces
	call	WriteString 
	mov	eax, prime_Counter
	add	eax, 1
	mov	prime_Counter, eax
	mov	eax, in_Line_Counter
	add	eax, 1
	mov	in_Line_Counter, eax
	jmp	keep_Printing_Or_End

	need_New_Line:
	call	CrLF
	mov	eax, current_Number
	call	WriteDec
	mov	edx, OFFSET three_Spaces
	call	WriteString 
	mov	eax, prime_Counter
	add	eax, 1
	mov	prime_Counter, eax
	mov	in_Line_Counter, 1

	keep_Printing_Or_End:
	;decide if done printing primes or continues
	mov	eax, prime_Counter
	cmp	eax, user_Input
	je	return
	jmp	get_Next_Number_Loop

	return: 
	RET
showPrimes	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Determines if the current number is prime
;Receives: The current number
;Returns: 1 if the number is prime, 0 if the number is not prime
;Preconditions: Current number is an integer between 1 and 200
;Registers Changed: EAX, EDX, EBX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
isPrime	PROC

	mov	loop_Counter, 2 ;initialize the loop_Counter to 2
	mov	number_Is_Prime, 0 ;initialize number is prime to false
	
	top_Of_Loop:
		mov	eax, loop_Counter
		cmp	eax, current_Number
		je	prime_Number ;if we reach the end of the loop, we can assume the number is a prime
		
		;divide the current number by all the numbers 2 - (currentNumber - 1)
		mov	edx, 0
		mov	eax, current_Number
		mov	ebx, loop_Counter
		div	ebx

		;if the number is divided by anything from 2 to currentNumber -1 without a remainder, number is not a prime
		cmp	edx, 0
		je	not_A_Prime

		;if the remainder doesn't equal zero, increment the loop counter and return to the top
		mov	eax, loop_Counter
		add	eax, 1
		mov	loop_Counter, eax
		jmp	top_Of_Loop

	not_A_Prime:
		mov	number_Is_Prime, 0
		RET

	prime_Number:
		mov	number_Is_Prime, 1
		RET

isPrime	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Description: Displays the farewell message to the user
;Receives: None
;Returns: None
;Preconditions: None
;Registers Changed: EDX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
farewell	PROC
	call	CrLF
	mov	edx, OFFSET	farewell_Message
	call	WriteString
	call	CrLF
	RET
farewell	ENDP

END main
