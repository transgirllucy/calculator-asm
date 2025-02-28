# x86_64 Assembly Calculator

A simple command-line calculator written in x86_64 assembly language for Linux systems.
# Overview

This project implements a basic calculator that can perform addition, subtraction, multiplication, and division operations on integer values. The program is written in pure x86_64 assembly language using NASM syntax and Linux syscalls.
Features

    Supports four basic arithmetic operations: +, -, *, /
    Handles positive and negative integer inputs
    Error handling for division by zero
    Direct syscall implementation without relying on libc
    Clean, efficient assembly code

# Building
## Using Nix Flakes (recommended)

If you have Nix with flakes enabled:

```
# Build the calculator
nix build

# Run the calculator
nix run
```

Manual Build

To build the calculator manually:

```
# Assemble the source code
nasm -f elf64 -o calculator.o calculator.asm

# Link the object file
ld calculator.o -o calculator

# Make the binary executable
chmod +x calculator

# Run the calculator
./calculator
```

# Usage

1.    Run the calculator executable
2.    Enter the first number when prompted
3.    Enter the second number when prompted
4.    Choose an operation (+, -, *, /)
5.    View the result

Example Session:

```
Enter first number: 42
Enter second number: 8
Enter operation (+, -, *, /): /
Result: 5
``` 
# Development

For development with Nix:

```
# Enter a development shell with all required tools
nix develop
```

# License

This project is available under the MIT License. Feel free to use, modify, and distribute as needed.

Note: This calculator is intended as an educational example of x86_64 assembly programming. It does not include advanced features such as floating-point arithmetic or complex expression parsing.

