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
	
	ret
Roll2Dice ENDP


; Process the roll and update the board state
ProcessRoll PROC


	


	ret
ProcessRoll ENDP


; Game setup and main loop calling Roll2Dice and ProcessRoll
main PROC




	exit
main ENDP

END main

