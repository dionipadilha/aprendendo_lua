-- tabela_proxy.lua

-------------------------------------------------------------
-- Atribuição em uma tabela padrão:

local tabela = {}

-- Tentando atribuir um valor a uma chave que não existe:
tabela["foo"] = "bar"
print(tabela["foo"]) --> bar
assert(tabela["foo"] == "bar")

-------------------------------------------------------------
--  Interceptando e tratando atribuições:

local nova_tabela = {}
local proxy = {
  __newindex = function(t, k, v)
    -- rawset(t, k, v)
    print("atualização negada: " .. tostring(k) .. " para " .. tostring(v))
  end
}
setmetatable(nova_tabela, proxy)

-- Tentando atribuir um valor a uma chave que não existe:
nova_tabela["foo"] = "bar" --> atualização negada: foo para bar
print(nova_tabela["foo"])  --> nil
assert(nova_tabela["foo"] == nil) -- __newindex bloqueou a atribuição

-------------------------------------------------------------
