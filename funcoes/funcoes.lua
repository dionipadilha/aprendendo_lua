--------------------------------------------------------------------------------
-- Funções:
local function saudar(nome)
  print("Olá " .. nome)
end
saudar("Bob") --> Olá Bob

-- Múltiplos valores de retorno:
local function somaProduto(x, y)
  return x + y, x * y
end
local soma, produto = somaProduto(2, 3)
print(soma, produto) --> 5 6

-- Argumentos opcionais:
local function saudar(nome, saudacao)
  saudacao = saudacao or "Olá"
  print(saudacao .. " " .. nome)
end
saudar("Bob") --> Olá Bob
saudar("Bob", "Oi") --> Oi Bob

-- Argumentos nomeados:
local function saudar(argumentos)
  local nome = argumentos.nome
  local saudacao = argumentos.saudacao or "Olá"
  print(saudacao .. " " .. nome)
end
saudar{nome = "Bob"} --> Olá Bob
saudar{nome = "Bob", saudacao = "Oi"} --> Oi Bob
saudar{saudacao = "Oi", nome = "Bob"} --> Oi Bob

-- Número variável de argumentos:
local function saudar(...)
  local nomes = {...}
  for _, nome in ipairs(nomes) do
    print("Oi " .. nome)
  end
end
saudar("Ana", "Bob", "Carlos") --> Oi Ana, Oi Bob, Oi Carlos

--------------------------------------------------------------------------------
-- Função anônima:
print((function(x) return 2*x end)(3)) --> 6
print((function(x) return 2*x end)(5)) --> 10

-- Variável com funções anônimas:
local saudar = function(nome)
  print("Oi " .. nome)
end
saudar("Bob") --> Oi Bob

-- Função anônima com argumentos:
local saudar = function(nome, saudacao)
  print(saudacao .. " " .. nome)
end
saudar("Bob", "Ei") --> Ei Bob

--------------------------------------------------------------------------------
-- Funções de primeira classe:
local function saudar(nome)
  return function()
    print("Oi " .. nome)
  end
end
local saudarAna = saudar("Ana")
local saudarBob = saudar("Bob")
saudarAna() --> Oi Ana
saudarBob() --> Oi Bob


-- Função de ordem superior:
local function saudar(nome, callback)
  callback(nome)
end
saudar("Bob", print) --> Bob
saudar("Bob", function(nome) print("Oi " .. nome) end) --> Oi Bob

-- Clausuras:
local function contador()
  local contagem = 0
  return function()
    contagem = contagem + 1
    return contagem
  end
end
local contar = contador()
print(contar()) --> 1
print(contar()) --> 2
print(contar()) --> 3

-- Recursão:
local function fatorial(n)
  if n == 0 then return 1
  else return n * fatorial(n - 1)
  end
end
print(fatorial(5)) --> 120

--------------------------------------------------------------------------------
-- Tratamento de erros:
local status, resultado = pcall(function() error("Algum erro") end)
print(status) --> false
print(resultado) --> Algum erro

local status, resultado = pcall(function() return "Algum resultado" end)
print(status) --> true
print(resultado) --> Algum resultado

--------------------------------------------------------------------------------
-- Recursão de cauda:
local function fatorial(n, acumulador)
  if n == 0 then return acumulador
  else return fatorial(n - 1, n * acumulador)
  end
end
print(fatorial(5, 1)) --> 120

-- Recursão anônima:
local fatorial
fatorial = function(n)
  if n == 0 then return 1
  else return n * fatorial(n - 1)
  end
end
print(fatorial(5)) --> 120

-- Memoização:
local memo = {}
local function fatorial(n)
  if n == 0 then return 1
  else
    if not memo[n] then
      memo[n] = n * fatorial(n - 1)
    end
    return memo[n]
  end
end
print(fatorial(5)) --> 120
print(fatorial(5)) --> 120
print(fatorial(6)) --> 720
print(fatorial(6)) --> 720

-- Currying:
local function somar(x)
  return function(y)
    return x + y
  end
end
local somar2 = somar(2)
print(somar2(3)) --> 5
print(somar2(5)) --> 7

-- Aplicação parcial:
local function somar(x, y)
  return x + y
end
local somar2 = function(y) return somar(2, y) end
print(somar2(3)) --> 5
print(somar2(5)) --> 7

-- Composição:
local function somar2(x)
  return x + 2
end
local function mult3(x)
  return x * 3
end
local function compor(f, g)
  return function(x)
    return f(g(x))
  end
end
local somar2DepoisMult3 = compor(mult3, somar2)
print(somar2DepoisMult3(5)) --> 21

-- Pipe:
local function somar2(x)
  return x + 2
end
local function mult3(x)
  return x * 3
end
local function pipe(f, g)
  return function(x)
    return g(f(x))
  end
end
local somar2DepoisMult3 = pipe(somar2, mult3)
print(somar2DepoisMult3(5)) --> 21
