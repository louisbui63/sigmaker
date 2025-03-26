CC = clang++

PATH_TO_IDASDK = ../idasdk91

ifeq ($(CC), gcc)
CFLAGS = -std=c++23 -Wall -Wextra -pedantic -O2 -fopenmp
else # we assume it's clang
CFLAGS = -std=c++23 -Wall -Wextra -pedantic -O2 -fopenmp=libomp -Wno-gnu-empty-struct
endif

# CFLAGS += $(shell pkg-config --cflags sdl2 SDL2_mixer SDL2_ttf)
# CFLAGS += -g -fno-omit-frame-pointer #-fsanitize=address
CFLAGS += -I"$(PATH_TO_IDASDK)/include"
CFLAGS += -L"$(PATH_TO_IDASDK)/lib/x64_linux_gcc_64"
CFLAGS += -lida
CFLAGS += -fPIC
# CFLAGS=-D__IDP__ -D__PLUGIN__ -c -D__LINUX__
# LDFLAGS=--shared $(OBJS) -L/usr/local/idaadv -lida \
# --no-undefined -Wl,--version-script=./plugin.script

# LIBS = $(shell pkg-config --libs sdl2 SDL2_mixer SDL2_ttf) -lm

SRC=$(subst src,build/src/,$(subst .cpp,.o,$(shell find . -type f -name '*.cpp')))
TEST_SRC=$(subst tests/,build/tests/,$(subst .cpp,.o,$(wildcard tests/*.cpp)))

.PHONY: all test format clean run test_run doc

all: $(SRC)
	$(CC) -shared -o sigmaker.so $(SRC) $(CFLAGS) $(LIBS)

build/%.o: %.cpp
	mkdir -p $(shell dirname $@)
	$(CC) -c $< -o $@ $(CFLAGS)

add_test_flag:
	$(eval CFLAGS += -DIS_TEST)

test: clean add_test_flag $(SRC) $(TEST_SRC)
	$(CC) $(CFLAGS) $(LIBS) -o test $(subst build/src/main.o,,$(SRC)) $(TEST_SRC)

format:
	./format.sh

doc:
	make -C ./doc doc

latex:
	make -C ./doc latex

htmldoc :
	firefox https://uwu-segfault.eu/2p2doc/

clean:
	rm -rf build/*
	rm -f main test

run: all
	./main

test_run: test
	valgrind ./test
