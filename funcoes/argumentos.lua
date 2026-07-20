-- argumentos.lua

-- Sem argumentos:
local function saudar()
  print("Olá")
end
saudar() --> Olá

-- Um único argumento:
local function saudar(nome)
  print("Oi " .. nome)
end
saudar("Ana") --> Oi Ana
saudar("Bob") --> Oi Bob

-- Múltiplos argumentos:
local function saudar(nome, saudacao)
  print(saudacao .. " " .. nome)
end
saudar("Ana", "Oi") --> Oi Ana
saudar("Bob", "Ei") --> Ei Bob

-- Argumentos obrigatórios:
local function saudar(nome, saudacao)
  assert(nome, "erro: argumento obrigatório")
  assert(saudacao, "erro: argumento obrigatório")
  print(saudacao .. " " .. nome)
end
saudar("Ana", "Oi") --> Oi Ana
-- saudar("Bob")    --> erro: argumento obrigatório

-- Argumentos padrão:
local function saudar(nome, saudacao)
  local padrao = { nome = "Ana", saudacao = "Oi" }
  nome = nome or padrao.nome
  saudacao = saudacao or padrao.saudacao
  print(saudacao .. " " .. nome)
end
saudar()            --> Oi Ana
saudar("Bob")       --> Oi Bob
saudar("Bob", "Ei") --> Ei Bob

-- Número variável de argumentos:
local function saudar(...)
  local nomes = { ... }
  for _, nome in ipairs(nomes) do print("Oi " .. nome) end
end
saudar("Ana")        --> Oi Ana
saudar("Ana", "Bob") --> Oi Ana, Oi Bob

-- Misturando argumentos regulares e número variável de argumentos:
local function saudar(saudacao, ...)
  local nomes = { ... }
  assert(#nomes > 0, "erro: pelo menos um nome é obrigatório")
  for _, nome in ipairs(nomes) do
    print(saudacao .. " " .. nome)
  end
end
--saudar() --> erro: pelo menos um nome é obrigatório
saudar("Oi", "Ana")        --> Oi Ana
saudar("Ei", "Ana", "Bob") --> Ei Ana, Ei Bob

-- Argumentos nomeados:
local function saudar(argumentos)
  argumentos = argumentos or { nome = "Ana", saudacao = "Oi" }
  print(argumentos.saudacao .. " " .. argumentos.nome)
end
saudar()                                      --> Oi Ana
saudar({ nome = "Bob", saudacao = "Ei" })     --> Ei Bob
saudar({ saudacao = "Tchau", nome = "Jhon" }) --> Tchau Jhon


-- Funções como argumentos (Funções de Ordem Superior):
local function saudar(nome, callback)
  callback(nome)
end
saudar("Bob", print)                                   --> Bob
saudar("Bob", function(nome) print("Oi " .. nome) end) --> Oi Bob
