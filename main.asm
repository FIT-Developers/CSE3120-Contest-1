; -----------------------------------------------------------------------
; Program: Across the Board - Horse Race Betting Game
; Authors: Michael Woodyard & Kelsey Hahn
; Class:   CSE3120
; -----------------------------------------------------------------------


INCLUDE Irvine32.inc


; Win32 API for console audio
Beep PROTO dwFreq:DWORD, dwType:DWORD


; -----------------------------------------------------------------------
; Data: Global variables, arrays, and board status
; -----------------------------------------------------------------------

.data
	;Dice values
	die1      DWORD ?  ; stores the first dice (1-6)
	die2      DWORD ?  ; stores the second dice (1-6)
	diceTotal DWORD ?  ; stores their sum (2-12)

	; Messages for displaying dice rolls
	die1Msg  BYTE "First die: ", 0
	die2Msg  BYTE "Second die: ", 0
	totalMsg BYTE "Total roll: ", 0
	colonMsg BYTE ": ", 0

	; Board state and track variables
	horsePositions    DWORD 11 DUP(0)  ; array to hold the positions of 11 horses on the track
	trackLengths      DWORD 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3  ; lengths of each horse's track segment
	scratchedFlags    BYTE 11 DUP(0)  ; 0 is active, 1 is scratched
	scratchCount      DWORD 0  ; Number of unique scratched horses
	scratchedMsg      BYTE " (SCRATCHED)", 0
	scratchPenaltyMsg BYTE " -> SCRATCHED! 1 chip added to the pot!", 0Dh, 0Ah, 0

	; Pot and chip variables
	potTotal     DWORD 20  ; total amount in the pot
	playerChips  DWORD 20, 20, 20, 20  ; each player's available chips
	potHeaderMsg BYTE "Current pot: ", 0

	; Scratched horse penalty tracking
	wasScratchedRolled BYTE 0  ; 0 = no, 1 = yes

	; Pot and payout messages
	payoutMsg      BYTE "Winner! Payout: ", 0
	chipsMsg       BYTE " chips.", 0
	horseWinnerMsg BYTE "Horse #", 0
	wonMsg         BYTE " has won the race!", 0Dh, 0Ah, 0

	; Winning horse tracking variable
	winningHorse DWORD ?

	; Betting variables and prompts
	selectedHorse DWORD ? ; horse chosen by the player
	playerBet     DWORD ? ; amount of chips bet by the player

	promptHorseMsg  BYTE "Select a horse to bet on (2-12): ", 0
	promptBetMsg    BYTE "Enter your bet amount. Chips available: ", 0
	invalidHorseMsg BYTE "Invalid horse selection! Horse is scratched or out of range.", 0Dh, 0Ah, 0
	invalidBetMsg   BYTE "Invalid bet amount! You don't have enough chips.", 0Dh, 0Ah, 0

	
	; 3D ASCII banner
	largeBanner BYTE "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=", 0Dh, 0Ah
				BYTE "                                                                                                                                                       ",       0Dh, 0Ah
				BYTE "     $$$$$$\                                                       $$$$$$$$\ $$\                       $$$$$$$\                                      $$\",      0Dh, 0Ah
				BYTE "    $$  __$$\                                                      \__$$  __|$$ |                      $$  __$$\                                     $$ |",     0Dh, 0Ah
				BYTE "    $$ /  $$ | $$$$$$$\  $$$$$$\   $$$$$$\   $$$$$$$\  $$$$$$$\       $$ |   $$$$$$$\   $$$$$$\        $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$$ |",     0Dh, 0Ah
				BYTE "    $$$$$$$$ |$$  _____|$$  __$$\ $$  __$$\ $$  _____|$$  _____|      $$ |   $$  __$$\ $$  __$$\       $$$$$$$\ |$$  __$$\  \____$$\ $$  __$$\ $$  __$$ |",     0Dh, 0Ah
				BYTE "    $$  __$$ |$$ /      $$ |  \__|$$ /  $$ |\$$$$$$\  \$$$$$$\        $$ |   $$ |  $$ |$$$$$$$$ |      $$  __$$\ $$ /  $$ | $$$$$$$ |$$ |  \__|$$ /  $$ |",     0Dh, 0Ah
				BYTE "    $$ |  $$ |$$ |      $$ |      $$ |  $$ | \____$$\  \____$$\       $$ |   $$ |  $$ |$$   ____|      $$ |  $$ |$$ |  $$ |$$  __$$ |$$ |      $$ |  $$ |",     0Dh, 0Ah
				BYTE "    $$ |  $$ |\$$$$$$$\ $$ |      \$$$$$$  |$$$$$$$  |$$$$$$$  |      $$ |   $$ |  $$ |\$$$$$$$\       $$$$$$$  |\$$$$$$  |\$$$$$$$ |$$ |      \$$$$$$$ |",     0Dh, 0Ah
				BYTE "    \__|  \__| \_______|\__|       \______/ \_______/ \_______/       \__|   \__|  \__| \_______|      \_______/  \______/  \_______|\__|       \_______|",     0Dh, 0Ah
				BYTE "                                                                                                                                                       ",       0Dh, 0Ah
				BYTE "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=", 0Dh, 0Ah, 0

	; 3D ASCII horse art
	horseArt BYTE " ", 0Dh, 0Ah
			 BYTE "                                                                                                   $                $$",                                    0Dh, 0Ah
			 BYTE "                                                                                                   $.$             $$$",                                    0Dh, 0Ah
			 BYTE "                                                                                                 $$$$$           $$$$",                                     0Dh, 0Ah
			 BYTE "                                                                                                    /$$   $$$$   _.$$$$",                                   0Dh, 0Ah
			 BYTE "                                                                                                    /$$$$ $$$$$$$$-$$$  -",                                 0Dh, 0Ah
			 BYTE "                                                                                                      $\    $  $ -  $$",                                    0Dh, 0Ah
			 BYTE "                                                                                                   $$   $   $$$.    $$  $$",                                0Dh, 0Ah
			 BYTE "                                                                                                 $$$ $$$- $$       $    $$$$$$    .",                       0Dh, 0Ah
			 BYTE "                                           $                                                   $$-$$$$$$$_        || ._    $$      $$$-",                   0Dh, 0Ah
			 BYTE "                                          $$              $-$                               $ $$-$$$.     $$       $$      $$      $$$$$$",                 0Dh, 0Ah
			 BYTE "                                         $$$$.$         $$$-$                            $   $$$           $        $       $$      $$$$$$$$$",             0Dh, 0Ah
			 BYTE "                                         $$$$ |      $ $ $$ $                            $_  $                $$$$.       \$$$      $\  $$$$$$ $$",         0Dh, 0Ah
			 BYTE "                                          $$$ $$$$$$$$ $$$$.                                                              $         $/$$$ $ $$ $$$$$$",     0Dh, 0Ah
			 BYTE "                                       .  $$  |_$$$      $$                            $$$$ $$$$                 |      $-$|$$      $ $.$_$$$$ $$  /$",     0Dh, 0Ah
			 BYTE "                                          $$      -$        $                          _$-\ -$$- $             $      _ / $ -$      | $ $ \$$/ -- \.$",     0Dh, 0Ah
			 BYTE "                                    .   $$$$/$    $    $  $$  $$$ $|$                       $$    $    $.$-$       $     $$$$ .    $$      _$/$/$$$$ $$$$", 0Dh, 0Ah
			 BYTE "                           $$$    $ $$     $           |$$$ $_$_$$                    /            / $$$       $$$ $$        $$       . $\$$$$ $$$",        0Dh, 0Ah
			 BYTE "                       $.$_$$      $$       /       $$      $_$ $$ \                 $ $              $$$ $$$$|$             $             $$$ ",           0Dh, 0Ah
			 BYTE "                   $$$|$.$-$      $$       $    $   $           $$$   $            /                  $$  \$$               $",                             0Dh, 0Ah
			 BYTE "            -$$$$ $$$/ $  _$       $ $                                        $         $$/               $$$             $$",                              0Dh, 0Ah
			 BYTE "           $$$  \ $$$$$$_$\$      $$.$\$                      __$$$$ $$$$     $        $$$$               $$$$       -  $|$$",                              0Dh, 0Ah
			 BYTE "             $$$$ $$$$/$.$-       $      $$$$    $$         $\$    /    $_    $          $           $$$$ $$          $ $\$$$",                             0Dh, 0Ah
			 BYTE "              $$$ $$$$$$.|      -$$        $$ $/$   $   .$$ $        $   |     $$            $$/                        $$$$$",                             0Dh, 0Ah
			 BYTE "               $$ $$$             $             $$$$$$ $$$              $ $        -     $    $                         $$$$$",                             0Dh, 0Ah
			 BYTE "                                   $               $$    $                              $$$ $                             $$$",                             0Dh, 0Ah
			 BYTE "                                   |               $$\   $                                                                 _/",                             0Dh, 0Ah
			 BYTE "                                   $$              $$$ $$                $     $                                           $$$",                            0Dh, 0Ah
			 BYTE "                                    $$             $$$            $  $$$         $                                          $$",                            0Dh, 0Ah
			 BYTE "                                  $ $$$$.          $$$            $  $$$$        $                                           $$/",                          0Dh, 0Ah
			 BYTE "                                   $$$$$ $$$.     _$$$ $$$$          $$ .        $",                                                                        0Dh, 0Ah
			 BYTE "                                  $$$$$                        $ $             $",                                                                          0Dh, 0Ah
			 BYTE "                                   $$$$$                         $            \",                                                                           0Dh, 0Ah
			 BYTE "                                   $$$                             $ $$$",                                                                                  0Dh, 0Ah
			 BYTE "                                   $$",                                                                                                                     0Dh, 0Ah
			 BYTE "                                  $$",                                                                                                                      0Dh, 0Ah
			 BYTE " ", 0Dh, 0Ah
			 BYTE "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=",
			 BYTE " ", 0Dh, 0Ah, 0

	; Prompt message for user input
	promptMsg BYTE "Press any key to roll the dice...", 0

	; Message for displaying how many pegs were advanced
	trackPegMsg BYTE " peg(s) advanced", 0

	; Visual Track Symbols
	openBracket    BYTE " [", 0
	closeBracket   BYTE "] ", 0
	horseCharacter BYTE "H", 0
	spaceCharacter BYTE " ", 0

	; Messages for displaying that the game is over
	gameOverMsg BYTE "--- GAME OVER! Thanks for playing! ---", 0

	; Play again prompt message
	playAgainMsg BYTE "Would you like to play again? (Y/N): ", 0



