### Guia de Estudos sobre Paradigmas de Programação com Exemplos em Lua

#### Objetivo
Este guia de estudos tem como objetivo fornecer uma visão geral abrangente dos diferentes paradigmas de programação — especificamente programação procedural, programação orientada a objetos, programação funcional, programação orientada a dados e descrição de dados — usando exemplos na linguagem de programação Lua. Ele explicará os conceitos centrais, os princípios e as aplicações de cada paradigma, estruturado de forma a permitir expansões futuras.

#### Visão Geral
Paradigmas de programação são abordagens ou estilos de programação que oferecem maneiras distintas de conceituar e resolver problemas. Cada paradigma oferece princípios e metodologias próprios, influenciando como os programadores projetam, escrevem e mantêm o código. Lua, por ser uma linguagem de script versátil e leve, oferece suporte eficaz a múltiplos paradigmas.

#### Programação Procedural
A programação procedural é um paradigma baseado no conceito de chamadas de procedimentos, em que o código é organizado em procedimentos, também conhecidos como rotinas, sub-rotinas ou funções. Esse paradigma enfatiza uma sequência de passos a serem executados, tornando-o direto e fácil de entender.

Em Lua, a programação procedural é natural e simples. Eis um exemplo:

```lua
function saudar(nome)
    print("Olá, " .. nome)
end

function principal()
    saudar("Mundo")
    saudar("Lua")
end

principal()
```

Neste exemplo, o programa define um procedimento `saudar` para imprimir uma mensagem de saudação e depois chama esse procedimento a partir da função `principal`.

#### Programação Orientada a Objetos
A programação orientada a objetos (POO) gira em torno do conceito de "objetos", que são instâncias de classes. As classes definem a estrutura e o comportamento dos objetos, encapsulando dados e funções que operam sobre esses dados. Lua oferece suporte a POO por meio de metatables e da sintaxe `:` para chamadas de métodos.

Eis um exemplo de POO em Lua:

```lua
Conta = {}
Conta.__index = Conta

function Conta:new(nome, saldo)
    local obj = {nome = nome, saldo = saldo}
    setmetatable(obj, Conta)
    return obj
end

function Conta:depositar(valor)
    self.saldo = self.saldo + valor
end

function Conta:sacar(valor)
    if self.saldo >= valor then
        self.saldo = self.saldo - valor
    else
        print("Saldo insuficiente")
    end
end

function Conta:obterSaldo()
    return self.saldo
end

local minhaConta = Conta:new("João da Silva", 1000)
minhaConta:depositar(500)
minhaConta:sacar(200)
print(minhaConta:obterSaldo())  -- Saída: 1300
```

Este exemplo demonstra como criar uma classe simples `Conta` com métodos para depositar, sacar e consultar o saldo.

#### Programação Funcional
A programação funcional é um paradigma que trata a computação como a avaliação de funções matemáticas e evita mudanças de estado e dados mutáveis. Ela enfatiza a aplicação de funções, a imutabilidade e as funções de ordem superior.

Em Lua, funções são cidadãs de primeira classe. Eis um exemplo de programação funcional:

```lua
function fatorial(n)
    if n == 0 then
        return 1
    else
        return n * fatorial(n - 1)
    end
end

function map(array, func)
    local novo_array = {}
    for i, v in ipairs(array) do
        novo_array[i] = func(v)
    end
    return novo_array
end

local numeros = {1, 2, 3, 4, 5}
local quadrados = map(numeros, function(x) return x * x end)

for i, v in ipairs(quadrados) do
    print(v)
end
```

Neste exemplo, `fatorial` é uma função recursiva e `map` é uma função de ordem superior que aplica outra função a cada elemento de um array.

#### Programação Orientada a Dados
A programação orientada a dados (data-driven) é um paradigma em que o comportamento do programa é controlado por dados, em vez de lógica codificada de forma fixa. Essa abordagem separa os dados da lógica de processamento, permitindo programas mais flexíveis e adaptáveis.

A estrutura de tabelas de Lua é adequada para esse paradigma. Eis um exemplo:

```lua
local acoes = {
    saudar = function(nome) print("Olá, " .. nome) end,
    despedir = function(nome) print("Adeus, " .. nome) end
}

local function executarAcao(acao, nome)
    if acoes[acao] then
        acoes[acao](nome)
    else
        print("Ação não encontrada")
    end
end

executarAcao("saudar", "Lua")    -- Saída: Olá, Lua
executarAcao("despedir", "Lua")  -- Saída: Adeus, Lua
```

Neste exemplo, as ações são definidas em uma tabela, e a função `executarAcao` executa a ação apropriada com base nos dados fornecidos.

#### Descrição de Dados
A descrição de dados é um paradigma focado em definir e descrever a estrutura e o significado dos dados. É usada para especificar formatos de dados, esquemas e restrições, frequentemente no contexto de troca e armazenamento de dados.

Em Lua, tabelas podem ser usadas para descrever estruturas de dados. Eis um exemplo:

```lua
local pessoa = {
    nome = "João da Silva",
    idade = 30,
    endereco = {
        rua = "Rua Principal, 123",
        cidade = "Cidade Qualquer",
        estado = "SP",
        cep = "12345"
    }
}

function imprimirPessoa(p)
    print("Nome: " .. p.nome)
    print("Idade: " .. p.idade)
    print("Endereço: " .. p.endereco.rua .. ", " .. p.endereco.cidade .. ", " .. p.endereco.estado .. " " .. p.endereco.cep)
end

imprimirPessoa(pessoa)
```

Neste exemplo, a tabela `pessoa` descreve os dados de uma pessoa, incluindo uma tabela aninhada `endereco`.

#### Conclusão
Compreender os diferentes paradigmas de programação é essencial para escolher a abordagem adequada à resolução de problemas no desenvolvimento de software. Cada paradigma oferece pontos fortes próprios e é adequado a diferentes tipos de tarefas e aplicações. Ao dominar múltiplos paradigmas, os programadores podem se tornar mais versáteis e eficazes em suas práticas de codificação. Lua, com sua simplicidade e flexibilidade, é uma ótima linguagem para explorar e aplicar esses paradigmas.
