.PHONY: all clean

bin/%.o: src/%.c
	gcc -Wall -Wpedantic -Wextra `pkg-config --cflags gtk+-3.0` -c $< -o $@

bin/phondue: $(patsubst src/%.c, bin/%.o, $(wildcard src/*.c))
	gcc -Wall -Wpedantic -Wextra `pkg-config --libs gtk+-3.0` $^ -o $@

all: bin/phondue

clean:
	-rm -f bin/*
