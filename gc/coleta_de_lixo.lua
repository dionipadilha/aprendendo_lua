-- coleta_de_lixo.lua

-- A coleta de lixo é por ALCANÇABILIDADE: o coletor só recolhe objetos
-- que o programa não alcança mais por caminho nenhum. Zerar uma
-- variável não "apaga" o objeto — apenas remove UMA referência.
-- (o cache com CHAVES FRACAS, que expira junto com o usuário, está em
-- chaves_fracas.lua; os modos do coletor, em modos_do_coletor.lua)

--------------------------------------------------------------------------------
-- Modelo

-- Define a classe abstrata:
local Classe = {
  novo = function(self, objeto)
    self.__index = self
    objeto = objeto or {}
    return setmetatable(objeto, self)
  end
}

-- Define as classes concretas:
local Usuario = Classe:novo { id = 0, nome = "" }
local Sessao = Classe:novo { dados = "" }

--------------------------------------------------------------------------------
-- Visão

local Visao = Classe:novo {}

function Visao:imprimirSessoes(cacheDeSessoes)
  for k, v in pairs(cacheDeSessoes) do
    print(k.nome, v.dados)
  end
end

--------------------------------------------------------------------------------
-- Controlador

-- A classe NÃO define cache/visao como defaults: um default na tabela
-- da classe seria alcançado via __index por TODAS as instâncias —
-- estado compartilhado disfarçado (ver ../padroes/observador.lua).
-- Cada instância recebe seu cache e sua visão na construção:
local GerenciadorDeSessoes = Classe:novo {}

function GerenciadorDeSessoes:adicionarSessao(usuario, dadosDaSessao)
  self.cache[usuario] = Sessao:novo { dados = dadosDaSessao }
end

function GerenciadorDeSessoes:encerrarSessoesDe(nome)
  for usuario in pairs(self.cache) do
    -- apagar uma chave EXISTENTE durante o pairs é permitido
    -- (criar chaves novas é que não seria):
    if usuario.nome == nome then self.cache[usuario] = nil end
  end
end

function GerenciadorDeSessoes:exibirSessoes()
  self.visao:imprimirSessoes(self.cache)
end

--------------------------------------------------------------------------------
-- Principal

-- O cache aqui é uma tabela COMUM: suas referências (fortes) seguram os
-- usuários enquanto a sessão existir. Compare com chaves_fracas.lua,
-- onde o cache com __mode = "k" NÃO segura os usuários:
local gerenciador = GerenciadorDeSessoes:novo {
  cache = {},
  visao = Visao:novo()
}

local usuario1 = Usuario:novo { id = 1, nome = "Ana" }
local usuario2 = Usuario:novo { id = 2, nome = "Bob" }

gerenciador:adicionarSessao(usuario1, "dados do usuário #1")
gerenciador:adicionarSessao(usuario2, "dados do usuário #2")

local function contarSessoes(t)
  local quantidade = 0
  for _ in pairs(t) do quantidade = quantidade + 1 end
  return quantidade
end

print("Sessões após adicionar os usuários:")
gerenciador:exibirSessoes()
--> Ana	dados do usuário #1
--> Bob	dados do usuário #2
assert(contarSessoes(gerenciador.cache) == 2)

-- Observatório com VALORES fracos (__mode = "v"): a entrada some
-- quando o objeto é coletado — serve só para OBSERVAR a coleta, sem
-- criar referência forte (a semântica de __mode = "v" é demonstrada
-- em modos_do_coletor.lua):
local observatorio = setmetatable({}, { __mode = "v" })
observatorio.ana = usuario1

-- Zerar a variável NÃO apaga o objeto: o cache do gerenciador ainda
-- alcança Ana, então o coletor não pode recolhê-la:
usuario1 = nil
collectgarbage()
assert(contarSessoes(gerenciador.cache) == 2) -- nenhuma sessão sumiu
assert(observatorio.ana ~= nil)               -- Ana sobreviveu à coleta

-- Removida a última referência forte (a entrada do cache), o objeto
-- fica inalcançável e a próxima coleta o recolhe:
gerenciador:encerrarSessoesDe("Ana")
collectgarbage()
print("Sessões após encerrar as sessões de Ana:")
gerenciador:exibirSessoes()
--> Bob	dados do usuário #2
assert(contarSessoes(gerenciador.cache) == 1)
assert(observatorio.ana == nil) -- agora sim: Ana foi coletada
for usuario in pairs(gerenciador.cache) do assert(usuario.nome == "Bob") end
assert(usuario2.nome == "Bob")

--------------------------------------------------------------------------------
