# Corrotinas em Lua

## Introdução

As corrotinas em Lua oferecem um mecanismo poderoso para gerenciar a execução concorrente de forma leve e eficiente, sem a complexidade das **threads** ou a necessidade de gerenciamento de múltiplos fluxos de controle. Elas utilizam um modelo de **multitarefa cooperativa**, em que as tarefas cedem explicitamente o controle para outras, garantindo uma execução mais controlada e previsível. Podemos entender as corrotinas como "linhas de execução independentes dentro de um programa, que possuem suas próprias variáveis locais e rastreiam seu estado de execução". Elas são uma excelente alternativa quando a **verdadeira concorrência** não é necessária — especialmente em jogos, simulações e sistemas em que várias tarefas precisam progredir sem o custo de threads reais.

## Explorando o Ciclo das Corrotinas

Para criar e executar uma corrotina, usamos as seguintes funções:
- `coroutine.create`: cria uma nova corrotina.
- `coroutine.resume`: (re)inicia a execução de uma corrotina.

### Exemplo Básico:
```lua
local co = coroutine.create(function ()
  print("Oi")
end)
coroutine.resume(co) --> Oi
```

As corrotinas são objetos do tipo `thread`, e cada nova instância recebe um identificador exclusivo.
```lua
local co = coroutine.create(function () end)
print(co)            --> thread: id
```

### Os Quatro Estados de uma Corrotina

Em Lua 5.4, `coroutine.status` pode retornar **quatro** estados:

- **`suspended`**: corrotina aguardando iniciar ou continuar sua execução (estado inicial após `create` e após cada `yield`).
- **`running`**: corrotina em execução — é o estado da corrotina que está rodando neste momento.
- **`normal`**: corrotina ativa, mas que não está executando — é o estado de uma corrotina que retomou **outra** corrotina e aguarda essa outra ceder ou terminar.
- **`dead`**: corrotina totalmente finalizada (ou encerrada por um erro); não pode mais ser retomada.

### Exemplo de Status:
```lua
local co = coroutine.create(function ()
  print("executando")
end)
print(coroutine.status(co)) --> suspended
coroutine.resume(co)        --> executando
print(coroutine.status(co)) --> dead
```

### Exemplo do Estado `normal`:

O estado `normal` só aparece quando uma corrotina retoma outra: enquanto a corrotina interna executa, a externa não está suspensa (não pode ser retomada) nem executando — ela está `normal`.

```lua
local externa -- declarada antes para ser visível dentro da interna

local interna = coroutine.create(function()
  -- Enquanto a interna executa, a externa que a retomou fica "normal":
  print(coroutine.status(externa)) --> normal
end)

externa = coroutine.create(function()
  print(coroutine.status(externa)) --> running
  coroutine.resume(interna)
end)

coroutine.resume(externa)
```

### Encerrando Corrotinas com `coroutine.close` (Lua 5.4)

Lua 5.4 introduziu `coroutine.close(co)`, que encerra uma corrotina no estado `suspended` sem retomá-la: as variáveis to-be-closed pendentes dela são fechadas, seus recursos são liberados e seu estado passa a ser `dead`. É útil quando decidimos não consumir o restante de uma corrotina (um gerador abandonado no meio, por exemplo).

```lua
local co = coroutine.create(function()
  coroutine.yield(1)
  coroutine.yield(2)
end)

print(coroutine.resume(co)) --> true	1
print(coroutine.close(co))  --> true
print(coroutine.status(co)) --> dead
```

## Tratando Erros de Execução em Corrotinas

As corrotinas em Lua são executadas em modo protegido. Portanto, se ocorrer um erro dentro de uma corrotina, Lua não exibirá a mensagem de erro diretamente, mas retornará `false` seguido da mensagem para quem chamou `resume`. Repare que a mensagem vem com o prefixo real `arquivo:linha:` indicando onde o erro ocorreu.

### Exemplo de Erro:
```lua
local co = coroutine.create(function()
  assert(1 > 2)
end)
local sucesso, excecao = coroutine.resume(co)
if not sucesso then print(excecao) end --> exemplo.lua:2: assertion failed!
print("finalmente ...")                --> finalmente ...
```

> **Atenção:** `pcall(coroutine.resume, co)` **não** captura erros da corrotina. Como `resume` nunca lança erro — ele **retorna** `false` e a mensagem —, nesse idioma o `pcall` sempre "dá certo" (retorna `true, false, mensagem`) e o erro passa despercebido. Verifique sempre o primeiro valor retornado pelo próprio `resume`:
>
> ```lua
> local co = coroutine.create(function()
>   error("Erro intencional")
> end)
>
> local ok, err = coroutine.resume(co)
> if not ok then
>   print("Erro na corrotina: " .. err) --> Erro na corrotina: exemplo.lua:2: Erro intencional
> end
> ```

