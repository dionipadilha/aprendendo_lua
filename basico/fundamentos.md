# Primeiros Passos com Lua

Lua é uma linguagem de script versátil e eficiente.

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

```lua
local numero = 10
local texto = "Lua"
local booleano = true
local tabela = {item1, item2, item3} -- lista, array
local tabela = {chave_1 = "str", chave_2 = 30} -- dicionário, mapa
local x = nil -- representa a ausência de valor
```

- Condicional:

```lua
if numero > 5 then print("O número é maior que 5")
elseif numero < 5 then print("O número é menor que 5")
else print("O número é 5")
end
```

- Estruturas de repetição

```lua
-- Laço for:
for i = 1, 5 do print(i) end

-- Laço while:
local i = 1
while i <= 5 do
  print(i)
  i = i + 1
end
```

- Funções

```lua
-- Lua suporta funções de primeira classe e closures.

-- Definição de funções
function saudar(nome)
  print("Olá, " .. nome)
end

-- Invocação de funções
saudar("Alice")
```

- Tabelas

```lua
-- Em Lua, as tabelas são o único mecanismo de estruturação de dados.

-- lista, arrays
local lista = {item1, item2, item3}
print(lista[1]) --> item1

-- mapa, dicionários
local tabela = {chave1 = "valor1", chave2 = "valor2"}
print(tabela["chave1"]) --> valor1

-- objetos
local pessoa = {nome = "bob", idade = 30}
print(pessoa.nome)  --> bob
print(pessoa.idade)  --> 30
```

- Tratamento de erros

```lua
-- Tratamento de erros com a função pcall
if pcall(funcao_que_pode_falhar) then print("Sucesso")
else print("Falha")
end
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
function avaliar(operacao, a, b)
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