; -----------------------------------------------------------------------
; Code: Routines for rolling dice, processing rolls, and main game loop
; -----------------------------------------------------------------------

.code

; Render the welcome banner and horse ASCII art
DisplayASCIIArt PROC
	; Set text color to green for the banner
	mov eax, lightGreen + (black * 16)  ; light green text on black background
	call SetTextColor

	; Display the banner
	mov edx, OFFSET largeBanner
	call WriteString

	; Display the horse ASCII art
	mov edx, OFFSET horseArt
	call WriteString

	; Reset text color to default light gray / white after displaying the banner
	mov eax, lightGray + (black * 16)  ; light gray text on black background
	call SetTextColor
	ret
DisplayASCIIArt ENDP

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

	; Set the text color to yellow for dice output
	mov eax, yellow + (black * 16)  ; yellow text on black background
	call SetTextColor

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

	; Reset the text color to default light gray / white
	mov eax, lightGray + (black * 16)  ; light gray text on black background
	call SetTextColor

	ret
Roll2Dice ENDP

; Scratch four different horses before racing.
InitScratches PROC
ScratchLoop:
	cmp scratchCount, 4
	jae ScratchesReady

	; Roll two dice without displaying setup rolls
	mov eax, 6
	call RandomRange
	inc eax
	push eax

	mov eax, 6
	call RandomRange
	inc eax
	pop edx
	add eax, edx
	sub eax, 2
	mov esi, eax	

	cmp scratchedFlags[esi], 1
	je ScratchLoop

	mov scratchedFlags[esi], 1
	inc scratchCount
	jmp ScratchLoop
