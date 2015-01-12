TITLE Random Integer Sorter			(Program5.asm)

; Program Description: Asks the user for a number between 10 and 200, then takes this input and creates
;				   an array with that many random numbers.  The median value is then displayed and 
;				   the same array is sorted and displayed
; Author: Jen Anderson
; Date Created: 08/05/13
; Last Modification Date: 08/18/13

INCLUDE Irvine32.inc

;constants
RANGE_MIN = 10
RANGE_MAX = 200
RANDOM_LOW = 100
RANDOM_HIGH	= 999

.data

;;;;;;;;
;Strings
;;;;;;;;

intro_Message_1	BYTE	"This is the Random Integer Sorter program by Jen Anderson.", 0
intro_Message_2	BYTE	"Enter a number between 10 and 200 when prompted ", 0
intro_Message_3	BYTE	"and the program will show that many random numbers, ", 0
intro_Message_4	BYTE	"the median of those numbers, ",0
intro_Message_5	BYTE	"and the ordered list of the random numbers.",0
user_Prompt_1		BYTE	"Enter how many entries you want in your random number list", 0
user_Prompt_2		BYTE "(between 10 and 200): ",0
not_In_Range		BYTE	"That number was not between 10 and 200.  Try again.", 0
four_Spaces		BYTE "    ", 0
results_Message_1	BYTE "The ", 0
results_Message_2	BYTE	" list of integers: ", 0
sorted_Message		BYTE "sorted", 0
unsorted_Message	BYTE	"unsorted", 0
median_Message		BYTE	"The median of this list is ", 0
period			BYTE ".", 0

;;;;;;;;
;Numbers
;;;;;;;;	

request			DWORD	?
array			DWORD	200	DUP(?) ;;each position takes up 4 bytes
range			DWORD	(RANDOM_HIGH-RANDOM_LOW) + 1
array_Title		DWORD	0
in_Line_Counter	DWORD	0
position_1		DWORD	0
position_2		DWORD	0
loop_Counter		DWORD	0
array_At_Lp_Counter	DWORD	0
array_At_Position_1	DWORD	0
array_At_Position_2	DWORD	0
median			DWORD	0
position_Of_Median	DWORD	0


.code
main PROC
	
	;initial randomize function call
	CALL randomize

	CALL introduction

	;get user input section
	push OFFSET request;
	CALL getData

	;push result and array onto stack and fill
	push OFFSET array
	push request
	call fillArray

	;display list before being sorted
	push	OFFSET array
	push	OFFSET array_Title
	push in_Line_Counter
	push request
	call displayList

	call CrLF

	push OFFSET	array
	push	request
	push	array_At_Lp_Counter
	push	loop_Counter
	push	OFFSET array_At_Position_2
	push	position_2
	push	OFFSET array_At_Position_1
	push	position_1
	call sortList

	push	OFFSET	array
	push	position_Of_Median
	push	request
	call displayMedian

	;set array_Title to 1
	mov	eax, array_Title
	mov	eax, 1
	mov	array_Title, eax

	;display sorted list
	push	OFFSET array
	push OFFSET array_Title
	push	in_Line_Counter
	push request
	call displayList

	call CrLF

	exit		; exit to operating system
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Displays the introduction.
; Receives: intro_Message_1
;		  intro_Message_2
;		  intro_Message_3
;		  intro_Message_4
;		  intro_Message_5
; Returns:  None
; Preconditions: None
; Registers Changed: edx
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

introduction	PROC

	mov	edx, OFFSET intro_Message_1
	call WriteString
	call CrLF
	mov	edx, OFFSET intro_Message_2
	call WriteString
	call CrLF
	mov	edx, OFFSET intro_Message_3
	call WriteString
	call CrLF
	mov	edx, OFFSET intro_Message_4
	call WriteString
	call CrLF
	mov	edx, OFFSET intro_Message_5
	call WriteString
	call CrLF
	call CrLF
	RET 

introduction	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Gets a user integer and makes sure its in the correct range.
; Receives: (empty) request DWORD
; Returns: request DWORD with a value
; Preconditions: None
; Registers Changed: edx, eax
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

