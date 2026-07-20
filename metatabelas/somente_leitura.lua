-- somente_leitura.lua

local function somenteLeitura(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function()
      error("tentativa de atualizar uma tabela somente leitura", 2)
    end
  })
end

local dias = somenteLeitura { "Domingo", "Segunda", "Terça" }

print(dias[1]) --> Domingo
assert(dias[1] == "Domingo")

-- Atualizar uma tabela somente leitura gera um erro; capture-o com pcall.
-- A mensagem vem com o prefixo arquivo:linha (aqui, a linha da atribuição):
local ok, err = pcall(function() dias[2] = "Nenhumdia" end)
print(ok, err) --> false	somente_leitura.lua:19: tentativa de atualizar uma tabela somente leitura
assert(ok == false)
-- o número da linha mudaria a cada edição do arquivo; casamos com %d+:
assert(err:match("somente_leitura%.lua:%d+: tentativa de atualizar uma tabela somente leitura"))
