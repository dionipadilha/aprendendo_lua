-- heranca.lua

-- Definindo as tabelas Pai e Filha:
local tabelaPai = { chavePai = "valorPai" }
local tabelaFilha = { chaveFilha = "valorFilho" }

-- Configurando a herança:
setmetatable(tabelaFilha, { __index = tabelaPai })

-- Acessando a chave herdada:
print(tabelaFilha.chaveFilha) --> valorFilho
print(tabelaFilha.chavePai)   --> valorPai

assert(tabelaFilha.chaveFilha == "valorFilho")
assert(tabelaFilha.chavePai == "valorPai")   -- herdada via __index
assert(rawget(tabelaFilha, "chavePai") == nil) -- não existe na filha
