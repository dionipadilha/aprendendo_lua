-- ferramenta.lua

local Classe = require "classe"

-- estendendo as capacidades dos agentes

local Ferramenta = Classe:novo {
  nome = "",
  descricao = "",
  executar = "Nenhuma função definida para executar."
}

return Ferramenta
