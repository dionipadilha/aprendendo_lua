-- modelo.lua

-- Modelo: Gerencia a lógica de negócio dos dados.

local Classe = require "comum"

local Modelo = Classe:novo {
  dados = nil
}

function Modelo:definirDados(novosDados)
  assert(
    type(novosDados) == "string" and novosDados ~= "",
    "os dados devem ser uma string não vazia"
  )
  self.dados = novosDados
end

function Modelo:obterDados()
  return self.dados
end

-- A camada de apresentação (Visao) mora em visao.lua.

return Modelo
