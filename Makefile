ifndef LUA_BIN
LUA_BIN = luajit
endif

.PHONY: check bench

all: check bench

check:
	cd test && $(LUA_BIN) test.lua

bench:
	make -C bench
