-- principal.lua
-- Integra os componentes do MVC.

local Modelo = require "modelo"
local Visao = require "visao"
local Controlador = require "controlador"

local function principal()
  -- Cria instâncias do modelo, da visão e do controlador:
  local controlador = Controlador:novo {
    modelo = Modelo:novo {},
    visao = Visao:novo {}
  }

  -- Configura o modelo com os dados iniciais:
  controlador:definirDados("#1 Dados iniciais") --> Renderizando dados: #1 Dados iniciais
  assert(controlador:obterDados() == "#1 Dados iniciais")

  -- Atualiza o modelo com novos dados:
  controlador:definirDados("#2 Dados alterados") --> Renderizando dados: #2 Dados alterados
  assert(controlador:obterDados() == "#2 Dados alterados")

  return "O padrão MVC está funcionando como esperado."
end

print(pcall(principal)) --> true	O padrão MVC está funcionando como esperado.
