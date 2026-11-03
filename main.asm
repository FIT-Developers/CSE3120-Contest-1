; -----------------------------------------------------------------------
; Program: Across the Board - Horse Race Betting Game
; Authors: Michael Woodyard & Kelsey Hahn
; Class:   CSE3120
; -----------------------------------------------------------------------


INCLUDE Irvine32.inc


; -----------------------------------------------------------------------
; Data: Global variables, arrays, and board status
; -----------------------------------------------------------------------

.data
	;Dice values
	die1 DWORD ?  ; stores the first dice (1-6)
	die2 DWORD ?  ; stores the second dice (1-6)
	diceTotal DWORD ?  ; stores their sum (2-12)

	; Messages for displaying dice rolls
	die1Msg BYTE "First die: ", 0
	die2Msg BYTE "Second die: ", 0
	totalMsg BYTE "Total roll: ", 0

	; Board state and track variables
	horsePositions DWORD 11 DUP(0)  ; array to hold the positions of 11 horses on the track
	trackLengths DWORD 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3  ; lengths of each horse's track segment
	scratchedFlags BYTE 11 DUP(0)  ; 0 is active, 1 is scratched


; -----------------------------------------------------------------------
; Code: Routines for rolling dice, processing rolls, and main game loop
; -----------------------------------------------------------------------

.code

; Roll two dice and return the result
Roll2Dice PROC
	; Roll the first dice
	mov eax, 6
	call RandomRange
	inc eax
	mov die1, eax

	; Roll the second die
	mov eax, 6
	call RandomRange
	inc eax
	mov die2, eax

	; Calculate the dice Total
	mov eax, die1
	add eax, die2
	mov diceTotal, eax


	; Display the results

	; Load the memory address of die1Msg into EDX and print it
	mov edx, OFFSET die1Msg
	; Prints null-terminated string pointed to by EDX
	call WriteString
	mov eax, die1
	; Prints the decimal value in EAX
	call WriteDec
	; Prints a new line
	call Crlf

	; Load the memory address of die2Msg into EDX and print it
	mov edx, OFFSET die2Msg
	call WriteString
	mov eax, die2
	call WriteDec
	call Crlf

	; Load the memory address of totalMsg into EDX and print it
	mov edx, OFFSET totalMsg
	call WriteString
	mov eax, diceTotal
	call WriteDec
	call Crlf


	ret
Roll2Dice ENDP


; Process the roll and update the board state
ProcessRoll PROC
	; Convert the dice total to a horse index (0-10)
	mov esi, diceTotal
	sub esi, 2  ; adjusts for the zero-based index (dice total ranges from 2 to 12)

	; Check if the horse is scratched (1) or active (0)
	cmp scratchedFlags[esi], 1
	je horseScratched  ; if scratched, jump to horseScratched

	; If active, increment the horse's position on the track
	inc horsePositions[esi * 4]
	jmp Done


	; Scratched horse handling
	horseScratched:


	; Display a message indicating the horse is scratched
	Done:
		

		ret
ProcessRoll ENDP


; Check if any active horse has reached or exceeded its finish line
; Returns 1 in EAX if a horse has won, otherwise returns 0
; ESI is used as the index for the horse being checked (0-10)
CheckWinConditions PROC
	; Loop through each horse to check their positions
	mov esi, 0  ; total number of horses

	; Loop through each horse
	CheckLoop:
		cmp esi, 11  ; check if all horses have been checked
		je NoWinner  ; if all horses checked, no winner

		; Skip scratched horses
		cmp scratchedFlags[esi], 1
		je NextHorse  ; if scratched, skip to the next horse


		; Compare the horse's position with its track length
		mov eax, horsePositions[esi * 4]  ; get the horse's current position
		cmp eax, trackLengths[esi * 4]  ; compare with the track length
		jge WinnerFound  ; if position >= track length, we have a winner

	
	; Increments the index to check the next horse
	NextHorse:
		inc esi
		jmp CheckLoop  ; repeat the loop for the next horse

	
	; Set win flag to true if no winner is found
	WinnerFound:
		mov eax, 1  ; set EAX to 1 indicating a winner has been found
		ret


	; If no winner is found, set win flag to false
	NoWinner:
		mov eax, 0  ; set EAX to 0 indicating no winner
		ret

CheckWinConditions ENDP


; Game setup and main loop calling Roll2Dice and ProcessRoll
main PROC

	; Seed the random number generator
	call Randomize
	; Roll the dice and display the results
	call Roll2Dice
	; Process the roll and update the board state
	call ProcessRoll



exit
main ENDP

END main

