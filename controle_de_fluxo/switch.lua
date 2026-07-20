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

  -- atenção: "padrao" é uma chave reservada desta implementação — um
  -- switch(casos, "padrao") seleciona o próprio caso padrão:
  local acao = casos[valor] or casos["padrao"]
  assert(type(acao) == "function", "a ação deve ser uma função")
  return acao()
end

--------------------------------------------------------------------------------
-- Testa a seleção básica de casos
-- (cada caso imprime a mensagem e devolve o nome do caso executado)

local estudantes = {
  padrao = function() print("Este é o caso padrão") return "padrao" end,
  -- Adiciona casos
  ana = function() print("Este é o caso da Ana") return "ana" end,
  bob = function() print("Este é o caso do Bob") return "bob" end,
  charlie = function() print("Este é o caso do Charlie") return "charlie" end,
}

assert(switch(estudantes, "ana") == "ana")     --> Este é o caso da Ana
assert(switch(estudantes, "bob") == "bob")     --> Este é o caso do Bob
assert(switch(estudantes, "duda") == "padrao") --> Este é o caso padrão

--------------------------------------------------------------------------------
-- Testa o estilo de método

local amigos = {
  switch = switch,
  padrao = function() print("Este é o caso padrão") return "padrao" end,
  -- Adiciona casos
  john = function() print("Este é o caso do John") return "john" end,
  jane = function() print("Este é o caso da Jane") return "jane" end,
  jack = function() print("Este é o caso do Jack") return "jack" end,
}

assert(amigos:switch("jack") == "jack")  --> Este é o caso do Jack
assert(amigos:switch("bob") == "padrao") --> Este é o caso padrão
--------------------------------------------------------------------------------
