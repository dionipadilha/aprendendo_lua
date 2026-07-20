**Guia de Estudos para a Linguagem de Programação Lua**

**Objetivo:** Este guia de estudos tem como objetivo fornecer uma abordagem estruturada para aprender a linguagem de programação Lua, adequada para iniciantes e para quem já possui alguma experiência em programação. (Se você está começando do absoluto zero, faça antes o roteiro guiado de 3 dias em [`comece_aqui.md`](comece_aqui.md).) A ordem das seções segue a trilha de `roteiro_de_estudos.yml`: em particular, metaprogramação (metatabelas) vem **antes** de orientação a objetos, porque POO em Lua é construída sobre metatabelas.

**1. Introdução a Lua**
Lua é uma linguagem de script leve e de alto nível, projetada para sistemas embarcados e programação de propósito geral. É conhecida por sua simplicidade, eficiência e facilidade de integração com outras linguagens. A sintaxe de Lua é direta e minimalista, tornando-a acessível para programadores iniciantes e, ao mesmo tempo, oferecendo recursos poderosos para usuários avançados.

Exemplos práticos: pasta [`basico/`](../basico/).

**2. Conceitos Básicos**
Em sua essência, Lua utiliza uma sintaxe procedural semelhante à do C, que inclui variáveis, estruturas de controle (laços e condicionais), funções e tipos de dados básicos, como números, strings, tabelas e booleanos. A compreensão desses conceitos fundamentais forma a base para tarefas de programação mais complexas em Lua.

```lua
-- Exemplo de variáveis e tipos básicos em Lua
local num = 42
local str = "Olá, Lua!"
local tbl = {1, 2, 3}
local bool = true
```

Exemplos práticos: pasta [`basico/`](../basico/).

**3. Estruturas de Controle**
Lua oferece suporte às estruturas de controle tradicionais, como condicionais if-else, laços for e while e iteradores. Essas estruturas permitem que os programadores controlem o fluxo de seus programas com base em condições e processem iterativamente dados armazenados em tabelas ou arrays.

```lua
-- Exemplo de estruturas de controle em Lua
if num > 0 then
  print("O número é positivo")
elseif num < 0 then
  print("O número é negativo")
else
  print("O número é zero")
end

for i = 1, 5 do
  print("Iteração:", i)
end
```

Exemplos práticos: pasta [`controle_de_fluxo/`](../controle_de_fluxo/) — `lacos.lua` traz os quatro laços e o `break` em versão executável.

**4. Funções**
Em Lua, funções são valores de primeira classe, o que permite que sejam atribuídas a variáveis, passadas como argumentos e retornadas como resultados. Funções também podem ser anônimas (sem nome), e qualquer função — anônima ou não — pode capturar variáveis do escopo em que foi criada, formando uma clausura (veja `funcoes/clausuras.lua`). Compreender funções é essencial para escrever programas Lua reutilizáveis e modulares.

```lua
-- Exemplo de funções em Lua
local function somar(a, b)
  return a + b
end

local multiplicar = function(x, y)
  return x * y
end

print("Resultado da soma:", somar(3, 5))
print("Resultado da multiplicação:", multiplicar(2, 4))
```

Exemplos práticos: pasta [`funcoes/`](../funcoes/) — as regras de ajuste de múltiplos retornos, a maior pegadinha de funções em Lua, estão em `multiplos_retornos.lua`.

**5. Tabelas e Estruturas de Dados**
Tabelas são a principal estrutura de dados de Lua, combinando capacidades de array e de dicionário. Elas podem armazenar valores de tipos mistos, tornando-as versáteis para representar arrays, conjuntos, registros e até objetos. O domínio das tabelas é essencial para a manipulação eficaz de dados e a estruturação de dados complexos em Lua.

