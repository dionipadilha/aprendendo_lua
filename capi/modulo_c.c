/* modulo_c.c

   Estendendo Lua com C: um módulo carregável via require.
   Compilado como biblioteca compartilhada (modulo_c.so), o require
   procura nele a função luaopen_modulo_c — a convenção é
   luaopen_<nome do módulo> — e a executa para obter o módulo.

   Cada função exposta segue o mesmo contrato: recebe o estado Lua,
   lê os argumentos da PILHA (posições 1, 2, ...), empilha os
   resultados e devolve QUANTOS resultados empilhou.

   Compilação e teste (ver README.md):
     make && lua5.4 testar_modulo.lua                                 */

#include <string.h>

#include <lua.h>
#include <lauxlib.h>

/* somar(a, b) -> a + b
   luaL_checkinteger valida o argumento e lança um erro Lua bem
   formatado ("bad argument #1 to 'somar'...") se o tipo não servir. */
static int somar(lua_State *L) {
  lua_Integer a = luaL_checkinteger(L, 1);
  lua_Integer b = luaL_checkinteger(L, 2);
  lua_pushinteger(L, a + b);
  return 1; /* um resultado na pilha */
}

/* inverter(s) -> a string com os BYTES na ordem contrária
   (como string.reverse; em UTF-8, caracteres multibyte se embaralham —
   a mesma ressalva bytes vs. caracteres de basico/cadeias_de_texto). */
static int inverter(lua_State *L) {
  size_t comprimento;
  const char *texto = luaL_checklstring(L, 1, &comprimento);

  luaL_Buffer resultado;
  luaL_buffinitsize(L, &resultado, comprimento);
  for (size_t i = 0; i < comprimento; i++) {
    luaL_addchar(&resultado, texto[comprimento - 1 - i]);
  }
  luaL_pushresult(&resultado);
  return 1;
}

/* A tabela de registro: nome visível em Lua -> função C. */
static const luaL_Reg funcoes[] = {
  { "somar", somar },
  { "inverter", inverter },
  { NULL, NULL } /* sentinela obrigatória */
};

/* O ponto de entrada que o require procura. Empilha a tabela do
   módulo (com as funções registradas) e a devolve. */
int luaopen_modulo_c(lua_State *L) {
  luaL_newlib(L, funcoes);
  return 1;
}