ScratchesReady:
	ret
InitScratches ENDP

; Process the roll and update the board state
ProcessRoll PROC
	mov wasScratchedRolled, 0 ; reset the scratched horse flag for this roll

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
		inc potTotal
		mov wasScratchedRolled, 1 ; set the flag to indicate a scratched horse was rolled

		; Alert the player in yellow text
		mov eax, yellow + (black * 16) ; yellow text on black background
		call SetTextColor
		mov edx, OFFSET scratchPenaltyMsg
		call WriteString
		mov eax, lightGray + (black * 16) ; reset text color to default
		call SetTextColor

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
		mov eax, esi
		add eax, 2 ; converts the array index to horse number
		mov winningHorse, eax ; Save the winning horse number
		mov eax, 1  ; set EAX to 1 indicating a winner has been found
		ret


	; If no winner is found, set win flag to false
	NoWinner:
		mov eax, 0  ; set EAX to 0 indicating no winner
		ret

CheckWinConditions ENDP

; Display ASCII game header and current horse peg positions
DrawBoard PROC
	; Clear the screen and reset the cursor position to the top-left corner of the console
	call Clrscr
	mov dh, 0  ; row
	mov dl, 0  ; column
	call Gotoxy

	; Display the current dice roll and pot total
	mov edx, OFFSET totalMsg
	call WriteString
	mov eax, diceTotal
	call WriteDec
	call Crlf

	; Display the current pot total
	mov edx, OFFSET potHeaderMsg
	call WriteString
	mov eax, potTotal
	call WriteDec
	mov edx, OFFSET chipsMsg
	call WriteString
	call Crlf
	call Crlf

	; Check if a scratched horse was rolled and display a message if so
	cmp wasScratchedRolled, 1
	jne SkipScratchMessage

	; Display the scratched horse penalty message in yellow text
	mov eax, yellow + (black * 16) ; yellow text on black background
	call SetTextColor
	mov edx, OFFSET scratchPenaltyMsg
	call WriteString
	mov eax, lightGray + (black * 16) ; reset text color to default
	call SetTextColor

	SkipScratchMessage:
		call Crlf

	; Initialize the horse index (0 to 10)
	mov esi, 0

