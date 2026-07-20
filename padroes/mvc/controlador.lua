-- Controlador: Gerencia a interação entre o Modelo e a Visão.

local Classe = require "comum"

local Controlador = Classe:novo {
  modelo = {},
  visao = {}
}

function Controlador:definirDados(dados)
  assert(
    type(dados) == "string" and dados ~= "",
    "os dados devem ser uma string não vazia"
  )
  self.modelo:definirDados(dados)
  self.visao:renderizar(dados)
end

function Controlador:obterDados()
  return self.modelo:obterDados()
end

return Controlador
