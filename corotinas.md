# Noções básicas de Co-rotinas em Lua

## O Poder Oculto da Linguagem Lua

O poder da linguagem Lua reside em sua simplicidade e elegância, mas essa
simplicidade não significa falta de recursos. As co-rotinas em Lua oferecem um
mecanismo poderoso para gerenciar a execução concorrente de forma leve e
eficiente.

Co-rotinas são um mecanismo de _multitarefa cooperativa_.
Podemos dizer que elas são "linhas de execução independentes dentro de um
programa, que possuem suas próprias variáveis locais e rastreiam seu estado de
execução".

Desse modo, oferecem uma alternativa às _threads_ para tarefas em que a
_verdadeira concorrência_ não é necessária.

## Explorando o Ciclo das Co-rotinas

As Co-rotinas são objetos do tipo `thread`, atribuindo um identificador para
cada nova instância.
Para criar e executar uma co-rotina, usaremos as seguintes funções:

- `create`: criar uma nova co-rotina.
- `resume`: (re)inicia a execução de uma co-rotina.

```lua
local co = coroutine.create(function ()
  print("Hi")
end)
print(co) --> thread: id
coroutine.resume(co) --> Hi
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

Co-rotinas são executadas em modo protegido. Portanto, se houver algum erro
dentro de uma co-routina, Lua não mostrará a mensagem de erro, mas a retornará
para a chamada de `resume`.

```lua
local co = coroutine.create(function()
  assert(1 > 2)
end)

local try, exception = coroutine.resume(co)
if not try then print(exception) end --> assertion failed!

print("finally ...") --> finally ...
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
print(coroutine.resume(co)) --> true	2
print(coroutine.status(co)) --> suspended

print(coroutine.resume(co)) --> true	3
print(coroutine.status(co)) --> dead

print(coroutine.resume(co)) --> false	cannot resume dead coroutine
print(coroutine.status(co)) --> dead
```

## Multitarefa Cooperativa

Um recurso útil em Lua é que um par `resume`-`yield` pode trocar dados entre si.

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

local c2 = coroutine.create(function(n)
  coroutine.yield(n + 1)
end)

local _, y = coroutine.resume(c1, 5)
print(coroutine.resume(c2, y)) --> true 11
```

## Conclusão

As co-rotinas em Lua são uma ferramenta poderosa para gerenciar a execução
concorrente de forma eficiente. Utilizando as funções create, resume, e yield,é
possível criar fluxos de execução independentes que cooperam entre si,
oferecendo uma alternativa leve às threads tradicionais. As co-rotinas permitem
a criação de programas mais organizados e fáceis de manter, sem a complexidade
adicional das threads.

---
- Licença: Totalmente livre para usar e editar, mas o autor agradece a citação da fonte:
- Autor: Dioni Padilha - dionipdl@gmail.com
- Data: 15/05/2024
