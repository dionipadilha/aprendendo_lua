-- ferramenta.lua

local Classe = require "classe"

-- estendendo as capacidades dos agentes

local Ferramenta = Classe:novo {
  nome = "",
  descricao = "",
  -- o default é uma FUNÇÃO que falha com mensagem clara: se fosse uma
  -- string, chamar executar() estouraria com o críptico
  -- "attempt to call a string value".
  executar = function(self)
    error(("A ferramenta '%s' não define executar()"):format(tostring(self.nome)))
  end
}

-- uma ferramenta sem implementação falha com a mensagem prevista:
local semImplementacao = Ferramenta:novo { nome = "vazia" }
local ok, erro = pcall(function() return semImplementacao:executar() end)
assert(not ok, "executar() sem implementação deveria falhar")
assert(tostring(erro):find("'vazia' não define executar"),
  "mensagem de erro inesperada: " .. tostring(erro))

return Ferramenta
