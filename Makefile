.PHONY: all clean

bin/%.o: src/%.c
	gcc -Wall -Wpedantic -Wextra -c $< -o $@ `pkg-config --cflags gtk+-3.0`

bin/phondue: $(patsubst src/%.c, bin/%.o, $(wildcard src/*.c))
	gcc -Wall -Wpedantic -Wextra $^ -o $@ `pkg-config --libs gtk+-3.0`

all: bin/phondue

clean:
	-rm -f bin/*
