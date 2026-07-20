-- composto.lua

-- Padrão Composto (Composite): tratar objetos individuais (folhas) e
-- agrupamentos (compostos) pela MESMA interface, formando árvores.
-- Tabelas de Lua são árvores naturais; o cliente chama o mesmo método
-- sem saber se fala com um arquivo ou com uma pasta inteira.

--------------------------------------------------------------------------------
-- A folha:

local Arquivo = {}
Arquivo.__index = Arquivo

function Arquivo.novo(nome, tamanho)
  return setmetatable({ nome = nome, tamanho = tamanho }, Arquivo)
end

function Arquivo:tamanhoTotal()
  return self.tamanho
end

--------------------------------------------------------------------------------
-- O composto — com a MESMA interface da folha:

local Pasta = {}
Pasta.__index = Pasta

function Pasta.nova(nome)
  return setmetatable({ nome = nome, itens = {} }, Pasta)
end

function Pasta:adicionar(item)
  table.insert(self.itens, item)
  return self -- encadeável
end

function Pasta:tamanhoTotal()
  local total = 0
  for _, item in ipairs(self.itens) do
    -- folha ou subárvore: tanto faz, a interface é a mesma.
    total = total + item:tamanhoTotal()
  end
  return total
end

--------------------------------------------------------------------------------

local raiz = Pasta.nova("projeto")
    :adicionar(Arquivo.novo("leiame.md", 10))
    :adicionar(
      Pasta.nova("codigo")
          :adicionar(Arquivo.novo("principal.lua", 30))
          :adicionar(Arquivo.novo("util.lua", 20))
    )

-- o cliente usa folha e composto do mesmo jeito:
assert(Arquivo.novo("solto.txt", 5):tamanhoTotal() == 5)
assert(raiz:tamanhoTotal() == 60)

-- e compostos aninham à vontade:
local backup = Pasta.nova("backup"):adicionar(raiz)
assert(backup:tamanhoTotal() == 60)

print("Composite: a árvore inteira somada pela interface das folhas.")
