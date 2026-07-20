# Noções básicas de Co-rotinas em Lua

## Co-rotinas da Linguagem Lua

As co-rotinas em Lua oferecem um mecanismo poderoso para gerenciar a execução concorrente de forma leve e eficiente, sem a complexidade das **threads** ou a necessidade de gerenciamento de múltiplos fluxos de controle. Elas utilizam um modelo de **multitarefa cooperativa**, em que as tarefas cedem explicitamente o controle para outras, garantindo uma execução mais controlada e previsível. Podemos entender as co-rotinas como "linhas de execução independentes dentro de um programa, que possuem suas próprias variáveis locais e rastreiam seu estado de execução". Elas são uma excelente alternativa quando a **verdadeira concorrência** não é necessária.

## Explorando o Ciclo das Co-rotinas

Para criar e executar uma co-rotina, usamos as seguintes funções:
- `create`: cria uma nova co-rotina.
- `resume`: (re)inicia a execução de uma co-rotina.

### Exemplo Básico:
```lua
local co = coroutine.create(function ()
  print("Hi")
end)
coroutine.resume(co) --> Hi
```

As co-rotinas são objetos do tipo `thread`, e cada nova instância recebe um identificador exclusivo. 
```lua
local co = coroutine.create(function () end)
print(co)            --> thread: id
```

As co-rotinas podem estar em um de três estados:
- **`suspended`**: co-rotina aguardando iniciar ou continuar sua execução.
- **`running`**: co-rotina está em execução.
- **`dead`**: co-rotina totalmente finalizada.

### Exemplo de Status:
```lua
local co = coroutine.create(function ()
  print("running")
end)
print(coroutine.status(co)) --> suspended
coroutine.resume(co)        --> running
print(coroutine.status(co)) --> dead
```

## Tratando Erros de Execução em Co-rotinas

As co-rotinas em Lua são executadas em modo protegido. Portanto, se ocorrer um erro dentro de uma co-rotina, Lua não exibirá a mensagem de erro diretamente, mas retornará a mensagem para a função `resume`.

### Exemplo de Erro:
```lua
local co = coroutine.create(function()
  assert(1 > 2)
end)
local try, exception = coroutine.resume(co)
if not try then print(exception) end --> assertion failed!
print("finally ...")                 --> finally ...
```

### Alternativa: Usando `pcall` para Tratamento de Erros
Você também pode usar `pcall` para capturar erros de forma mais segura:
```lua
local try, exception = pcall(function() assert(1 > 2) end)
if not try then
  print(exception) -- Exibe o erro sem interromper o programa
end
```

## Retomando a Execução e "Colhendo" Valores

A função `yield` permite:
- Suspender uma co-rotina em execução para que ela possa ser retomada mais tarde.
- "_Colher_" os valores obtidos durante a retomada da execução da co-rotina.

### Exemplo de Yield e Resumo:
```lua
local co = coroutine.create(function ()
  for i = 1, 3 do
    coroutine.yield(i)
  end
end)
print(coroutine.resume(co)) --> true	1
print(coroutine.status(co)) --> suspended
```

Quando retomada pela função `resume`, a co-rotina será executada até o próximo `yield` ou até o seu final.

### Exemplo de Execução Contínua:
```lua
-- Primeira retomada
print(coroutine.resume(co)) --> true	2
print(coroutine.status(co)) --> suspended

-- Segunda retomada
print(coroutine.resume(co)) --> true	3
print(coroutine.status(co)) --> dead

-- Tentativa de retomada após término
print(coroutine.resume(co)) --> false	cannot resume dead coroutine
print(coroutine.status(co)) --> dead
```

## Multitarefa Cooperativa

A comunicação entre co-rotinas pode ser feita com o uso combinado de `resume` e `yield`, permitindo o envio e recebimento de valores. Esse comportamento é semelhante ao uso de funções geradoras ou multitarefa cooperativa em outras linguagens de programação.

### Exemplo de Multitarefa:
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

Esse mecanismo permite que as co-rotinas se comuniquem e cooperem, como no exemplo a seguir:

### Exemplo de Cooperação entre Co-rotinas:
```lua
local c1 = coroutine.create(function(n)
  coroutine.yield(n * 2)
end)

local c2 = coroutine.create(function(n)
  coroutine.yield(n + 1)
end)

local _, y = coroutine.resume(c1, 5)
print(coroutine.resume(c2, y)) --> true 11
```

## Exemplos Práticos de Uso

### Simulação de Tarefas em um Jogo
Em um cenário de jogo, podemos usar co-rotinas para simular a movimentação de diferentes personagens:

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

Podemos usar co-rotinas para ler dados em blocos de forma eficiente, sem bloquear a execução do programa:

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

### Agendamento de Tarefas

Usando co-rotinas, podemos criar um simples agendador de tarefas cooperativas:

```lua
local function task(name, duration)
  for i = 1, duration do
    print(name .. " step " .. i)
    coroutine.yield()
  end
end

local scheduler = {}
scheduler.__index = scheduler

function scheduler.new()
  local self = setmetatable({}, scheduler)
  self.tasks = {}
  return self
end

function scheduler:add_task(co)
  table.insert(self.tasks, co)
end

function scheduler:run()
  while #self.tasks > 0 do
    for i = #self.tasks, 1, -1 do
      local status, res = coroutine.resume(self.tasks[i])
      if not status or coroutine.status(self.tasks[i]) == "dead" then
        table.remove(self.tasks, i)
      end
    end
  end
end

-- Create tasks
local task1 = coroutine.create(function() task("Task 1", 3) end)
local task2 = coroutine.create(function() task("Task 2", 5) end)

-- Schedule tasks
local sched = scheduler.new()
sched:add_task(task1)
sched:add_task(task2)

-- Run scheduler
sched:run()
```

### Máquinas de Estados Finitos

Co-rotinas podem ser usadas para implementar uma máquina de estados de forma simples:

```lua
local states = {}

function states.idle()
  print("Entering idle state")
  while true do
    local event = coroutine.yield()
    if event == "start" then
      return states.running
    end
  end
end

function states.running()
  print("Entering running state")
  while true do
    local event = coroutine.yield()
    if event == "stop" then
      return states.idle
    end
  end
end

local function state_machine()
  local state = states.idle
  while true do
    state = state()
  end
end

local sm = coroutine.create(state_machine)

coroutine.resume(sm)
coroutine.resume(sm, "start")
coroutine.resume(sm)
coroutine.resume(sm, "stop")
coroutine.resume(sm)
```

## Conclusão

- As co-rotinas são uma ferramenta poderosa para gerenciar a execução concorrente de forma eficiente, sem a complexidade das **threads**.
- As funções `create`, `resume`, e `yield` permitem criar fluxos de execução independentes que colaboram entre si.
- As co-rotinas permitem a criação de programas mais organizados e fáceis de manter, sem a complexidade adicional das threads.
