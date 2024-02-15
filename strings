## Manipulação de Strings

Em Lua, a manipulação de strings é uma parte fundamental, e a linguagem oferece várias funções e operadores para facilitar esse processo. Aqui estão algumas operações básicas de manipulação de strings em Lua:

**Concatenação**

- Use `..` para concatenar strings:

```lua
local str1 = "Olá"
local str2 = " Mundo"
local resultado = str1 .. str2
print(resultado)  --> Olá Mundo
```

- Use `table.concat()` para concatenar strings em uma tabela:

```lua
local nomes = {"Ana", "João", "Maria"}
local frase = table.concat(nomes, ", ")
print(frase) --> Ana, João, Maria
```

**Comprimento**

- Obter o comprimento de uma string:

```lua
local str = "Lua é incrível"
print(string.len(str))  --> 15
print(#str)  --> 15

-- string vazia
local str = ""
print(#str)  --> 0
```

**Substrings**

- Obter uma parte específica da string:

```lua
print(string.sub("Lua é incrível", 5, 9) )  --> é in
```

- Use contagem negativa para iniciar do final:

```lua
print(string.sub("Olá, Mundo!", -5)) --> Mundo!
```

**Busca de padrões**

- Encontrar a posição de um padrão em uma string:

```lua
local inicio, fim = string.find("Lua é incrível", "incrível")
print(inicio, fim)  --> 9 16
```

```lua
local str = "Lua é incrível"
local sub = "incrível"
local inicio, fim = string.find(str, sub)
if inicio then
  print("A string contém a substring.")
else
  print("A string não contém a substring.")
end
```

- Buscar a posição com opções avançadas:

```lua
-- Começa a busca na posição 1 (inclusive) e ignora maiúsculas/minúsculas
local inicio, fim = string.find("Lua é incrível", "incrível", 1, true)
print(inicio, fim) --> 5 12
```

**Substituição**

- Substituir todas as ocorrências de um padrão:

```lua
local str = "Lua é incrível"
local nova_str = string.gsub(str, "incrível", "poderosa")
print(nova_str)  --> Lua é poderosa
```

**Expressões Regulares**

- Substituições com expressões regulares:

```lua
-- Formata o valor monetário
local str = "O preço é R$ 100,00"
local nova_str = string.gsub(str, "%d+([,.]%d+)", "%02d%1s%02d", 1)
print(nova_str) --> O preço é R$ 100,00
```

**Divisão**

- Iterar sobre as ocorrências de um padrão:

```lua
local str = "Lua é incrível"
for palavra in string.gmatch(str, "%S+") do
print(palavra)
end
--> Lua
--> é
--> incrível
```

```lua
local str = "Lua é incrível"
for palavra in string.gmatch(str, "%S+", 2) do
  print(palavra)
end
--> Lua
--> é
```

- Capturar partes da string:

```lua
local str = "Nome: Alice; Idade: 30"
for chave, valor in string.gmatch(str, "(%w+): *(%w+)") do
  print(chave, valor)
end
--> Nome Alice
--> Idade 30
```

**Comparação de strings**

- Use operadores de comparação (`==`, `<`, `>`, `<=`, `>=`):

```lua
local str1 = "lua"
local str2 = "Lua"
print(str1 == str2)  --> false
```

**Conversão de Maiúsculas/Minúsculas**

- Converter para maiúsculas ou minúsculas:

```lua
local str = "Lua é incrível"
local maiusculas = string.upper(str)
local minusculas = string.lower(str)
print(maiusculas)  --> LUA É INCRÍVEL
print(minusculas)  --> lua é incrível
```

- Normalizar antes da comparação:

```lua
local str1 = "lua"
local str2 = "Lua"
if string.lower(str1) == string.lower(str2) then
  print("As strings são iguais (ignorando maiúsculas/minúsculas).")
end
```

- Formatação de Títulos:

```lua
local str = "alice no país das maravilhas"
local titulo = string.capitalize(str)
local nome_proprio = string.titleize(str)
print(titulo) --> Alice no país das maravilhas
print(nome_proprio) --> Alice No País Das Maravilhas
```

**Padrões de Escape**

- Incluir caracteres especiais em padrões de busca/substituição:

```lua
local str = "100%"
local nova_str = string.gsub(str, "%%", " por cento")
print(nova_str)  --> 100 por cento
```

```lua
local str = "10.99 USD"
local escaped_str = string.escape(str)
local pattern = "%d+%.%d+ %a+"
local match = string.match(escaped_str, pattern)
print(match)  --> 10.99 USD
```

**Formatação de Strings:**

- Formatar strings com base em especificadores de formato, semelhante ao printf em C:

```lua
local nome = "Alice"
local idade = 30
local frase = string.format("Olá, %s! Você tem %d anos.", nome, idade)
print(frase)
--> Olá, Alice! Você tem 30 anos.
```

**Remover espaços**

- Remover espaços em branco no início e no final:

```lua
local str = "   Olá, Mundo!   "
local trimmed_str = string.trim(str)
print(trimmed_str)  --> Olá, Mundo!
```
