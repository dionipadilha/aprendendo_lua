-- escopo.lua

-- variáveis locais declaradas dentro de blocos criam seus próprios escopos.

-- Declara uma variável no escopo mais externo:
local x = 10

-- Define o primeiro escopo de bloco:
do
  local x = x -- o x da DIREITA ainda é o externo: o escopo do novo
              -- local só começa APÓS a declaração — por isso o idioma
              -- `local x = x` copia o valor de fora sem se ler a si mesmo
  print(x)    --> 10
  assert(x == 10)
  x = x + 1   -- x interno --> 11
  assert(x == 11)

  -- Define um escopo de bloco aninhado:
  do
    local x = x -- x aninhado <-- x interno
    print(x)    --> 11
    assert(x == 11)
    x = x + 1   -- x aninhado --> 12
    print(x)    --> 12
    assert(x == 12)
  end

  -- Sai do escopo de bloco aninhado:
  print(x) --> 11 (x interno)
  assert(x == 11)
end

-- Sai do escopo de bloco externo:
print(x) --> 10 (x externo)
assert(x == 10)

--------------------------------------------------------------------------------
-- Globais: o que acontece quando NÃO se escreve `local`

-- Ler uma variável que nunca foi declarada não é erro — o valor é nil:
-- uma global "inexistente" é só uma chave ausente na tabela _G, que
-- guarda todas as globais do programa:
assert(_G.nuncaDeclarada == nil)

-- Atribuir sem `local` também não é erro: cria uma variável GLOBAL,
-- visível para o programa inteiro — é assim que um `local` esquecido
-- vira uma global acidental. Escrevemos via _G para tornar a intenção
-- explícita (uma atribuição direta seria acusada pelo luacheck deste
-- repositório, que proíbe globais justamente por causa desse risco):
_G.criadaSemLocal = 42
assert(_G.criadaSemLocal == 42)

-- Remover a chave de _G desfaz a global (e limpa a demonstração):
_G.criadaSemLocal = nil
assert(_G.criadaSemLocal == nil)
