ASM = nasm
ASMFLAGS = -f elf64
LD = ld
LDFLAGS =

SRC = calculator.asm
OBJ = calculator.o
BIN = calculator

all: $(BIN)

$(BIN): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $<
	chmod +x $@

$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(OBJ) $(BIN)

run: $(BIN)
	./$(BIN)

debug: $(BIN)
	gdb ./$(BIN)

install: $(BIN)
	install -m 755 $(BIN) /usr/local/bin/$(BIN)

uninstall:
	rm -f /usr/local/bin/$(BIN)

check:
	$(ASM) -f elf64 -o /dev/null $(SRC)

help:
	@echo "Available targets:"
	@echo "  all       - Build the calculator (default)"
	@echo "  clean     - Remove build files"
	@echo "  run       - Run the calculator"
	@echo "  debug     - Debug with GDB"
	@echo "  install   - Install to /usr/local/bin"
	@echo "  uninstall - Remove from /usr/local/bin"
	@echo "  check     - Check assembly syntax"
	@echo "  help      - Show this help message"

.PHONY: all clean run debug install uninstall check help
