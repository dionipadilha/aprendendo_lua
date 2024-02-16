## Tipos de dados básicos em Lua

**Observações:**

- Lua é uma linguagem de tipagem dinâmica, o que significa que o tipo de um valor pode ser alterado durante a execução do programa.
- A função `type()` pode ser usada para verificar o tipo de um valor.

Em Lua, existem oito tipos de dados básicos:

**1. nil:**

- Representa um valor nulo.
- É o único valor do tipo `nil`.
- Indica a ausência de um valor ou a inicialização de uma variável.

**Exemplo:**

```lua
local variavel = nil
```

**2. boolean:**

- Representa valores booleanos, `true` ou `false`.
- Usado em expressões condicionais e outros contextos que exigem um valor binário.

**Exemplo:**

```lua
local isTrue = true
local isFalse = false

if isTrue then
  print("Verdadeiro")
else
  print("Falso")
end
```

**3. number:**

- Representa números inteiros ou reais.
- Pode ser usado em operações matemáticas, como soma, subtração, multiplicação e divisão.

**Exemplo:**

```lua
local numeroInteiro = 10
local numeroReal = 3.14

print(numeroInteiro + numeroReal)
```

**4. string:**

- Representa sequências de caracteres.
- Usado para armazenar texto, como nomes, frases e mensagens.

**Exemplo:**

```lua
local nome = "João Silva"
local frase = "Olá, mundo!"

print(nome .. " disse " .. frase)
```

**5. function:**

- Representa blocos de código que podem ser executados.
- Permite definir funções personalizadas para realizar tarefas específicas.

**Exemplo:**

```lua
function soma(a, b)
  return a + b
end

local resultado = soma(2, 3)

print(resultado)
```

**6. userdata:**

- Representa dados opacos que são gerenciados por bibliotecas C.
- Usado para interagir com APIs C e bibliotecas externas.

**Exemplo:**

```lua
local bibliotecaC = require("bibliotecaC")

local userdata = bibliotecaC.criarObjeto()

bibliotecaC.destruirObjeto(userdata)
```

**7. thread:**

- Representa unidades de execução paralelas em Lua.
- Permite executar várias tarefas ao mesmo tempo.

**Exemplo:**

```lua
local thread = coroutine.create(function()
  print("Tarefa em thread")
end)

coroutine.resume(thread)
```

**8. table:**

- Representa estruturas de dados compostas por pares chave-valor.
- Usado para armazenar coleções de dados de diferentes tipos.

**Exemplo:**

```lua
local tabela = {
  nome = "João Silva",
  idade = 30,
  cidade = "Palhoça"
}

print(tabela["nome"])
```
