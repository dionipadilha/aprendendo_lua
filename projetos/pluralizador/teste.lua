-- teste.lua

--------------------------------------------------------------------------------
-- Defina a função que você quer testar:
local minhaFuncao = require "principal"

--------------------------------------------------------------------------------
-- Defina seus casos de teste como uma tabela de pares entrada-saída:
local meusCasosDeTeste = require "validacao"

--------------------------------------------------------------------------------
-- Execução dos testes:

-- Função de execução de um teste:
local function executar(funcaoDeTeste, caso, esperado)
  print(caso .. " --> " .. esperado)
  local registro = "\nFalha: esperado '%s', obtido '%s'"
  local obtido = funcaoDeTeste(caso)
  return assert(esperado == obtido, registro:format(esperado, obtido))
end

-- Função executora dos testes:
-- Devolve true somente se todos os casos passarem, para que o assert
-- de topo (abaixo) derrube a execução em caso de regressão.
local function rodar(funcaoDeTeste, casosDeTeste)
  --
  assert(funcaoDeTeste, "A função de teste deve ser fornecida")
  assert(casosDeTeste, "Os casos de teste devem ser fornecidos")
  --
  for caso, esperado in pairs(casosDeTeste) do
    local ok, excecao = pcall(executar, funcaoDeTeste, caso, esperado)
    if not ok then
      print(excecao)
      return false
    end
  end
  print("Todos os testes passaram!")
  return true
end

--------------------------------------------------------------------------------
-- Rode os testes
assert(rodar(minhaFuncao, meusCasosDeTeste),
  "Há casos de teste reprovando no pluralizador") --> Todos os testes passaram!
--------------------------------------------------------------------------------