### `pcall` para Funções Comuns

Para funções comuns (fora de corrotinas), `pcall` é a forma padrão de capturar erros:

```lua
local sucesso, excecao = pcall(function() assert(1 > 2) end)
if not sucesso then
  print(excecao) --> exemplo.lua:1: assertion failed!
end
```

## Retomando a Execução e "Colhendo" Valores

A função `yield` permite:
- Suspender uma corrotina em execução para que ela possa ser retomada mais tarde.
- "_Colher_" os valores obtidos durante a retomada da execução da corrotina.

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

Quando retomada pela função `resume`, a corrotina será executada até o próximo `yield` ou até o seu final.

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

A comunicação entre corrotinas pode ser feita com o uso combinado de `resume` e `yield`, permitindo o envio e recebimento de valores. Esse comportamento é semelhante ao uso de funções geradoras ou multitarefa cooperativa em outras linguagens de programação.

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

**Atenção:** apenas o **primeiro** `resume` inicializa os parâmetros da
função (`a = 2`, `b = 3`). Nos `resume` seguintes, os argumentos extras
viram **valores de retorno do `yield`** que estava pendente — aqui são
descartados, por isso `a - b` ainda usa `2` e `3`, e o `resume(co, 4, 5)`
não produz `-1` de novo: ele apenas conclui a função (que não retorna
nada). O recebimento de valores via `yield` é demonstrado passo a passo em
`argumentos_de_corrotinas.lua`.

Esse mecanismo permite que as corrotinas se comuniquem e cooperem, como no exemplo a seguir:

### Exemplo de Cooperação entre Corrotinas:
```lua
local c1 = coroutine.create(function(n)
  coroutine.yield(n * 2)
end)

local c2 = coroutine.create(function(n)
  coroutine.yield(n + 1)
end)

local _, y = coroutine.resume(c1, 5)
print(coroutine.resume(c2, y)) --> true	11
```

## Vantagens das Corrotinas

As corrotinas oferecem diversas vantagens:

- **Leveza e eficiência**: são mais leves que threads, com menor custo de criação e gerenciamento.
- **Controle e previsibilidade**: como a execução é cooperativa, o programador decide quando uma tarefa cede o controle, o que facilita o rastreamento e a depuração.
- **Simplicidade**: a API pequena (`create`, `resume`, `yield`, `status`, `wrap`, `close`) torna fácil escrever código concorrente sem complicação.
- **Funcionalidades específicas**: são ideais para implementar iteradores, máquinas de estados e sistemas de agendamento de tarefas.

Essas vantagens tornam as corrotinas ideais para cenários que exigem concorrência leve e onde o paralelismo não é necessário.

## Exemplos Práticos de Uso

### Simulação de Tarefas em um Jogo
Em um cenário de jogo, podemos usar corrotinas para simular a movimentação de diferentes personagens:

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

Podemos usar corrotinas para ler dados em blocos de forma eficiente, sem bloquear a execução do programa:

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

Usando corrotinas, podemos criar um simples agendador de tarefas cooperativas:

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

function agendador:adicionarTarefa(co)
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
agenda:adicionarTarefa(tarefa1)
agenda:adicionarTarefa(tarefa2)

-- Executa o agendador
agenda:executar()
```

### Máquinas de Estados Finitos

Corrotinas podem ser usadas para implementar uma máquina de estados de forma simples:

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

local function maquinaDeEstados()
  local estado = estados.ocioso
  while true do
    estado = estado()
  end
end

local maquina = coroutine.create(maquinaDeEstados)

coroutine.resume(maquina)
coroutine.resume(maquina, "iniciar")
coroutine.resume(maquina)
coroutine.resume(maquina, "parar")
coroutine.resume(maquina)
```

## Limitações e Considerações

Embora as corrotinas sejam eficientes, elas não permitem paralelismo real, ou seja, não aproveitam múltiplos núcleos de CPU. Elas são executadas de forma cooperativa em um único núcleo de processamento. Portanto, se você precisar de paralelismo real (execução em múltiplos núcleos simultaneamente), corrotinas não são adequadas — em tais casos, outras abordagens, como threads ou processos, seriam mais indicadas.

## Conclusão

- As corrotinas são uma ferramenta poderosa para gerenciar a execução concorrente de forma eficiente, sem a complexidade das **threads**.
- As funções `create`, `resume` e `yield` permitem criar fluxos de execução independentes que colaboram entre si; `status` distingue os quatro estados (`suspended`, `running`, `normal`, `dead`) e `coroutine.close` (Lua 5.4) encerra corrotinas abandonadas.
- As corrotinas permitem a criação de programas mais organizados e fáceis de manter — desde que se entenda sua principal limitação: concorrência cooperativa, sem paralelismo real.
