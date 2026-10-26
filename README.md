# Contest 1: Across the Board (Horse Race Betting Game)

## Project Overview
This is a 32-bit x86 Assembly implementation of the traditional wooden horse race gambling game **"Across the Board"**, built for CSE3120 Contest 1. 

The game supports a single-player experience against 3 simulated AI opponents, featuring:
- Dice rolling and card dealing
- Horse movement and position tracking
- Scratch horse penalties and dynamic chip pot management
- An ASCII console board interface using the Irvine32 library

## Team Members
- **Michael Woodyard**
- **Kelsey Hahn**

## Environment & Prerequisites
- **Language:** x86 Assembly (MASM / 32-bit)
- **IDE:** Visual Studio 2022
- **Required Library:** `Irvine32` (`Irvine32.inc` & `Irvine32.lib`)

## How to Compile and Run
1. Open Visual Studio 2022 and load the project solution (`.sln`).
2. Ensure **MASM Build Customizations** (`masm.targets`) are enabled for the project.
3. Confirm that the **Irvine32** library and include paths are correctly linked in your project properties:
   - *Include Directories:* `C:\Irvine`
   - *Library Directories:* `C:\Irvine`
   - *Additional Dependencies:* `Irvine32.lib`
4. Build the solution (**Ctrl + Shift + B** or **Build > Build Solution**).
5. Run the program (**F5** or **Ctrl + F5**).