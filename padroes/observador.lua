-- observador.lua

-- observador: um sujeito pode notificar múltiplos observadores

--------------------------------------------------------------------------------
local Classe = {
  novo = function(self, objeto)
    objeto = objeto or {}
    self.__index = self
    return setmetatable(objeto, self)
  end
}

--------------------------------------------------------------------------------
local Sujeito = Classe:novo {
  observadores = {}
}

function Sujeito:anexar(novosObservadores)
  for _, novoObservador in ipairs(novosObservadores) do
    table.insert(self.observadores, novoObservador)
  end
end

function Sujeito:notificar(...)
  for _, observador in ipairs(self.observadores) do
    observador:atualizar(...)
  end
end

--------------------------------------------------------------------------------
local Observador = Classe:novo {}

function Observador:atualizar(...)
  print(..., self.id)
end

--------------------------------------------------------------------------------
-- Exemplo:

-- cria observadores:
local painel1 = Observador:novo { id = "painel #1" }
local painel2 = Observador:novo { id = "painel #2" }
local painel3 = Observador:novo { id = "painel #3" }

-- cria um sujeito:
local estacaoMeteorologica1 = Sujeito:novo {
  observadores = {
    painel1,
    painel2
  }
}

-- cria outro sujeito:
local estacaoMeteorologica2 = Sujeito:novo {
  observadores = {
    painel2,
    painel3
  }
}

estacaoMeteorologica1:notificar("estacaoMeteorologica #1 chamando")
--> estacaoMeteorologica #1 chamando	painel #1
--> estacaoMeteorologica #1 chamando	painel #2

estacaoMeteorologica2:notificar("estacaoMeteorologica #2 chamando")
--> estacaoMeteorologica #2 chamando	painel #2
--> estacaoMeteorologica #2 chamando	painel #3
--------------------------------------------------------------------------------