; Loop to print each horse's position (0-10, representing horses 2-12)
PrintBoardLoop:
	cmp esi, 11
	je DonePrinting

	; Print horse number (2-12)
	mov eax, esi
	add eax, 2
	call WriteDec

	; Print separator ": "
	mov edx, OFFSET colonMsg
	call WriteString

	; Check if scratched
	cmp scratchedFlags[esi], 1
	je PrintScratchedLine

	; Print opening bracket: [
	mov edx, OFFSET openBracket
	call WriteString

	; Draw track segment
	mov ecx, 0

DrawTrackLoop:
	cmp ecx, trackLengths[esi * 4]
	je FinishTrackLine

	cmp ecx, horsePositions[esi * 4]
	jne DrawBlankSpace

	mov edx, OFFSET horseCharacter
	call WriteString
	jmp NextChar

DrawBlankSpace:
	mov edx, OFFSET spaceCharacter
	call WriteString

NextChar:
	inc ecx
	jmp DrawTrackLoop

FinishTrackLine:
	; Show the horse at the finish line
	mov eax, horsePositions[esi * 4]
	cmp eax, trackLengths[esi * 4]
	jl CloseTrack

	mov edx, OFFSET horseCharacter
	call WriteString

CloseTrack:
	mov edx, OFFSET closeBracket
	call WriteString
	jmp NextHorseLine
	
PrintScratchedLine:
	mov edx, OFFSET scratchedMsg
	call WriteString

NextHorseLine:
	call Crlf
	inc esi
	jmp PrintBoardLoop
	
; Exit the loop and return from the procedure
DonePrinting:
	call Crlf
	ret
DrawBoard ENDP

; Distribute the pot chips to the winning horse's player
DistributePot PROC
	; Print a new line after the last prompted keypress
	call Crlf

	; Play a beep at 750 hertz for 400 ms
	INVOKE Beep, 750, 400

	; Pause for 300ms
	mov eax, 300
	call Delay

	; Set text color to light green for the payout message
	mov eax, lightGreen + (black * 16)  ; light green text on black background
	call SetTextColor

	; Display the winning horse announcement, ie: "Horse #7 has won the race!"
	mov edx, OFFSET horseWinnerMsg
	call WriteString
	mov eax, winningHorse
	call WriteDec
	mov edx, OFFSET wonMsg
	call WriteString

	; Display the payout header message
	mov edx, OFFSET payoutMsg
	call WriteString

	; Load the total pot amount into EAX for distribution
	mov eax, potTotal
	call WriteDec

	; Display the chips message
	mov edx, OFFSET chipsMsg
	call WriteString
	call Crlf

	; Default equal split among the 4 active players
	cmp potTotal, 0
	je PotEmpty ; if pot is empty, skip distribution

	; Calculate the equal share for each player
	mov eax, potTotal
	mov ebx, 4  ; number of players
	cdq ; clear EDX for division
	idiv ebx ; divide potTotal by 4, result in EAX, remainder in EDX

	; Credit each player's chips with their share
	add playerChips[0], eax
	add playerChips[4], eax
	add playerChips[8], eax
	add playerChips[12], eax

	; Reset the pot to zero after distribution
	mov potTotal, 0

	PotEmpty:
		; Reset text color to default light gray
		mov eax, lightGray + (black * 16)
		call SetTextColor

		ret

	DistributePot ENDP

; Get the player's bet
GetPlayerBet PROC
	; Prompt the player to select a horse to bet on
	PromptHorse:
		mov edx, OFFSET promptHorseMsg
		call WriteString
		call ReadDec
		mov selectedHorse, eax

		; Validate range (2-12)
		cmp eax, 2
		jb InvalidHorse
		cmp eax, 12
		ja InvalidHorse

		; Convert horse number to 0-based array index (0-10)
		mov esi, eax
		sub esi, 2

		; Check if selected horse is scratched
		cmp scratchedFlags[esi], 1
		je InvalidHorse
		jmp PromptBetAmount

	; Invalid horse selection handling
	InvalidHorse:
		mov eax, red + (black * 16)
		call SetTextColor
		mov edx, OFFSET invalidHorseMsg
		call WriteString
		mov eax, lightGray + (black * 16)
		call SetTextColor
		jmp PromptHorse

	; Prompt the player to enter their bet amount
	PromptBetAmount:
		; Prompt the player for a bet amount
		mov edx, OFFSET promptBetMsg
		call WriteString
		mov eax, playerChips[0] ; Player 1 chips
		call WriteDec
		mov edx, OFFSET colonMsg
		call WriteString
		call ReadDec
		mov playerBet, eax

		; Validate bet against the available chips
		cmp eax, 1
		jb InvalidBetAmount
		cmp eax, playerChips[0]
		ja InvalidBetAmount

		; Deduct the bet from player balance and add it to the pot
		sub playerChips[0], eax
		add potTotal, eax
		ret

	; Invalid bet amount handling
	InvalidBetAmount:
		mov eax, red + (black * 16)
		call SetTextColor
		mov edx, OFFSET invalidBetMsg
		call WriteString
		mov eax, lightGray + (black * 16)
		call SetTextColor
		jmp PromptBetAmount

GetPlayerBet ENDP

; Game setup and main loop calling Roll2Dice and ProcessRoll
main PROC
	; Seed the random number generator
	call Randomize

	; Initialize the scratched horses before starting the game
	call InitScratches

	; Clear the console screen and display the big banner & horse art
	call Clrscr
	call DisplayASCIIArt

	; Pause so the user can see the banner before starting the game
	mov edx, OFFSET promptMsg
	call WriteString
	call ReadChar
	call Clrscr

	; Prompt the player to place their bet before starting the game loop
	call GetPlayerBet
	call Clrscr

	GameLoop:
		; Roll the dice and display the results
		call Roll2Dice

		; Process the roll and update the board state
		call ProcessRoll

		; Render the updated board UI
		call DrawBoard

		; Check the win condition immediately after drawing the board
		call CheckWinConditions
		cmp eax, 1
		je Victory

		; Prompt the user to press a key to continue
		mov edx, OFFSET promptMsg
		call WriteString

		; Wait for user input to proceed
		call ReadChar
		jmp GameLoop

	Victory:
		call DistributePot
		mov edx, OFFSET gameOverMsg
		call WriteString
		call Crlf
		call Crlf

		; Prompt the user to play again
		mov edx, OFFSET playAgainMsg
		call WriteString
		call ReadChar

		; Check if the user wants to play again (Y/y)
		cmp al, 'Y'
		je RestartGame
		cmp al, 'y'
		je RestartGame

		; If not, exit the program
		exit

	; If the user chooses to play again, reset the game state and start over
	RestartGame:
		; Reset game state
		mov ecx, 11
		mov esi, 0

	; Loop to reset horse positions and scratched flags
	ResetLoop:
		mov horsePositions[esi * 4], 0
		mov scratchedFlags[esi], 0
		inc esi
		loop ResetLoop

		; Reset pot and player chips

	exit
main ENDP

END main