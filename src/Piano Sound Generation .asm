.data                                                #.data section – Declares variables and constants That we want to use in the program
note_table:                                          # defines an array of 14 MIDI note numbers for the piano keys
    # Lower octave (Small letters)                   # for lowercase keys
    .word 60   # (z)
    .word 62   # (x)
    .word 64   # (c)
    .word 65   # (v)
    .word 67   # (b)
    .word 69   # (n)
    .word 71   # (m)
    # Higher octave (capital letters)                # for uppercase
    .word 72   # (Z)
    .word 74   # (X)
    .word 76   # (C)
    .word 77   # (V)
    .word 79   # (B)
    .word 81   # (N)
    .word 83   # (M)
    
key_mapping: .asciz "ZXCVBNM"

# The Song melody (MIDI notes)
The_Song:                                            # A list of 42 MIDI note numbers to play as the melody
    .word 60, 60, 67, 67, 69, 69, 67
    .word 65, 65, 64, 64, 62, 62, 60
    .word 67, 67, 65, 65, 64, 64, 62
    .word 67, 67, 65, 65, 64, 64, 62
    .word 60, 60, 67, 67, 69, 69, 67
    .word 65, 65, 64, 64, 62, 62, 60
Song_length: .word 42                                # Total notes in The Song melody

                                                     # Duration for each note (in milliseconds)
note_duration: .word 500, 500, 500, 500, 500, 500, 1000
               .word 500, 500, 500, 500, 500, 500, 1000
               .word 500, 500, 500, 500, 500, 500, 1000
               .word 500, 500, 500, 500, 500, 500, 1000
               .word 500, 500, 500, 500, 500, 500, 1000
               .word 500, 500, 500, 500, 500, 500, 1000


                                                     # These are user messages shown on the screen.
prompt: .asciz "Press:\n- ZXCVBNM for lower octave\n- SHIFT+ZXCVBNM for higher octave\n- S to play The Song\n- Q to quit\n"
newline: .asciz "\n"
playing_msg: .asciz "Playing The Song...\n"
stop_msg: .asciz "Stopping playback after 5 seconds...\n"

                                                     #.text section – Code starts here
.text
.globl main

main:
    # Set tempo
    li a7, 30
    li a0, 500000  # 500ms per beat
    ecall
    
    # Print initial prompt
    la a0, prompt
    li a7, 4
    ecall
    
input_loop:                                          # input_loop: – Main loop for keypress handling
    # Read character (no echo)                       # Waits for a keypress (no echo).
    li a7, 12
    ecall
    
    # Check for quit (Q or q)                        # Exits the program if 'Q' or 'q' is pressed.
    li t0, 'Q'
    beq a0, t0, exit
    li t0, 'q'
    beq a0, t0, exit
    
    # Check for song play (S or s)                   # If 'S' or 's' is pressed, go play the melody.
    li t0, 'S'
    beq a0, t0, play_The_Song
    li t0, 's'
    beq a0, t0, play_The_Song
    
    # Store original character
    mv t6, a0
    
    # Check if uppercase (potential shifted key)
    li t1, 'a'
    blt a0, t1, is_uppercase
    # It's lowercase - convert to uppercase for comparison
    addi a0, a0, -32
    
is_uppercase:
    # Now a0 contains uppercase version
    # Find note in mapping
    la t3, key_mapping
    li t4, 0      # index
    
search_loop:
    lb t5, 0(t3)
    beqz t5, invalid_note  # End of string
    beq a0, t5, found_note
    addi t3, t3, 1
    addi t4, t4, 1
    j search_loop
    
found_note:
    # Now determine if it was shifted (higher octave)
    beq t6, a0, shifted_key
    j unshifted_key
    
shifted_key:
    # Higher octave (add 7 to index)
    addi t4, t4, 7
    
unshifted_key:
    # Ensure index is within bounds
    li t5, 14       # Total notes (7 lower + 7 higher)
    bge t4, t5, invalid_note
    
    # Get MIDI note
    slli t4, t4, 2   # multiply by 4 (word size)
    la t5, note_table
    add t5, t5, t4
    lw a0, 0(t5)     # pitch
    
    # Play note
    li a7, 31        # async play syscall
    li a1, 300       # duration (ms)
    li a2, 0         # instrument (0 = piano)
    li a3, 127       # volume (max)
    ecall
    
    j input_loop
    
play_The_Song:
    # Print playing message
    la a0, playing_msg
    li a7, 4
    ecall
    
    # Play the melody
    la t0, The_Song  # Notes pointer
    la t1, note_duration   # Duration pointer
    lw t2, Song_length  # Load note count
    li t3, 0               # Counter
    li t4, 0               # Total elapsed time (ms)
    li t5, 5000            # 5 second limit (5000ms)
    
Song_loop:
    bge t3, t2, input_loop  # Done with all notes
    bge t4, t5, stop_playback  # Reached 5 second limit
    
    # Load note and duration
    lw a0, 0(t0)          # MIDI note
    lw a1, 0(t1)          # duration
    
    # Add to total elapsed time
    add t4, t4, a1
    
    # Play note (synchronous)
    li a7, 33             # sync play syscall
    li a2, 0              # instrument
    li a3, 127            # volume
    ecall
    
    # Increment pointers and counter
    addi t0, t0, 4
    addi t1, t1, 4
    addi t3, t3, 1
    j Song_loop
    
stop_playback:
    # Print stop message
    la a0, stop_msg
    li a7, 4
    ecall
    j input_loop
    
invalid_note:
    j input_loop
    
exit:
    li a7, 10
    ecall
