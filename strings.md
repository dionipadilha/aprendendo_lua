## Manipulação de Strings em Lua

```lua
-- Concatenação simples:
local str1 = "Olá"
local str2 = " Mundo"
local frase = str1 .. str2
print(frase) --> Olá Mundo
```

```lua
-- Concatenação com especificadores de formato:
local nome = "Bob"
local idade = 30
local str = "Olá, %s! Você tem %d anos."
print(str:format(nome, idade)) --> Olá, Bob! Você tem 30 anos.
```

```lua
-- Concatenação de itens de uma tabela:
local nomes = {"Ana", "Bob", "Carlos"}
local nomesConcatenados = table.concat(nomes, ", ")
print(nomesConcatenados) --> Ana, Bob, Carlos
```

```lua
-- Serialização de tabelas:
local aluno = {nome = "Bob", idade = 30}
local str = "Nome: %s; Idade: %d"
print(str:format(aluno.nome, aluno.idade)) --> Nome: Bob; Idade: 30
```

```lua
-- Comprimento de strings:
local str = "Lua é incrível"
print(str:len()) --> 16
print(#str) --> 16
```

```lua
-- Comprimento de string vazias:
local str= ""
print(#str) --> 0
```

```lua
-- Use operadores de comparação:
local str1 = "lua"
local str2 = "Lua"
print(str1 == str2) --> false
```

```lua
-- Conversão para maiúsculas e minúsculas:
local str = "Lua é incrível"
print(str:upper()) --> LUA É INCRÍVEL
print(str:lower()) --> lua é incrível
```

```lua
-- Normalizar para comparação:
local str1 = "lua"
local str2 = "Lua"
print(str1:lower() == str2:lower()) --> true
```

```lua
-- Reversão de strings
local str = "Lua é incrível"
print(str:reverse()) --> levírcni é auL
```

```lua
-- Encontrar posição de um padrão:
local str = "Lua é incrívelmente fácil"
local inicio, fim = str:find("incrível")
print(inicio, fim) --> 8 16
```

```lua
-- Obter substring:
local str = "Lua é incrívelmente fácil"
print(str:sub(8, 16)) --> incrível
```

```lua
-- Uso de índices negativos:
local str = "Lua é incrívelmente fácil"
print(str:sub(-6)) --> fácil
```

```lua
-- Substituição simples:
local str = "Lua é fácil"
print(str:gsub("fácil", "poderosa")) --> Lua é poderosa 1
```

```lua
-- Substituir todas as ocorrências:
local str = "O gato, o rato e o elefante"
print(str:gsub("(%a+)", "Animal")) --> Animal, Animal e Animal 7
```

```lua
-- Substituir formatos numéricos, monetários:
local str = "O preço é R$ 100"
print(str:gsub("(%d+)", "%1,00")) --> O preço é R$ 100,00
```

```lua
-- Uso de escape em padrões:
local str = "100%"
print(str:gsub("%%", " por cento")) --> 100 por cento
```

```lua
-- Formatação de Títulos:
function string.capitalize(str)
  return (str:gsub("^%l", string.upper))
end
local str = "bob no país das maravilhas"
local titulo = str:capitalize()
print(titulo) --> Bob no país das maravilhas
```

```lua
-- Formatação de Nomes Próprios:
function string.titleize(str)
  return (str:gsub("(%a)([%w_']*)", function(first, rest)
    return string.upper(first)..string.lower(rest) end)
  )
end
local str = "bob no país das maravilhas"
local nomeProprio = str:titleize()
print(nomeProprio) --> Bob No País Das Maravilhas
```

```lua
-- Capturar partes da string:
local str = "Nome: Bob; Idade: 30"
for chave, valor in str:gmatch("(%w+): *(%w+)") do
  print(chave, valor) --> Nome Bob, Idade 30
end
```

```lua
-- Iterar sobre palavras:
local str = "Lua é incrível"
for palavra in str:gmatch("%S+") do
  print(palavra) --> Lua, é, incrível
end
```

```lua
-- Iterar sobre caracteres:
local str = "string"
for caractere in str:gmatch(".") do
  print(caractere) --> s, t, r, i, n, g
end
```

```lua
-- Remover espaços em branco no início e no final:
function string.trim(str)
  return str:match("^%s*(.-)%s*$")
end
local str = "    Olá, Mundo!    "
print(str:trim()) --> Olá, Mundo!
print(#str, #(str:trim())) --> 20 12
```
