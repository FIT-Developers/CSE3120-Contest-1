# Contest 1: Across the Board (Horse Race Betting Game)

## Project Overview
This is a 32-bit x86 Assembly implementation of the traditional wooden horse race gambling game **"Across the Board"**, built for CSE3120 Contest 1. 


The current version is an interactive single-player
horse-racing simulation featuring:
- Two-dice rolls and four uniquely scratched horses
- Horse movement along ASCII console tracks
- A winner announcement when a horse finishes
- A fixed 20-chip demonstration pot, divided equally among four simulated player balances
- Keypress-controlled turns and a game-over screen


## Team Members
- **Michael Woodyard**
- **Kelsey Hahn**

## Environment & Prerequisites
- **Language:** x86 Assembly (MASM / 32-bit)
- **IDE:** Visual Studio 2022
- **Required Library:** `Irvine32` (`Irvine32.inc` & `Irvine32.lib`)

## How to Compile and Run


### Option 1: Automated build (recommended)
1. Install Visual Studio with MASM and Irvine32 at `C:\Irvine`.
2. Open the **x86 Native Tools Command Prompt for VS 2026**.
3. Navigate to the repository folder using `cd /d`.
4. Run `build.bat` to assemble and link the game.
5. Run `main.exe` to start playing.


### Option 2: Quick CLI Build (Developer PowerShell / Command Prompt)
Navigate to the project root directory containing `main.asm` and run:

1. ```ml /c /coff /Zi /IC:\Irvine main.asm```
2. ```link /SUBSYSTEM:CONSOLE /LIBPATH:C:\Irvine Irvine32.lib Kernel32.lib User32.lib main.obj```
3. ```.\main.exe```
