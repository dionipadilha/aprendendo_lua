-- testar_modulo.lua

-- Testa o módulo C compilado (modulo_c.so). Segue o padrão de
-- banco_de_dados/sqlite3.lua: quando o artefato não está disponível
-- (ninguém rodou `make` ainda, ou a plataforma não compila .so),
-- avisa e encerra com sucesso para não quebrar a suíte.

local biblioteca = io.open("modulo_c.so", "rb")
if not biblioteca then
  print("Aviso: modulo_c.so não encontrado; compile com `make` para testar.")
  print("(a CI Linux executa este teste com o módulo compilado)")
  return
end
biblioteca:close()

-- garante que o require procura bibliotecas C no diretório atual:
package.cpath = "./?.so;" .. package.cpath

local moduloC = require "modulo_c"

-- as funções C se comportam como funções Lua comuns:
assert(moduloC.somar(2, 3) == 5)
assert(moduloC.somar(-10, 4) == -6)
assert(moduloC.inverter("aul") == "lua")
assert(moduloC.inverter("") == "")

-- a validação de argumentos vem de luaL_checkinteger, com a mensagem
-- padrão de erro de argumento do próprio Lua:
local ok, erro = pcall(moduloC.somar, "x", 1)
assert(not ok and erro:find("bad argument"))

print("módulo C carregado e verificado via require!")
