-- escolher_ferramenta.lua

--------------------------------------------------------------------------------
-- Define uma lista de tarefas
local tarefas = {
  "limpar janela",
  "aspirar chão",
  "escrever relatório",
  "pesquisar dados"
}

--------------------------------------------------------------------------------
-- Define uma lista de ferramentas
local ferramentas = {
  "rodo",
  "aspirador",
  "computador",
  "internet"
}

--------------------------------------------------------------------------------
-- Define a classe Agente
local Agente = {}

function Agente:novo(agente)
  agente = agente or {}
  self.__index = self
  return setmetatable(agente, self)
end

-- escolhe a ferramenta com base na tarefa atual:
function Agente:escolherFerramenta(tarefa)
  return self.mapaTarefaFerramenta[tarefa]
end

-- usa a ferramenta selecionada:
function Agente:executar(tarefa, ferramenta)
  local registro = "Agente executa %s usando %s"
  print(registro:format(tarefa, ferramenta))
end

--------------------------------------------------------------------------------
-- Cria um agente com um conjunto de ferramentas

local agente = Agente:novo {
  ferramentas = ferramentas,
  mapaTarefaFerramenta = {
    ["limpar janela"] = "rodo",
    ["aspirar chão"] = "aspirador",
    ["escrever relatório"] = "computador",
    ["pesquisar dados"] = "internet"
  }
}

-- Verificação: o agente escolhe a ferramenta certa para cada tarefa
assert(agente:escolherFerramenta("limpar janela") == "rodo")
assert(agente:escolherFerramenta("aspirar chão") == "aspirador")
assert(agente:escolherFerramenta("escrever relatório") == "computador")
assert(agente:escolherFerramenta("pesquisar dados") == "internet")
assert(agente:escolherFerramenta("tarefa desconhecida") == nil)

-- Executa as tarefas
for _, tarefa in ipairs(tarefas) do
  print("tarefa: " .. tarefa)

  -- Seleciona uma ferramenta para cada tarefa
  local ferramenta = agente:escolherFerramenta(tarefa)
  print("ferramenta: " .. ferramenta)

  -- Usa a ferramenta para cada tarefa
  agente:executar(tarefa, ferramenta)

  print("Tarefa concluída: " .. tarefa)
end
