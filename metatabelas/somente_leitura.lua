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

-- Atualizar uma tabela somente leitura gera um erro; capture-o com pcall:
local ok, err = pcall(function() dias[2] = "Nenhumdia" end)
print(ok, err) --> false	somente_leitura.lua: tentativa de atualizar uma tabela somente leitura
