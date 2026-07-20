-- decorador.lua

-- Padrão Decorator: envolver uma função para acrescentar comportamento
-- antes e depois dela, sem modificá-la.

-- registra a ordem dos acontecimentos para podermos verificá-la
local acontecimentos = {}

-- Define a função decoradora
local function meuDecorador(funcao)
  return function()
    table.insert(acontecimentos, "antes")
    print("Algo acontece antes de a função ser chamada.")
    funcao()
    table.insert(acontecimentos, "depois")
    print("Algo acontece depois de a função ser chamada.")
  end
end

-- Define a função a ser decorada
local function dizerOla()
  table.insert(acontecimentos, "olá")
  print("Olá!")
end

-- Aplica o decorador
dizerOla = meuDecorador(dizerOla)

-- Chama a função decorada
dizerOla()

-- o decorador envolveu a função original na ordem correta:
assert(table.concat(acontecimentos, " -> ") == "antes -> olá -> depois")
