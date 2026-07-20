-- construtor.lua

-- Padrão Builder (Construtor): montar um objeto complexo passo a passo,
-- separando a CONSTRUÇÃO da REPRESENTAÇÃO final. Útil quando o objeto
-- tem muitas partes opcionais e um construtor com N parâmetros ficaria
-- ilegível.
--
-- Cada passo devolve o próprio construtor (interface fluente), e
-- `montar` entrega o produto pronto e validado.

--------------------------------------------------------------------------------
local ConstrutorDePizza = {}
ConstrutorDePizza.__index = ConstrutorDePizza

function ConstrutorDePizza.novo()
  local construtor = {
    tamanho = "média",
    borda = "tradicional",
    coberturas = {}
  }
  return setmetatable(construtor, ConstrutorDePizza)
end

function ConstrutorDePizza:comTamanho(tamanho)
  self.tamanho = tamanho
  return self -- devolve o construtor para encadear os passos
end

function ConstrutorDePizza:comBorda(borda)
  self.borda = borda
  return self
end

function ConstrutorDePizza:adicionarCobertura(cobertura)
  table.insert(self.coberturas, cobertura)
  return self
end

-- O passo final valida e entrega o produto (uma tabela simples,
-- independente do construtor).
function ConstrutorDePizza:montar()
  assert(#self.coberturas > 0, "uma pizza precisa de ao menos uma cobertura")
  return {
    tamanho = self.tamanho,
    borda = self.borda,
    coberturas = self.coberturas,
    descricao = ("pizza %s, borda %s, com %s")
        :format(self.tamanho, self.borda, table.concat(self.coberturas, " e "))
  }
end

--------------------------------------------------------------------------------
-- Uso: os passos encadeados leem como uma frase.

local pizza = ConstrutorDePizza.novo()
    :comTamanho("grande")
    :comBorda("recheada")
    :adicionarCobertura("mussarela")
    :adicionarCobertura("manjericão")
    :montar()

assert(pizza.tamanho == "grande")
assert(pizza.borda == "recheada")
assert(pizza.descricao == "pizza grande, borda recheada, com mussarela e manjericão")

-- a validação do passo final protege contra produtos incompletos:
local ok = pcall(function() return ConstrutorDePizza.novo():montar() end)
assert(not ok, "montar sem coberturas deveria falhar")

print("Builder: " .. pizza.descricao)
