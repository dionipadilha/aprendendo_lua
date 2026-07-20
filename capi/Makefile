# Makefile dos exemplos da API C (ver README.md).
# Alvos: make (compila tudo), make clean (remove os artefatos).

CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra

# Localiza headers e biblioteca do Lua 5.4 via pkg-config, com um
# fallback para o layout padrão do Debian/Ubuntu (liblua5.4-dev).
LUA_PKG ?= lua5.4
LUA_CFLAGS := $(shell pkg-config --cflags $(LUA_PKG) 2>/dev/null || echo -I/usr/include/lua5.4)
LUA_LIBS := $(shell pkg-config --libs $(LUA_PKG) 2>/dev/null || echo -llua5.4)

all: embutir modulo_c.so

# O host embutido LINKA com a liblua (ele carrega o interpretador):
embutir: embutir.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) -o $@ embutir.c $(LUA_LIBS) -lm

# O módulo NÃO linka com a liblua: os símbolos vêm do interpretador
# que o carrega (por isso apenas -shared -fPIC):
modulo_c.so: modulo_c.c
	$(CC) $(CFLAGS) $(LUA_CFLAGS) -shared -fPIC -o $@ modulo_c.c

clean:
	rm -f embutir modulo_c.so

.PHONY: all clean
