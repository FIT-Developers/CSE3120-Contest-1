# Contest 1: Across The Board (Horse Race Betting Game)

## Game Explanation & How to Play
**"Across the Board"** is a 32-bit x86 Assembly console simulation of the classic wooden horse-racing tabletop game. 

### Core Gameplay Mechanics:
- **Pre-Race Setup & Scratch Phase:** At the start of each round, 4 horses (numbered 2–12) are randomly selected as **Scratched** and removed from the race. 
- **Interactive Player Betting:** Before the race begins, the player reviews the racetrack grid and places a chip bet on any active (non-scratched) horse from their balance.
- **Racetrack & Peg Movement:** The race proceeds by rolling two 6-sided dice.
  - **Active Horse:** If an active horse's number is rolled, its peg advances 1 spot along its designated track. Track lengths vary based on rolling probability (e.g., Horse #7 has a longer track than #2 or #12).
  - **Scratched Horse Penalty:** If a scratched horse's number is rolled, its peg does not move; instead, 1 penalty chip is automatically added to the main pot.
- **Victory & Pot Distribution:** The first active horse to reach its finish line wins the race. The accumulated pot (starting ante + scratch penalty chips + bets) is distributed to the winner. Players are then prompted with a replay option to restart another round with refreshed state.

---

## Project Overview
This is a 32-bit x86 Assembly implementation of the traditional wooden horse race gambling game **"Across the Board"**, built for CSE3120 Contest 1. 

The current version is an interactive single-player horse-racing simulation featuring:
- Two-dice rolls and four uniquely scratched horses
- Interactive pre-race horse selection and chip betting system
- Dynamic ASCII visual console racetrack grid with scratch status indicators
- Real-time scratch penalty tracking and pot incrementation
- Winner announcement, automated pot distribution, and audio fanfare (via Win32 `Beep`)
- Interactive replay loop with clean keyboard buffer validation

---

## Team Members
- **Michael Woodyard**
- **Kelsey Hahn**

---

## Environment & Prerequisites
- **Language:** x86 Assembly (MASM / 32-bit)
- **IDE:** Visual Studio 2022
- **Required Library:** `Irvine32` (`Irvine32.inc` & `Irvine32.lib`)

---

## How to Compile and Run

### Option 1: Automated build (recommended)
1. Install Visual Studio with MASM and Irvine32 at `C:\Irvine`.
2. Open the **x86 Native Tools Command Prompt for VS 2022**.
3. Navigate to the repository folder using `cd /d`.
4. Run `build.bat` to assemble and link the game.
5. Run `main.exe` to start playing.

### Option 2: Quick CLI Build (Developer PowerShell / Command Prompt)
Navigate to the project root directory containing `main.asm` and run:

1. `ml /c /coff /Zi /IC:\Irvine main.asm`
2. `link /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine Irvine32.lib Kernel32.lib User32.lib main.obj`
3. `.\main.exe`