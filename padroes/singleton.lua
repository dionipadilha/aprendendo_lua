-- singleton.lua

-- Padrão Singleton: garantir que uma classe tenha UMA única instância
-- e oferecer um ponto de acesso global a ela.
--
-- Em Lua, o idioma mais comum é um módulo que guarda a instância numa
-- variável local (upvalue) e sempre devolve a mesma tabela.

--------------------------------------------------------------------------------
local Configuracao = {}
Configuracao.__index = Configuracao

local instancia -- guardada como upvalue; começa como nil

-- Ponto de acesso único: cria a instância na primeira chamada
-- (inicialização preguiçosa) e a reutiliza nas seguintes.
function Configuracao.obterInstancia()
  if not instancia then
    instancia = setmetatable({ valores = {} }, Configuracao)
  end
  return instancia
end

function Configuracao:definir(chave, valor)
  self.valores[chave] = valor
end

function Configuracao:obter(chave)
  return self.valores[chave]
end

--------------------------------------------------------------------------------
-- Uso: qualquer parte do programa que pedir a configuração recebe
-- exatamente o mesmo objeto.

local configuracaoDoMenu = Configuracao.obterInstancia()
local configuracaoDoJogo = Configuracao.obterInstancia()

assert(configuracaoDoMenu == configuracaoDoJogo,
  "obterInstancia deve devolver sempre a MESMA instância")

-- o que um cliente escreve, o outro enxerga (é o mesmo objeto):
configuracaoDoMenu:definir("idioma", "pt-BR")
assert(configuracaoDoJogo:obter("idioma") == "pt-BR")

print("Singleton: uma única instância compartilhada por todos os clientes.")
