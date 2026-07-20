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
local Sujeito = Classe:novo {}

-- Campos mutáveis são inicializados POR INSTÂNCIA: se `observadores = {}`
-- ficasse na tabela da classe, todos os sujeitos compartilhariam a MESMA
-- lista e um notificaria os observadores do outro.
function Sujeito:novo(objeto)
  objeto = Classe.novo(self, objeto)
  objeto.observadores = objeto.observadores or {}
  return objeto
end

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
  -- `...` no meio de uma lista de expressões é ajustado para UM único
  -- valor; por isso o id vem primeiro e o vararg fica por último.
  print(self.id, ...)
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
--> painel #1	estacaoMeteorologica #1 chamando
--> painel #2	estacaoMeteorologica #1 chamando

-- a notificação repassa TODOS os argumentos aos observadores:
estacaoMeteorologica2:notificar("chuva", "42mm")
--> painel #2	chuva	42mm
--> painel #3	chuva	42mm

--------------------------------------------------------------------------------
-- Duas instâncias de Sujeito devem ser independentes: anexar um
-- observador a uma estação não pode afetar a lista da outra.

assert(#estacaoMeteorologica1.observadores == 2)
assert(#estacaoMeteorologica2.observadores == 2)
assert(estacaoMeteorologica1.observadores ~= estacaoMeteorologica2.observadores,
  "os sujeitos não podem compartilhar a tabela de observadores")

estacaoMeteorologica1:anexar({ painel3 })
assert(#estacaoMeteorologica1.observadores == 3)
assert(#estacaoMeteorologica2.observadores == 2,
  "anexar na estação #1 não pode alterar a estação #2")

-- E um sujeito criado sem observadores começa com a própria lista vazia:
local estacaoNova = Sujeito:novo()
assert(#estacaoNova.observadores == 0)
--------------------------------------------------------------------------------
