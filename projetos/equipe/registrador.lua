-- registrador.lua

local Classe = require "classe"

local Registrador = Classe:novo {

  registrar = function(self, mensagem)
    table.insert(self.registros, mensagem)
  end,

  imprimirRegistros = function(self)
    for _, registro in ipairs(self.registros) do
      print(registro)
    end
  end
}

-- Campos mutáveis são inicializados POR INSTÂNCIA: se `registros = {}`
-- ficasse na tabela da classe, todos os registradores compartilhariam a
-- MESMA lista de registros.
function Registrador:novo(objeto)
  objeto = Classe.novo(self, objeto)
  objeto.registros = objeto.registros or {}
  return objeto
end

-- testes: duas instâncias independentes
local registrador1 = Registrador:novo {}
local registrador2 = Registrador:novo {}
assert(registrador1.registros ~= nil and registrador2.registros ~= nil)
assert(registrador1.registros ~= registrador2.registros,
  "os registradores não podem compartilhar a tabela de registros")

registrador1:registrar("x")
registrador1:registrar("y")
registrador2:registrar("z")

assert(registrador1.registros[1] == "x")
assert(registrador1.registros[2] == "y")
assert(#registrador1.registros == 2)
assert(registrador2.registros[1] == "z")
assert(#registrador2.registros == 1,
  "registrar no registrador nº 1 não pode alterar o registrador nº 2")

return Registrador
