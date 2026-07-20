-- chamada.lua

-----------------------------------------------------------------------------
-- __call:
-- permite que uma tabela seja usada como uma função

-- #1. Criar uma tabela que funciona como função:
local plural = setmetatable({}, {
  __call = function(self, ...)
    for _, palavra in ipairs({ ... }) do print(palavra .. "s") end
  end
})

-- #2. Chamar a tabela como uma função:
print("A tabela é chamada como uma função!")
plural("gato", "cachorro") --> gatos
                           --> cachorros
assert(type(getmetatable(plural).__call) == "function")
-----------------------------------------------------------------------------
-- Aplicando o conceito:

-- #1. Definir uma tabela de transformações com vários métodos
local transformacoes = {
  plural = function(palavra) return palavra .. "s" end,
  capitalizar = function(palavra) return palavra:sub(1, 1):upper() .. palavra:sub(2) end,
  inverter = function(palavra) return palavra:reverse() end
}

-- As transformações são funções puras; asserts provam o resultado:
assert(transformacoes.plural("gato") == "gatos")
assert(transformacoes.capitalizar("gato") == "Gato")
assert(transformacoes.inverter("gato") == "otag")

-- #2. Criar uma tabela que funciona como função:
local transformador = setmetatable({}, {
  __call = function(self, acao, ...)
    if transformacoes[acao] then
      for _, palavra in ipairs({ ... }) do
        print(transformacoes[acao](palavra))
      end
    else
      print("Ação desconhecida: " .. acao)
    end
  end
})

--#3. Chamar a tabela como uma função:
print("A tabela é chamada como uma função!")
transformador("plural", "gato", "cachorro")
transformador("capitalizar", "gato", "cachorro")
transformador("inverter", "gato", "cachorro")
transformador("desconhecida", "gato", "cachorro")
-----------------------------------------------------------------------------
