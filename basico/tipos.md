## Tipos de dados básicos em Lua

**Observações:**

- Lua é uma linguagem de tipagem dinâmica: as variáveis não têm tipo fixo — a mesma variável pode guardar um número agora e uma string depois. (Os valores em si sempre têm um tipo definido.)
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
local ehVerdadeiro = true
local ehFalso = false

if ehVerdadeiro then
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

**Inteiro vs float (Lua 5.4):**

- O tipo `number` tem duas representações internas: **integer** e **float**.
- `type()` devolve `"number"` para ambas; quem as distingue é `math.type()`, que devolve `"integer"`, `"float"` ou `nil` (quando o valor não é um número).
- A divisão `/` e a exponenciação `^` **sempre** produzem float, mesmo entre inteiros e mesmo quando o resultado é exato (`4 / 2` é `2.0`). Já a divisão inteira `//` preserva o subtipo: inteiro `//` inteiro produz inteiro.
- `math.tointeger(x)` converte um float de valor inteiro para o subtipo integer; devolve `nil` quando a conversão não é possível.

**Exemplo:**

```lua
assert(math.type(42) == "integer")
assert(math.type(3.14) == "float")
assert(math.type("oi") == nil)   -- não é número

-- `/` e `^` sempre produzem float:
assert(4 / 2 == 2.0 and math.type(4 / 2) == "float")
assert(2 ^ 3 == 8.0 and math.type(2 ^ 3) == "float")

-- `//` preserva inteiro entre inteiros:
assert(7 // 2 == 3 and math.type(7 // 2) == "integer")
assert(math.type(7.0 // 2) == "float")   -- com float, produz float (3.0)

-- Conversão explícita float -> integer:
assert(math.tointeger(2.0) == 2)
assert(math.tointeger(2.5) == nil)

-- Na comparação, inteiro e float de mesmo valor são iguais:
assert(2 == 2.0)
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

- Representa uma corrotina: uma linha de execução **cooperativa**, que pausa (`yield`) e retoma (`resume`) sob controle do programa.
- Apenas uma corrotina executa por vez — não há paralelismo. Veja a pasta `corrotinas/`.

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
