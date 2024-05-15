# Noções básicas de Co-rotinas em Lua

## Co-rotinas da Linguagem Lua

As co-rotinas em Lua oferecem um mecanismo poderoso para gerenciar a execução concorrente de forma leve e eficiente. Elas são um mecanismo de _multitarefa cooperativa_. Podemos dizer que elas são "linhas de execução independentes dentro de um programa, que possuem suas próprias variáveis locais e rastreiam seu estado de execução". Desse modo, oferecem uma alternativa às _threads_ para tarefas em que a _verdadeira concorrência_ não é necessária.


## Explorando o Ciclo das Co-rotinas

Para criar e executar uma co-rotina, usaremos as seguintes funções:
- `create`: criar uma nova co-rotina.
- `resume`: (re)inicia a execução de uma co-rotina.

```lua
local co = coroutine.create(function ()
  print("Hi")
end)
coroutine.resume(co) --> Hi
```

As Co-rotinas são objetos do tipo `thread`, atribuindo um identificador para cada nova instância. 

```lua
local co = coroutine.create(function () end)
print(co)            --> thread: id
```

As Co-rotinas podem estar em um de três estados:
- `suspended`: co-rotina aguardando iniciar ou continuar sua execução.
- `running`: co-rotina está em execução.
- `dead`: co-rotina totalmente finalizada.

```lua
local co = coroutine.create(function ()
  print("running")
end)
print(coroutine.status(co)) --> suspended
coroutine.resume(co)        --> running
print(coroutine.status(co)) --> dead
```

## Tratando Erros de Execução em Co-rotinas

Co-rotinas são executadas em modo protegido. Portanto, se houver algum erro dentro de uma co-routina, Lua não mostrará a mensagem de erro, mas a retornará para a chamada de `resume`.

```lua
local co = coroutine.create(function()
  assert(1 > 2)
end)
local try, exception = coroutine.resume(co)
if not try then print(exception) end --> assertion failed!
print("finally ...")                 --> finally ...
```

## Retomando a Execução e "Colhendo" Valores

A função `yield` permite:
- suspender uma co-rotina em execução para que possa ser retomada mais tarde.
- "_colher_" os valores obtidos durante a retomada na execução da co-rotina.

```lua
local co = coroutine.create(function ()
  for i = 1, 3 do
    coroutine.yield(i)
  end
end)
print(coroutine.resume(co)) --> true	1
print(coroutine.status(co)) --> suspended
```

Quando retomada pela função `resume`, a co-rotina será executada até o próximo
`yield` ou até o seu final.

```lua
--
print(coroutine.resume(co)) --> true	2
print(coroutine.status(co)) --> suspended
--
print(coroutine.resume(co)) --> true	3
print(coroutine.status(co)) --> dead
--
print(coroutine.resume(co)) --> false	cannot resume dead coroutine
print(coroutine.status(co)) --> dead
```

## Multitarefa Cooperativa

Um par `resume`-`yield` permite às co-rotinas o recurso de receberem e retornarem valores, similar à forma de entrada e retorno de valores em uma função:

```lua
local co = coroutine.create(function(a, b)
  coroutine.yield(a + b)
  coroutine.yield(a - b)
end)
print(coroutine.resume(co, 2, 3)) --> true	5
print(coroutine.resume(co, 2, 3)) --> true	-1
print(coroutine.resume(co, 4, 5)) --> true
print(coroutine.resume(co, 6, 7)) --> false	cannot resume dead coroutine
```

Este recurso permite a cooperação entre co-rotinas:

```lua
local c1 = coroutine.create(function(n)
  coroutine.yield(n * 2)
end)
--
local c2 = coroutine.create(function(n)
  coroutine.yield(n + 1)
end)
--
local _, y = coroutine.resume(c1, 5)
print(coroutine.resume(c2, y)) --> true 11
```

## Exemplos Práticos de Uso

### Simulação de Tarefas em um Jogo

```lua
local function player()
  for i = 1, 3 do
    print("Player is at position " .. i)
    coroutine.yield()
  end
end

local function enemy()
  for i = 3, 1, -1 do
    print("Enemy is at position " .. i)
    coroutine.yield()
  end
end

local playerCoroutine = coroutine.create(player)
local enemyCoroutine = coroutine.create(enemy)

while coroutine.status(playerCoroutine) ~= "dead" and coroutine.status(enemyCoroutine) ~= "dead" do
  coroutine.resume(playerCoroutine)
  coroutine.resume(enemyCoroutine)
end
```

### Leitura de Dados em Blocos

```lua
local function readChunks(reader)
  while true do
    local chunk = reader()
    if not chunk then break end
    coroutine.yield(chunk)
  end
end

local function simulateFileReader(data)
  local index = 1
  return function()
    if index > #data then return nil end
    local chunk = data[index]
    index = index + 1
    return chunk
  end
end

local fileReader = simulateFileReader({"chunk1", "chunk2", "chunk3"})
local co = coroutine.create(readChunks)

while coroutine.status(co) ~= "dead" do
  local success, chunk = coroutine.resume(co, fileReader)
  if success and chunk then
    print("Read: " .. chunk)
  end
end
```

## Conclusão

- As co-rotinas em são uma ferramenta poderosa para gerenciar a execução concorrente de forma eficiente.
- As funções create, resume, e yield permitem criar fluxos de execução independentes que cooperam entre si.
- As co-rotinas permitem a criação de programas mais organizados e fáceis de manter, sem a complexidade
adicional das threads.

---
- Autor: Dioni Padilha - dionipdl@gmail.com
- Data: 15/05/2024
