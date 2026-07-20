# Manipulação de Strings em Lua

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

**Atenção — bytes vs caracteres:** `#` e `string.len` contam **bytes**, não
caracteres. `"Lua é incrível"` tem 14 caracteres, mas 16 bytes, porque em
UTF-8 os acentos `é` e `í` ocupam 2 bytes cada. Para trabalhar com
caracteres de verdade, use a biblioteca `utf8` (Lua 5.3+):

```lua
-- Contagem correta de caracteres com a biblioteca utf8:
local str = "Lua é incrível"
print(#str)           --> 16 (bytes)
print(utf8.len(str))  --> 14 (caracteres)
assert(#str == 16 and utf8.len(str) == 14)

-- Percorrer caracteres (não bytes):
for _, codigo in utf8.codes("éí") do
  io.write(utf8.char(codigo), " ") --> é í
end
print()

-- Fatiar por caractere: utf8.offset converte posição de caractere em byte:
local inicio = utf8.offset(str, 5) -- 5º caractere ("é")
print(str:sub(inicio, inicio + 1)) --> é (2 bytes)
```

```lua
-- Comprimento de string vazias:
local str = ""
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
print(str:upper()) --> LUA é INCRíVEL
print(str:lower()) --> lua é incrível
```

**Atenção:** `upper` e `lower` operam **byte a byte** e não convertem
caracteres acentuados de UTF-8 — o `é` e o `í` ficam como estão (por isso
`INCRíVEL`, e não `INCRÍVEL`). O `lower` acima só "funciona" porque o único
caractere maiúsculo da frase é o `L`, que é ASCII.

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
-- %a+ casa QUALQUER sequência de letras — inclusive "O", "o" e "e",
-- por isso o contador mostra 7 substituições:
local str = "O gato, o rato e o elefante"
print(str:gsub("%a+", "Animal"))
--> Animal Animal, Animal Animal Animal Animal Animal	7

-- Para substituir apenas palavras com 3 letras ou mais, exija-as no padrão:
print(str:gsub("%a%a%a+", "Animal")) --> O Animal, o Animal e o Animal	3
```

```lua
-- Substituir formatos numéricos, monetários:
local str = "O preço é R$ 100"
print(str:gsub("(%d+)", "%1,00")) --> O preço é R$ 100,00	1
```

```lua
-- Uso de escape em padrões:
local str = "100%"
print(str:gsub("%%", " por cento")) --> 100 por cento	1
```

> **Nota:** os exemplos abaixo estendem a biblioteca `string` global
> (`function string.capitalize(...)`) por concisão didática — assim o
> método fica disponível como `str:capitalize()`. Em código de produção,
> prefira funções locais (como faz `cadeias_de_texto.lua`): modificar
> tabelas globais afeta o programa inteiro.

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
  return (str:gsub("(%a)([%w_']*)", function(primeira, resto)
    return string.upper(primeira)..string.lower(resto) end)
  )
end
local str = "bob no país das maravilhas"
local nomeProprio = str:titleize()
print(nomeProprio) --> Bob No PaíS Das Maravilhas
```

**Atenção:** repare no `PaíS`. Como `%a` e `%w` só casam letras **ASCII**,
o `í` de "país" interrompe o casamento no meio da palavra e o `s` seguinte é
tratado como início de uma nova palavra — e capitalizado. Para capitalizar
texto acentuado corretamente é preciso percorrer os caracteres com a
biblioteca `utf8` (veja a seção de bytes vs caracteres, no início).

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
