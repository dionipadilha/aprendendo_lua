# Primeiros Passos com Lua

Lua é uma linguagem de programação leve, de alto nível e multiparadigma, projetada principalmente para uso embarcado em aplicações. Ela enfatiza a extensibilidade e a simplicidade.

Dicas para aprender Lua:

- A melhor forma de aprender Lua é escrevendo código Lua.
- Experimente modificar os exemplos e praticar.

## Programação Essencial em Lua

Os trechos a seguir cobrem aspectos essenciais da programação em Lua:

- Sintaxe Básica:

```lua
-- comentário de uma linha
print("Olá, Mundo!") --> comentário lateral

--[[
  Este é um
    comentário de
      várias linhas.
--]]
```

- Tipos de Dados:

Lua possui oito tipos básicos: `nil`, `boolean`, `number`, `string`, `function`, `userdata`, `thread` e `table` (veja `tipos.md` e `tipos.lua`).

```lua
local numero = 10
local texto = "Lua"
local booleano = true
local lista = {"item1", "item2", "item3"} -- lista, array
local tabela = {chave1 = "str", chave2 = 30} -- dicionário, mapa
local x = nil -- representa a ausência de valor
```

- Operadores:

  - **Aritméticos:** `+`, `-`, `*`, `/`, `//`, `%`, `^`
  - **Relacionais:** `==`, `~=`, `>`, `<`, `>=`, `<=`
  - **Lógicos:** `and`, `or`, `not`
  - **Concatenação e comprimento:** `..`, `#`
  - **Bit a bit:** `&`, `|`, `~`, `<<`, `>>`

  (todos com exemplos executáveis em `operadores.lua`)

- Condicional:

```lua
if numero > 5 then print("O número é maior que 5")
elseif numero < 5 then print("O número é menor que 5")
else print("O número é 5")
end
```

- Estruturas de repetição (`for`, `while` e `repeat ... until`):

```lua
-- Laço for:
for i = 1, 5 do print(i) end

-- Laço while:
local i = 1
while i <= 5 do
  print(i)
  i = i + 1
end

-- Laço repeat ... until (executa o bloco ao menos uma vez):
local n = 1
repeat
  print(n)
  n = n + 1
until n > 5
```

- Funções

```lua
-- Lua suporta funções de primeira classe e clausuras (closures).

-- Definição de funções
-- (o `local` importa: sem ele, a função viraria uma variável GLOBAL,
--  visível — e sobrescrevível — pelo programa inteiro)
local function saudar(nome)
  print("Olá, " .. nome)
end

-- Invocação de funções
saudar("Alice")

-- Funções anônimas podem ser definidas sem nome, úteis para operações curtas:
local dobro = function(x) return 2 * x end
```

- Tabelas

```lua
-- Em Lua, as tabelas são o único mecanismo de estruturação de dados:
-- funcionam como arrays associativos e representam listas, dicionários e objetos.

-- lista, arrays
local lista = {"item1", "item2", "item3"}
print(lista[1]) --> item1

-- mapa, dicionários
local tabela = {chave1 = "valor1", chave2 = "valor2"}
print(tabela["chave1"]) --> valor1

-- objetos
local pessoa = {nome = "bob", idade = 30}
print(pessoa.nome)  --> bob
print(pessoa.idade)  --> 30
```

Metatabelas e metamétodos podem definir comportamentos personalizados para tabelas (veja a pasta `metatabelas/`).

- Módulos

```lua
-- Módulos são incluídos usando a função require:
local modulo = require("nomeDoModulo")
```

- Tratamento de erros

```lua
-- Tratamento de erros com a função pcall
if pcall(funcaoQuePodeFalhar) then print("Sucesso")
else print("Falha")
end

-- xpcall permite fornecer uma função tratadora de erros;
-- a função error lança um erro manualmente:
error("Esta é uma mensagem de erro")
```

- Corrotinas

```lua
-- Corrotinas permitem pausar (yield) e retomar (resume) uma função:
local co = coroutine.create(function()
  coroutine.yield("pausa")
  return "fim"
end)
print(coroutine.resume(co)) --> true	pausa
print(coroutine.resume(co)) --> true	fim
```

- Operações com arquivos

```lua
-- Escrevendo em um arquivo
local arquivo = io.open("teste.txt", "w")
arquivo:write("Olá, Lua!")
arquivo:close()

-- Lendo de um arquivo
local arquivo = io.open("teste.txt", "r")
local conteudo = arquivo:read("*a")
print(conteudo)
arquivo:close()
```

## Explore recursos mais avançados

Recursos avançados de Lua:

- metatabelas
- corrotinas
- módulos
- API C de Lua
- ferramentas de depuração
- coletor de lixo

Para documentação detalhada, consulte:

- [site oficial de Lua](http://www.lua.org/manual/).
- Repositórios e bibliotecas de Lua.

## Exemplos de Código Lua

Exemplo #1:

```lua
--[[------------------------------------------------------------
  Crie um programa que imprima os números de 1 a 10, mas:
    - para múltiplos de 3, imprime "Fizz",
    - para múltiplos de 5, imprime "Buzz",
    - para números que são múltiplos de 3 e de 5 ao mesmo tempo, imprime "FizzBuzz".
]]

----------------------------------------------------------------
for i = 1, 10 do
  if i % 3 == 0 and i % 5 == 0 then
    print("FizzBuzz")
  elseif i % 3 == 0 then
    print("Fizz")
  elseif i % 5 == 0 then
    print("Buzz")
  else
    print(i)
  end
end
```

Exemplo #2:

```lua
--[[------------------------------------------------------------
  Crie uma função Lua que realize operações aritméticas básicas.
    - adição, subtração, multiplicação e divisão.
    - argumentos da função: dois números e uma operação.
]]

----------------------------------------------------------------
local function avaliar(operacao, a, b)
  local operacoes = {
    somar = function(a, b) return a + b end,
    subtrair = function(a, b) return a - b end,
    multiplicar = function(a, b) return a * b end,
    dividir = function(a, b)
      if b ~= 0 then return a / b
        else return nil, "Erro: Divisão por zero"
      end
    end
  }

  if operacoes[operacao] then return operacoes[operacao](a, b)
    else return nil, "Operação inválida"
  end
end

-- Exemplo de uso
local resultado, erro = avaliar("somar", 2, 3)
if erro then print(erro) else print(resultado) end  -- 5

resultado, erro = avaliar("dividir", 2, 0)
if erro then print(erro) else print(resultado) end  -- Erro: Divisão por zero

```
