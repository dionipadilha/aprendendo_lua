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

local novaTabela = {}
local proxy = {
  __newindex = function(t, k, v)
    -- para ACEITAR a escrita, seria: rawset(t, k, v)
    -- aqui a atribuição é rejeitada de propósito, só com um aviso:
    print("atualização negada: " .. tostring(k) .. " para " .. tostring(v))
  end
}
setmetatable(novaTabela, proxy)

-- Tentando atribuir um valor a uma chave que não existe:
novaTabela["foo"] = "bar" --> atualização negada: foo para bar
print(novaTabela["foo"])  --> nil
assert(novaTabela["foo"] == nil) -- __newindex bloqueou a atribuição

-------------------------------------------------------------
