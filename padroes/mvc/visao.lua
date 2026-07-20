-- Visão: Cuida da camada de apresentação.

local Classe = require "comum"

local Visao = Classe:novo {}

function Visao:renderizar(dados)
  print("Renderizando dados: " .. dados)
end

return Visao
