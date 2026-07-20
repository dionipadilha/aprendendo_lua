-- registrador.lua

local Classe = require "classe"

local Registrador = Classe:novo {

  registros = {},

  registrar = function(self, mensagem)
    table.insert(self.registros, mensagem)
  end,

  imprimirRegistros = function(self)
    for _, registro in ipairs(self.registros) do
      print(registro)
    end
  end
}

--[[ testes
local registrador = Registrador:novo {}
assert(registrador.registros ~= nil)

registrador:registrar("x")
assert(registrador.registros[1] == "x")

registrador:registrar("y")
assert(registrador.registros[2] == "y")

registrador:imprimirRegistros() --> x, y
]]


return Registrador
