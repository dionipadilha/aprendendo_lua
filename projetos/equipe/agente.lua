-- agente.lua

local Classe = require "classe"

-- Os agentes são os blocos de construção da Equipe.
-- (Um arcabouço real de agentes teria muitas outras configurações —
-- limites de iteração, callbacks, integração com um LLM; este exemplo
-- didático mantém apenas as propriedades que de fato usa.)
local Agente = Classe:novo {
  -- propriedade: papel
  --- Define a função do agente dentro da equipe.
  --- Determina o tipo de tarefas para as quais o agente é mais adequado.
  papel = "",

  -- propriedade: objetivo
  --- O objetivo individual que o agente pretende alcançar.
  --- Ele guia o processo de tomada de decisão do agente.
  objetivo = "",

  -- propriedade: historia
  --- Fornece contexto ao papel e ao objetivo do agente,
  --- enriquecendo a dinâmica de interação e colaboração.
  historia = [[]]

  -- propriedade: ferramentas
  --- Conjunto de capacidades que o agente pode usar para executar
  --- tarefas (instâncias de Ferramenta). Campo mutável: inicializado
  --- POR INSTÂNCIA no construtor, logo abaixo.
}

-- Campos mutáveis são inicializados POR INSTÂNCIA: se `ferramentas = {}`
-- ficasse na tabela da classe, todos os agentes compartilhariam a MESMA
-- lista — equipar um agente equiparia todos os outros
-- (mesma regra aplicada em registrador.lua).
function Agente:novo(objeto)
  objeto = Classe.novo(self, objeto)
  objeto.ferramentas = objeto.ferramentas or {}
  return objeto
end

function Agente:usar(ferramenta, ...)
  -- Verifica se a ferramenta existe na tabela de ferramentas
  for _, ferramentaDisponivel in ipairs(self.ferramentas) do
    if ferramentaDisponivel == ferramenta then
      -- Chama a função da ferramenta com os argumentos
      return ferramenta:executar(...)
    end
  end
  return nil
end

-- testes: dois agentes criados sem ferramentas não compartilham a mesma lista
local agenteA = Agente:novo {}
local agenteB = Agente:novo {}
assert(agenteA.ferramentas ~= agenteB.ferramentas,
  "os agentes não podem compartilhar a tabela de ferramentas")
table.insert(agenteA.ferramentas, "ferramenta de teste")
assert(#agenteA.ferramentas == 1)
assert(#agenteB.ferramentas == 0,
  "equipar o agente A não pode equipar o agente B")

return Agente