```lua
-- Exemplo de tabelas em Lua
local pessoa = {
  nome = "Alice",
  idade = 30,
  contatos = {"email@exemplo.com", "telefone: 123-456-7890"}
}

print("Nome:", pessoa.nome)
print("Idade:", pessoa.idade)
print("Contatos:", table.concat(pessoa.contatos, ", "))
```

Exemplos práticos: pasta [`tabelas/`](../tabelas/) — não deixe de ver as armadilhas de `#` com buracos (`buracos_e_comprimento.lua`) e a diferença entre referência e cópia (`referencias_e_copias.lua`).

**6. Metaprogramação**
A metaprogramação em Lua envolve técnicas como metatables e reflexão, permitindo a modificação dinâmica de comportamento em tempo de execução. Essa capacidade é particularmente útil para criar linguagens de domínio específico (DSLs), implementar estruturas de dados avançadas e aumentar a expressividade e a flexibilidade do código. É também o alicerce da orientação a objetos em Lua — por isso este tópico vem antes da POO.

```lua
-- Exemplo de metatables em Lua para sobrecarga de operadores
local mt = {}

function mt.__add(v1, v2)
  local resultado = {x = v1.x + v2.x, y = v1.y + v2.y}
  -- A nova tabela recebe a mesma metatable, herdando __tostring
  return setmetatable(resultado, mt)
end

function mt.__tostring(v)
  return "(" .. v.x .. ", " .. v.y .. ")"
end

local vetor = setmetatable({x = 10, y = 20}, mt)
local vetor2 = {x = 5, y = 15}

local resultado = vetor + vetor2
print("Resultado:", resultado)  -- Saída: Resultado: (15, 35)
```

Exemplos práticos: pasta [`metatabelas/`](../metatabelas/) — o `README.md` de lá indexa todos os metamétodos cobertos, arquivo por arquivo.

**7. Programação Orientada a Objetos**
Lua oferece suporte à programação orientada a objetos (POO) por meio das metatabelas da seção anterior — em especial o metamétodo `__index` — permitindo que os desenvolvedores implementem classes, herança e polimorfismo. Embora os recursos de POO de Lua sejam diferentes dos das linguagens mais populares, eles fornecem ferramentas poderosas para estruturar aplicações maiores.

```lua
-- Exemplo de POO básica em Lua usando metatables
local Animal = {}
Animal.__index = Animal

function Animal:novo(nome)
  local obj = { nome = nome }
  return setmetatable(obj, self)
end

function Animal:falar()
  print("Som de animal")
end

local cachorro = Animal:novo("Cachorro")
cachorro:falar()  -- Saída: Som de animal
```

Exemplos práticos: pasta [`poo/`](../poo/).

**8. Módulos e Pacotes**
Lua utiliza um sistema de módulos para organizar o código em unidades reutilizáveis. Módulos encapsulam funções e variáveis relacionadas, promovendo a organização e o reaproveitamento do código. O sistema de gerenciamento de pacotes de Lua facilita a integração de bibliotecas de terceiros, ampliando as capacidades da linguagem para além de sua biblioteca padrão.

```lua
-- Exemplo de módulo e require em Lua
-- Arquivo: meumodulo.lua
local M = {}

function M.dizerOla()
  print("Olá do meu módulo!")
end

return M
```

```lua
-- Outro script Lua usando o módulo
local meumodulo = require("meumodulo")
meumodulo.dizerOla()  -- Saída: Olá do meu módulo!
```

Exemplos práticos: pasta [`modulos/`](../modulos/) — o par `modulo.lua`/`usando_require.lua` demonstra também o cache do `require` em `package.loaded`.

**9. Tratamento de Erros**
Lua sinaliza erros com `error` e os captura em modo protegido com `pcall`/`xpcall`. Dominar esse mecanismo — incluindo objetos de erro, o nível do erro e asserções — é o que separa scripts frágeis de programas que falham com mensagens claras.

```lua
-- Exemplo de pcall em Lua
local ok, erro = pcall(function()
  error("algo deu errado")
end)
print(ok, erro)  -- Saída: false  ...: algo deu errado
```

