-- switch.lua
-- executa um caso com base no valor fornecido

--------------------------------------------------------------------------------
-- Define a função switch


local function switch(casos, valor)
  assert(type(casos) == "table", "Tabela de casos inválida")
  assert(casos["padrao"], "Forneça o caso padrão")
  assert(
    type(valor) == "string" or type(valor) == "number",
    "valor deve ser uma string ou um número"
  )

  local acao = casos[valor] or casos["padrao"]
  assert(type(acao) == "function", "a ação deve ser uma função")
  return acao()
end

--------------------------------------------------------------------------------
-- Testa a seleção básica de casos

local estudantes = {
  padrao = function() print("Este é o caso padrão") end,
  -- Adiciona casos
  ana = function() print("Este é o caso da Ana") end,
  bob = function() print("Este é o caso do Bob") end,
  charlie = function() print("Este é o caso do Charlie") end,
}

switch(estudantes, "ana")  --> Este é o caso da Ana
switch(estudantes, "bob")  --> Este é o caso do Bob
switch(estudantes, "duda") --> Este é o caso padrão

--------------------------------------------------------------------------------
-- Testa o estilo de método

local amigos = {
  switch = switch,
  padrao = function() print("Este é o caso padrão") end,
  -- Adiciona casos
  john = function() print("Este é o caso do John") end,
  jane = function() print("Este é o caso da Jane") end,
  jack = function() print("Este é o caso do Jack") end,
}

amigos:switch("jack") --> Este é o caso do Jack
amigos:switch("bob")  --> Este é o caso padrão
--------------------------------------------------------------------------------
