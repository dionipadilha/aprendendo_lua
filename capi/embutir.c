/* embutir.c

   Embutindo Lua num programa C: o caso de uso original da linguagem.
   Este host cria um estado Lua, executa código Lua, lê uma variável
   global e chama uma função Lua com argumentos — os quatro movimentos
   básicos de qualquer integração.

   Toda a conversa entre C e Lua passa pela PILHA VIRTUAL: o C empilha
   valores para enviar ao Lua e lê da pilha o que o Lua devolve.
   Índices positivos contam da base (1 é o fundo); negativos contam do
   topo (-1 é o último valor empilhado).

   Compilação e execução (ver README.md):
     make && ./embutir                                                */

#include <stdio.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

int main(void) {
  /* 1. Criar o estado Lua e carregar a biblioteca padrão.
        Cada estado é um universo Lua independente dentro do processo. */
  lua_State *L = luaL_newstate();
  if (L == NULL) {
    fprintf(stderr, "sem memória para criar o estado Lua\n");
    return 1;
  }
  luaL_openlibs(L);

  /* 2. Executar código Lua a partir do C.
        luaL_dostring compila e roda; devolve LUA_OK em caso de
        sucesso, senão deixa a mensagem de erro no topo da pilha. */
  const char *codigo =
      "saudacao = 'Olá do Lua, executado pelo C!'\n"
      "function dobro(n) return 2 * n end\n";
  if (luaL_dostring(L, codigo) != LUA_OK) {
    fprintf(stderr, "erro no código Lua: %s\n", lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }

  /* 3. Ler uma variável global do Lua.
        lua_getglobal empilha o valor; lua_tostring lê o topo (-1).
        Depois de usar, desempilhamos para não acumular lixo. */
  lua_getglobal(L, "saudacao");
  printf("global lida do Lua: %s\n", lua_tostring(L, -1));
  lua_pop(L, 1);

  /* 4. Chamar uma função Lua com argumento e colher o retorno.
        Protocolo: empilha a função, empilha os argumentos, chama
        lua_pcall(nargs, nresultados, tratador). O retorno substitui
        função e argumentos no topo da pilha. */
  lua_getglobal(L, "dobro");
  lua_pushinteger(L, 21);
  if (lua_pcall(L, 1, 1, 0) != LUA_OK) {
    fprintf(stderr, "erro ao chamar dobro: %s\n", lua_tostring(L, -1));
    lua_close(L);
    return 1;
  }
  lua_Integer resultado = lua_tointeger(L, -1);
  lua_pop(L, 1);
  printf("dobro(21) calculado pelo Lua: %lld\n", (long long)resultado);

  /* verificação no estilo do repositório: falha => código de saída 1 */
  if (resultado != 42) {
    fprintf(stderr, "esperava 42, obtive %lld\n", (long long)resultado);
    lua_close(L);
    return 1;
  }

  /* 5. Encerrar o estado libera toda a memória gerenciada por ele. */
  lua_close(L);
  printf("host embutido verificado!\n");
  return 0;
}