getData	PROC
	
	;puts ebp on the stack and copies the pointer onto ebp
	push ebp
	mov ebp, esp

	;puts address of request into esi
		mov	esi, [ebp + 8]

	inputSection:
		
		;instructions
		mov	edx, OFFSET user_Prompt_1
		call	WriteString
		call CrLF
		mov	edx, OFFSET user_Prompt_2
		call WriteString
		call CrLF

		;puts the user integer into the address of request
		mov eax, [esi]	;puts address of request into eax
		call	ReadInt
		mov [esi], eax  ;stores the user's int in address of request

		;see if user request is in the right range
		mov	eax, [esi]
		cmp	eax, RANGE_MIN
		jl not_In_Range_Section
		cmp	eax, RANGE_MAX
		jg not_In_Range_Section
		jmp returnSection

	not_In_Range_Section:
	
		;tell the user their request was not in the range
		mov	edx, OFFSET not_In_Range
		call WriteString
		call CrLF
		jmp inputSection

	returnSection:

		;return the stack to the same it was before the procedure
		pop ebp
		ret 4

getData	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Fills an array of size request with random values
; Receives: request (user defined array size)
;	       array address (previously defined in the data section array)
; Returns: the filled array
; Preconditions: Request is in the appropriate range.  
; Registers Changed: EDI, ECX
;	(Possibly working, need to write print array to see)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fillArray	PROC
	push	ebp
	mov	ebp, esp

	mov	edi, [ebp + 12]
	mov	ecx, [ebp + 8]

	generateRandoms:
		mov eax, range
		call randomrange
		add eax, RANDOM_LOW
		mov [edi], eax
		add edi, 4

	Loop generateRandoms

	pop ebp
	ret 8

fillArray	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Calculates and displays the median
; Receives: request (user defined array size)
;	       array (previously defined in the data section array)
; Returns: prints the median message and the medians
; Preconditions: The array has already been sorted.  
; Registers Changed: esi, edx, eax, ebx
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

displayMedian	PROC

	push ebp
	mov	ebp, esp

	;address of first element of the array onto esi
	mov	esi, [ebp + 16]

	;divide request by 2 and put into position of median variable
	mov	edx, 0
	mov	eax, [ebp + 8]
	mov	ebx, 2
	div	ebx
	mov	[ebp + 12], eax

	;multiply position of median variable by 4 to get the number of array positions to move
	mov	ebx, 4
	mul	ebx

	;get the value at the array position of the median into eax
	mov	ebx, [esi + eax]
	mov	eax, ebx

	;display median message
	mov	edx, OFFSET median_Message
	call WriteString
	call WriteDec
	mov	edx, OFFSET period
	call WriteString
	call CrLF
	call CrLF

	pop	ebp
	ret 12
displayMedian	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Sorts the given array in a reverse order
; Receives: request (user defined array size)
;	       array (previously defined in the data section array)
; Returns: the array it was given as a parameter in a sorted order
; Preconditions: The appropriate variables are on the stack in the right order
; Registers Changed: esi, eax, ebx, edx
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sortList	PROC
	
	push ebp
	mov	ebp, esp

	mov	esi, [ebp + 36] ;address of position 1 is in esi
	
	outsideLoop:

		;compare loop counter and count - 1.  if count-1 is bigger, end loop
			mov	eax, [ebp + 24]	;put loop_counter variable into eax
			mov	ebx, [ebp + 32]	;put count into ebx
			dec	ebx				;ebx holds count-1
			cmp	eax, ebx
			jge	breakLoop

		;set position 1 to the loop_counter
			mov	eax, [ebp + 8]
			mov	ebx, [ebp + 24]
			mov	eax, ebx
			mov	[ebp + 8], eax

		;set position 2 equal to loop_counter + 1
			mov	eax, [ebp + 16]	;position 2
			mov	ebx, [ebp + 24]	;loop_counter
			inc	ebx
			mov	eax, ebx
			mov	[ebp + 16], eax
	
	insideLoop:
		
		;compare position2 to count.  if pos 2 is less than count, jump to if_Statement.  
		;if position 2 is equal to or greater than count, jump to exchange call
			mov	eax, [ebp + 16]	;position2
			mov	ebx, [ebp + 32]	;count
			cmp	eax, ebx
			jl	if_Statement
			jge	exchange_Call

	if_Statement:		;compare array[position2] to array[position1]
		;set array[position1] global variable
			mov	eax, [ebp + 8]
			mov	edx, 4
			mul	edx
			mov	ebx, [esi + eax]
			mov	edx, [ebp + 12]
			mov	[edx], ebx	
		;set array[position2] global variable
			mov	eax, [ebp + 16]
			mov	edx, 4
			mul	edx
			mov	ebx, [esi + eax]
			mov	edx, [ebp + 20] 
			mov	[edx], ebx
		;move array[position2] to eax
			mov	edx, [ebp + 20] 
			mov	eax, [edx]	
		;move array[position1] to ebx
			mov	edx, [ebp + 12]
			mov	ebx, [edx]
		;compare the values and jump accordingly
			cmp	eax, ebx				
			jg	set_pos1_to_pos2
			jle	inside_Loop_Control

	set_pos1_to_pos2:		
		mov	eax, [ebp + 8]		;position1
		mov	ebx, [ebp + 16]	;position2
		mov	eax, ebx
		mov	[ebp + 8], eax
		jmp	inside_Loop_Control

	inside_Loop_Control:		;increment position 2 and jump to inside loop
		mov	eax, [ebp + 16]
		inc	eax
		mov	[ebp + 16], eax
		jmp insideLoop

	exchange_Call:
		;set array_At_Loop_Counter global variable
			mov	eax, [ebp + 24]
			mov	edx, 4
			mul	edx
			mov	ebx, [esi + eax]
			mov	[ebp + 28], ebx
		;set	array_At_Position_1 global variable
			mov	eax, [ebp + 8]
			mov	edx, 4
			mul	edx
			mov	ebx, [esi + eax]
			mov	edx, [ebp + 12]
			mov	[edx], ebx
		call exchange

	;increment loop counter, and jump to top of outside loop
		mov	eax, [ebp + 24]
		inc	eax
		mov	[ebp + 24], eax
		jmp outsideLoop

	breakLoop:
		pop ebp
		ret 32
