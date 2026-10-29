# RISC-V Digital Piano & Melody Player

An interactive digital piano simulator implemented in **RISC-V Assembly** utilizing the **RARS** (RISC-V Assembler and Runtime Simulator) MIDI audio system calls[cite: 3].

Developed for **Intro to Computer Systems (EC351)** at the **University of Tripoli** (Spring 2025)[cite: 2].

---

## Overview

This project simulates a digital keyboard instrument at the assembly level[cite: 3]. It maps standard PC keyboard inputs to corresponding MIDI note values across two octaves and sends them to the RARS audio engine in real time[cite: 3]. It also features an automated playback engine configured to play a predefined melody using synchronous syscalls with an execution cutoff limit[cite: 3].

### Key Features
- **Two Full Octaves:** Covers C4–B4 via lowercase keys and C5–B5 via uppercase keys (holding `Shift`)[cite: 3, 5, 8].
- **Non-Blocking Playback:** Uses asynchronous MIDI syscalls for instant key responsiveness without halting program execution[cite: 3, 5].
- **Automated Song Playback:** Synchronous melody loop that plays "Twinkle, Twinkle, Little Star" (*The Song*) with an enforced 5-second cutoff limit[cite: 3, 5, 8].
- **Low-Level Architecture Concepts:** Demonstrates string parsing, ASCII-to-index translation, pointer arithmetic, memory bounds checking, and syscall management[cite: 3, 5].

---

## Keyboard Controls & Note Mapping

| Key | Octave | MIDI Note | Frequency |
| :--- | :--- | :--- | :--- |
| `z`, `x`, `c`, `v`, `b`, `n`, `m`[cite: 8] | Lower Octave (C4 – B4)[cite: 4, 8] | 60, 62, 64, 65, 67, 69, 71[cite: 4, 8] | 261 Hz – 493 Hz[cite: 4] |
| `Z`, `X`, `C`, `V`, `B`, `N`, `M` (`Shift` + key)[cite: 8] | Higher Octave (C5 – B5)[cite: 4, 8] | 72, 74, 76, 77, 79, 81, 83[cite: 4, 8] | 523 Hz – 987 Hz[cite: 4] |
| `s` / `S`[cite: 5, 8] | Melody | Plays the predefined song (5-second limit)[cite: 3, 5, 8] | — |
| `q` / `Q`[cite: 5, 8] | System | Exit simulator[cite: 4, 5, 8] | — |

---

## Syscalls Used

| Register `a7` | Syscall Name | Function |
| :---: | :--- | :--- |
| `4`[cite: 4] | `print_string`[cite: 4] | Prints text prompts and messages to the console[cite: 4]. |
| `10`[cite: 4] | `exit`[cite: 4] | Cleanly terminates program execution[cite: 4]. |
| `12`[cite: 4] | `read_char`[cite: 4] | Reads unbuffered keyboard input without echoing to the screen[cite: 4]. |
| `30`[cite: 4] | `set_midi_tempo`[cite: 4] | Sets the MIDI playback tempo (configured to 500,000 µs/beat)[cite: 4, 8]. |
| `31`[cite: 4] | `play_note_async`[cite: 4] | Plays a note non-blocking for responsive keyboard input[cite: 3, 4, 5]. |
| `33`[cite: 4] | `play_note_sync`[cite: 4] | Plays a note synchronously (blocking) for timed song loops[cite: 3, 4, 5]. |

---

## How to Run

### Requirements
- Java Runtime Environment (JRE 8 or higher)
- [RARS (RISC-V Assembler and Runtime Simulator)](https://github.com/TheThirdOne/rars)

### Steps
1. Clone the repository:
   ```bash
   git clone [https://github.com/MoayedLy/riscv-midi-piano.git](https://github.com/MoayedLy/riscv-midi-piano.git)
   cd riscv-midi-piano
   ```
2. Open RARS:
   ```bash
   java -jar rars.jar
   ```
3. In RARS, open `Piano Sound Generation .asm` (via `File` -> `Open`).
4. Assemble the program using `F3` (or `Run` -> `Assemble`).
5. Run the simulator using `F5` (or `Run` -> `Go`).
6. Click into the **Run I/O** console window at the bottom of RARS to start typing notes!

---

## Project Team

- **Ahmed Hawas** (2210244424)[cite: 2]
- **Moayed Eshbeni** (2210249584)[cite: 2]
- **Omar Azouze** (2220209280)[cite: 2]

*Department of Computer Engineering, University of Tripoli*[cite: 2]