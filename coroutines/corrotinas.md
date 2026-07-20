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
  print("Oi")
end)
coroutine.resume(co) --> Oi
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
  print("executando")
end)
print(coroutine.status(co)) --> suspended
coroutine.resume(co)        --> executando
print(coroutine.status(co)) --> dead
```

## Tratando Erros de Execução em Co-rotinas

As co-rotinas em Lua são executadas em modo protegido. Portanto, se ocorrer um erro dentro de uma co-rotina, Lua não exibirá a mensagem de erro diretamente, mas retornará a mensagem para a função `resume`.

### Exemplo de Erro:
```lua
local co = coroutine.create(function()
  assert(1 > 2)
end)
local sucesso, excecao = coroutine.resume(co)
if not sucesso then print(excecao) end --> assertion failed!
print("finalmente ...")                --> finalmente ...
```

### Alternativa: Usando `pcall` para Tratamento de Erros
Você também pode usar `pcall` para capturar erros de forma mais segura:
```lua
local sucesso, excecao = pcall(function() assert(1 > 2) end)
if not sucesso then
  print(excecao) -- Exibe o erro sem interromper o programa
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
local function jogador()
  for i = 1, 3 do
    print("O jogador está na posição " .. i)
    coroutine.yield()
  end
end

local function inimigo()
  for i = 3, 1, -1 do
    print("O inimigo está na posição " .. i)
    coroutine.yield()
  end
end

local corrotinaDoJogador = coroutine.create(jogador)
local corrotinaDoInimigo = coroutine.create(inimigo)

while coroutine.status(corrotinaDoJogador) ~= "dead" and coroutine.status(corrotinaDoInimigo) ~= "dead" do
  coroutine.resume(corrotinaDoJogador)
  coroutine.resume(corrotinaDoInimigo)
end
```

### Leitura de Dados em Blocos

Podemos usar co-rotinas para ler dados em blocos de forma eficiente, sem bloquear a execução do programa:

```lua
local function lerBlocos(leitor)
  while true do
    local bloco = leitor()
    if not bloco then break end
    coroutine.yield(bloco)
  end
end

local function simularLeitorDeArquivo(dados)
  local indice = 1
  return function()
    if indice > #dados then return nil end
    local bloco = dados[indice]
    indice = indice + 1
    return bloco
  end
end

local leitorDeArquivo = simularLeitorDeArquivo({"bloco1", "bloco2", "bloco3"})
local co = coroutine.create(lerBlocos)

while coroutine.status(co) ~= "dead" do
  local sucesso, bloco = coroutine.resume(co, leitorDeArquivo)
  if sucesso and bloco then
    print("Lido: " .. bloco)
  end
end
```

### Agendamento de Tarefas

Usando co-rotinas, podemos criar um simples agendador de tarefas cooperativas:

```lua
local function tarefa(nome, duracao)
  for i = 1, duracao do
    print(nome .. " passo " .. i)
    coroutine.yield()
  end
end

local agendador = {}
agendador.__index = agendador

function agendador.novo()
  local self = setmetatable({}, agendador)
  self.tarefas = {}
  return self
end

function agendador:adicionar_tarefa(co)
  table.insert(self.tarefas, co)
end

function agendador:executar()
  while #self.tarefas > 0 do
    for i = #self.tarefas, 1, -1 do
      local status, res = coroutine.resume(self.tarefas[i])
      if not status or coroutine.status(self.tarefas[i]) == "dead" then
        table.remove(self.tarefas, i)
      end
    end
  end
end

-- Cria as tarefas
local tarefa1 = coroutine.create(function() tarefa("Tarefa 1", 3) end)
local tarefa2 = coroutine.create(function() tarefa("Tarefa 2", 5) end)

-- Agenda as tarefas
local agenda = agendador.novo()
agenda:adicionar_tarefa(tarefa1)
agenda:adicionar_tarefa(tarefa2)

-- Executa o agendador
agenda:executar()
```

### Máquinas de Estados Finitos

Co-rotinas podem ser usadas para implementar uma máquina de estados de forma simples:

```lua
local estados = {}

function estados.ocioso()
  print("Entrando no estado ocioso")
  while true do
    local evento = coroutine.yield()
    if evento == "iniciar" then
      return estados.executando
    end
  end
end

function estados.executando()
  print("Entrando no estado de execução")
  while true do
    local evento = coroutine.yield()
    if evento == "parar" then
      return estados.ocioso
    end
  end
end

local function maquina_de_estados()
  local estado = estados.ocioso
  while true do
    estado = estado()
  end
end

local maquina = coroutine.create(maquina_de_estados)

coroutine.resume(maquina)
coroutine.resume(maquina, "iniciar")
coroutine.resume(maquina)
coroutine.resume(maquina, "parar")
coroutine.resume(maquina)
```

## Conclusão

- As co-rotinas são uma ferramenta poderosa para gerenciar a execução concorrente de forma eficiente, sem a complexidade das **threads**.
- As funções `create`, `resume`, e `yield` permitem criar fluxos de execução independentes que colaboram entre si.
- As co-rotinas permitem a criação de programas mais organizados e fáceis de manter, sem a complexidade adicional das threads.
