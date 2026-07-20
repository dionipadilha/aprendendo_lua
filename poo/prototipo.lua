-- prototipo.lua

-- #1. Definindo uma tabela protótipo:
local ClassePai = {}
ClassePai.chavePai = "valorPai"

-- #2. Criando um método fábrica:
function ClassePai:novo(objeto)
  objeto = objeto or {}
  self.__index = self
  return setmetatable(objeto, self)
end

-- #3. Criando uma classe filha:
local ClasseFilha = ClassePai:novo()
ClasseFilha.chaveFilha = "valorFilho"

-- #4. Criando uma instância de objeto:
local objeto = ClasseFilha:novo()
objeto.chavePropria = "valorProprio"

-- #5. Acessar propriedades em diferentes níveis:
print(objeto.chavePai)     --> valorPai
print(objeto.chaveFilha)   --> valorFilho
print(objeto.chavePropria) --> valorProprio

assert(objeto.chavePai == "valorPai")         -- herdada do protótipo pai
assert(objeto.chaveFilha == "valorFilho")     -- herdada do protótipo filho
assert(objeto.chavePropria == "valorProprio") -- própria do objeto
