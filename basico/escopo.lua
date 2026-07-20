-- escopo.lua

-- variáveis locais declaradas dentro de blocos criam seus próprios escopos.

-- Declara uma variável no escopo mais externo:
local x = 10

-- Define o primeiro escopo de bloco:
do
  local x = x -- x interno <-- x externo
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
