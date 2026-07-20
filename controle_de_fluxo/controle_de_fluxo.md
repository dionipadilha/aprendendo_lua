O controle de fluxo em Lua é similar a outras linguagens de programação e oferece diversas estruturas para controlar a execução do seu código. As principais estruturas de controle em Lua são:

**Estruturas Condicionais:**

- **if:** Permite executar um bloco de código se uma condição for verdadeira.
- **elseif:** Permite verificar outras condições após um `if`.
- **else:** Executa um bloco de código se todas as condições anteriores forem falsas.
- **end:** Finaliza a estrutura condicional.

Exemplo:

```lua
if x > 10 then
  print("x é maior que 10")
elseif x == 10 then
  print("x é igual a 10")
else
  print("x é menor que 10")
end
```

**Laços de Repetição:**

- **for:** Executa um bloco de código um número determinado de vezes (forma numérica) ou percorre os elementos de uma coleção (forma genérica, com `in`).
- **while:** Testa a condição **antes** de cada iteração e executa o bloco enquanto ela for verdadeira.
- **repeat ... until:** uma estrutura **única** (não são dois comandos separados): executa o bloco **ao menos uma vez** e o repete **enquanto a condição do `until` for falsa**; quando a condição se torna verdadeira, o laço termina.

Exemplo:

```lua
for i = 1, 10 do
  print(i)
end

-- Imprime números de 1 a 10

while x < 10 do
  x = x + 1
end

-- Incrementa x enquanto for menor que 10

local tentativas = 0
repeat
  tentativas = tentativas + 1
until tentativas >= 3

-- O bloco do repeat executa ao menos uma vez,
-- mesmo que a condição já comece verdadeira;
-- aqui, executa 3 vezes (tentativas termina em 3).
```

**Outras Estruturas:**

- **break:** Sai de um loop de repetição.
- **return:** Retorna um valor de uma função.
- **goto:** Pula para um rótulo específico no código (veja o idioma `goto continue` em `goto.lua`).

**O que conta como verdadeiro em uma condição:**

Uma condição em Lua pode ser **qualquer expressão**, não apenas booleanos. A regra é simples:

- Apenas `nil` e `false` contam como **falsos**.
- **Todos** os outros valores contam como **verdadeiros** — inclusive `0` e a string vazia `""` (diferente de linguagens como C, Python e JavaScript).

```lua
if 0 then print("0 é verdadeiro em Lua") end    -- imprime!
if "" then print('"" também é verdadeiro') end  -- imprime!
if nil then print("nunca executa") end          -- não imprime
if false then print("nunca executa") end        -- não imprime
```

Veja o exemplo executável em `valores_verdadeiros.lua`.

**Observações:**

- Os blocos de código em Lua são delimitados por `do` e `end`.
- É importante usar indentação para organizar o código e facilitar a leitura.
