-- coleta_de_lixo.lua

-- limpa automaticamente os objetos não utilizados

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

local GerenciadorDeSessoes = Classe:novo {
  cache = {},
  visao = {}
}

function GerenciadorDeSessoes:adicionarSessao(usuario, dadosDaSessao)
  self.cache[usuario] = Sessao:novo { dados = dadosDaSessao }
end

function GerenciadorDeSessoes:exibirSessoes()
  self.visao:imprimirSessoes(self.cache)
end

--------------------------------------------------------------------------------
-- Principal

-- O cache usa CHAVES FRACAS: a metatabela com __mode = "k" fica explícita
-- aqui, e não escondida num campo de classe. Quando um usuário (chave) não
-- tiver mais nenhuma referência forte, sua entrada poderá ser coletada.
local cache = setmetatable({}, { __mode = "k" })

local gerenciador = GerenciadorDeSessoes:novo {
  cache = cache,
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
assert(contarSessoes(cache) == 2)

-- Remove a última referência forte a usuario1; a coleta de lixo
-- elimina a entrada correspondente do cache de chaves fracas:
usuario1 = nil
collectgarbage()
print("Sessões após a coleta de lixo:")
gerenciador:exibirSessoes()
--> Bob	dados do usuário #2
assert(contarSessoes(cache) == 1)
for usuario in pairs(cache) do assert(usuario.nome == "Bob") end

--------------------------------------------------------------------------------