Exemplos práticos: pasta [`erros/`](../erros/) — o `README.md` de lá indexa `error`, `assert`, `pcall`, `xpcall` e a construção de um try/except.

**10. Entrada e Saída**
A biblioteca `io` cobre leitura e escrita de arquivos, nos estilos implícito (`io.read`/`io.write`) e orientado a objetos (`arquivo:read`/`arquivo:write`). O Lua 5.4 acrescenta as variáveis `<close>`, que garantem o fechamento do arquivo mesmo em caso de erro.

Exemplos práticos: pastas [`io/`](../io/) (arquivos) e [`sistema/`](../sistema/) (data e hora, relógio, esperas e números aleatórios).

**11. Desempenho e Otimização**
Lua foi projetada para ter bom desempenho, com baixo consumo de memória e um modelo de execução eficiente. Técnicas como tornar variáveis locais, otimizar laços e compreender o mecanismo de coleta de lixo (garbage collection) de Lua podem melhorar significativamente o desempenho de programas em ambientes com recursos limitados.

```lua
-- Exemplo de otimização de código Lua
local function calcularSoma(n)
  local soma = 0
  for i = 1, n do
    soma = soma + i
  end
  return soma
end

print("Soma dos 100 primeiros números:", calcularSoma(100))
```

Exemplos práticos: pasta [`gc/`](../gc/) (com visão geral no `README.md` de lá).

**12. Testes**
Exemplos autoverificáveis com `assert` são o primeiro passo; o passo seguinte é organizar casos de teste em um framework, ainda que mínimo, com contagem de aprovados e reprovados e código de saída correto para a integração contínua.

Exemplos práticos: pasta [`testes/`](../testes/) — um mini-framework de teste unitário (`teste_unitario_basico.lua`) e uma suíte que o usa (`suite_de_testes.lua`).

**13. Padrões de Projeto e SOLID**
Com POO e módulos dominados, vale estudar como organizar programas maiores: os padrões de projeto clássicos (fábrica, observador, estratégia, comando, MVC, máquina de estados etc.) e os princípios SOLID, todos implementados em Lua neste repositório.

Exemplos práticos: pastas [`padroes/`](../padroes/) (16 padrões) e [`solid/`](../solid/) (um arquivo por princípio, com a violação e o redesenho lado a lado).

**14. Tópicos Avançados**
Os tópicos avançados de programação em Lua incluem concorrência baseada em corrotinas (coroutines) para tarefas assíncronas, a incorporação de Lua em aplicações maiores (como motores de jogos) e a integração de Lua com C/C++ para operações críticas em desempenho. Esses tópicos atendem a desenvolvedores que buscam explorar todo o potencial de Lua em diversos domínios de aplicação.

```lua
-- Exemplo de uso de corrotinas em Lua
local co = coroutine.create(function()
  for i = 1, 3 do
    print("Contagem da corrotina:", i)
    coroutine.yield()
  end
end)

coroutine.resume(co)  -- Saída: Contagem da corrotina: 1
coroutine.resume(co)  -- Saída: Contagem da corrotina: 2
coroutine.resume(co)  -- Saída: Contagem da corrotina: 3
```

Exemplos práticos: pasta [`corrotinas/`](../corrotinas/) — o uso clássico como gerador (`coroutine.wrap` em `for ... in`) está em `gerador_com_wrap.lua`. Para integração com o mundo externo, veja [`banco_de_dados/`](../banco_de_dados/) (SQLite via CLI).

**15. Projetos Práticos**
A melhor forma de consolidar o aprendizado é aplicá-lo em projetos completos, com módulos, testes e README próprios.

Exemplos práticos: pasta [`projetos/`](../projetos/) — `pluralizador/` (regras e exceções de plural em inglês), `json/` (codificador e decodificador de JSON) e `equipe/` (classes e agentes).