sortList	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Exchanges two array elements 
; Receives: array (previously defined in the data section array)
;		  position1
;		  position2
; Returns: the array with the two values exchanged
; Preconditions: The values to be exchanged are placed on the stack at [ebp + 32] and [ebp + 20]
; Registers Changed: edx, eax
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exchange	PROC	

	push ebp
	mov ebp, esp

	mov	esi, [ebp + 44]	;address of first value in array

	;move array[position_1] into ebx
		mov	edx, [ebp + 20]
		mov	ebx, [edx]

	;move ebx into array + loop_Counter
		mov	eax, [ebp +32]		;loop_Counter into ebx
		mov	edx, 4
		mul	edx
		mov	[esi + eax], ebx	;move array[position_1] into (array + loop_Counter*4)

	;move array[loop_Counter] into ebx
		mov	ebx, [ebp + 36]

	;move ebx into array + position_1
		mov	eax, [ebp + 16]		;position_1 into eax
		mov	edx, 4
		mul	edx
		mov	[esi + eax], ebx		;move array[loop_Counter] into (array + position_1*4)

	pop ebp
	ret 
exchange	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
; Description: Determines if the sorted or unsorted array should be displayed
;			Displays the appropriate array 
; Receives: request (user defined array size)
;	       array (previously defined in the data section array)
		  title (either 1 or 0 depending on whether the list is sorted or unsorted)
; Returns: none, but the array is displayed
; Preconditions: The array has already been filled
; Registers Changed: ecx, ebx, eax, edx
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
displayList	PROC
	push ebp
	mov	ebp, esp

	mov	esi, [ebp + 20] ;address of first element of the array
	mov	ecx, [ebp + 8]
	mov	ebx, [ebp + 16] ;address of array title

	;print the array message with appropriate title
	
		;decide which list it is
			mov	eax, [ebx]
			mov	ebx, 0
			cmp	eax, 1
			je sorted

		unsorted:
			call CrLF
			mov	edx, OFFSET	results_Message_1
			call WriteString
			mov	edx, OFFSET	unsorted_Message
			call WriteString
			jmp end_Of_Message

		sorted:
			mov	edx, OFFSET	results_Message_1
			call WriteString
			mov	edx,	OFFSET	sorted_Message
			call WriteString

		end_Of_Message:
			mov	edx, OFFSET	results_Message_2
			call WriteString
			call CrLF
			call CrLF

	printLoop:
		;decide if there's 10 or less than 10 values in a line
		mov	eax, [ebp + 12]
		cmp	eax, 10
		je need_New_Line

	no_New_Line:
		mov	eax, [ebp + 12]
		inc	eax
		mov	[ebp + 12], eax
		jmp print_Value
		
	need_New_Line:
		call CrLF
		mov	eax,	[ebp + 12]
		mov	eax, 1
		mov	[ebp + 12], eax
		jmp print_Value

	print_Value: 
		mov	eax, [esi]
		call WriteDec
		mov	edx, OFFSET	four_Spaces
		call WriteString

	loop_Control:
		add esi, 4
		Loop printLoop

		;set in_Line_Counter back to 0
		mov	eax, [ebp + 12]
		mov	eax, 0
		mov	[ebp + 12], eax

		call CrLF
		pop ebp
		ret 16
displayList	ENDP

END main
