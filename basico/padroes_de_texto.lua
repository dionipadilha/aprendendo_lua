-- padroes_de_texto.lua

-- Recursos avançados da biblioteca de padrões. Pré-requisito:
-- cadeias_de_texto.lua, que cobre o básico — find, match, capturas,
-- gsub com string de substituição e gmatch.

--------------------------------------------------------------------------------
-- %bxy: casamento balanceado — do delimitador de abertura ao de
-- FECHAMENTO CORRESPONDENTE, contando o aninhamento.

local expressao = "f(g(x), y) + h(z)"

-- a tentativa ingênua "[^)]*" para no PRIMEIRO ')' e devolve um trecho
-- com parêntese interno desbalanceado:
print(expressao:match("%([^)]*%)")) --> (g(x)
assert(expressao:match("%([^)]*%)") == "(g(x)")

-- %b() conta cada '(' e ')' e só fecha quando o saldo zera:
print(expressao:match("%b()")) --> (g(x), y)
assert(expressao:match("%b()") == "(g(x), y)")

-- %b serve para qualquer par de delimitadores — %b{}, %b<>, %b[]...
assert(("a {b {c} d} e"):match("%b{}") == "{b {c} d}")

--------------------------------------------------------------------------------
-- %f[conjunto]: fronteira — casa a string VAZIA na transição de um
-- caractere FORA do conjunto para um caractere DENTRO dele.

-- %f não consome caractere nenhum: é uma âncora, como ^ e $. Antes da
-- posição 1 Lua finge existir um '\0' (fora de %a), então o início da
-- string também conta como fronteira.

local frase = "Ana viu o rioGrande e o Rio Negro"

-- sem fronteira, %u%a* acha maiúscula em QUALQUER posição — inclusive o
-- "Grande" no meio de "rioGrande":
local todas = {}
for palavra in frase:gmatch("%u%a*") do
  table.insert(todas, palavra)
end
assert(table.concat(todas, " ") == "Ana Grande Rio Negro")

-- com %f[%a], o casamento só pode começar onde um não-letra encontra uma
-- letra — ou seja, no INÍCIO de uma palavra:
local iniciadas = {}
for palavra in frase:gmatch("%f[%a]%u%a*") do
  table.insert(iniciadas, palavra)
end
assert(table.concat(iniciadas, " ") == "Ana Rio Negro")
assert(#iniciadas == 3) -- 3 palavras COMEÇAM com maiúscula

--------------------------------------------------------------------------------
-- string.find com plain=true: busca literal, sem caracteres mágicos.

local registro = "cap 145 e cap 1.5"

-- procurando a versão "1.5" com find comum, o '.' é mágico (casa qualquer
-- caractere) — e o resultado é um falso positivo: "145"!
local inicio, fim = registro:find("1.5")
assert(inicio == 5 and fim == 7)
assert(registro:sub(inicio, fim) == "145")

-- o 4º argumento plain=true desliga TODOS os mágicos (o 3º é o índice
-- onde a busca começa):
inicio, fim = registro:find("1.5", 1, true)
assert(inicio == 15 and fim == 17)
assert(registro:sub(inicio, fim) == "1.5")

-- alternativa quando só um caractere incomoda: escapá-lo com %:
assert(registro:find("1%.5") == 15)

--------------------------------------------------------------------------------
-- Quantificador guloso '*' vs preguiçoso '-'.

local marcacao = "<a><b>"

-- '*' é GULOSO: estica o casamento o máximo possível — o '>' final usado
-- é o ÚLTIMO da string:
print(marcacao:match("<.*>")) --> <a><b>
assert(marcacao:match("<.*>") == "<a><b>")

-- '-' é PREGUIÇOSO: casa o mínimo possível — para no PRIMEIRO '>':
print(marcacao:match("<.->")) --> <a>
assert(marcacao:match("<.->") == "<a>")

-- é por isso que o trim de cadeias_de_texto.lua usa "(.-)": com o miolo
-- guloso, o (.*) engoliria também os espaços do final (o %s* de trás
-- ficaria com a string vazia):
assert(("  x  "):match("^%s*(.*)%s*$") == "x  ") -- guloso: sobra espaço
assert(("  x  "):match("^%s*(.-)%s*$") == "x")   -- preguiçoso: trim correto

--------------------------------------------------------------------------------
-- gsub com TABELA de substituição: a captura vira chave, o valor substitui.

local dados = { nome = "Bob", idade = 30 }

local preenchido, casamentos = ("$nome tem $idade anos"):gsub("%$(%w+)", dados)
assert(preenchido == "Bob tem 30 anos")
assert(casamentos == 2)

-- chave ausente (valor nil) MANTÉM o texto original — e o segundo retorno
-- conta CASAMENTOS, não trocas efetivas:
local incompleto, contados = ("$nome $sobrenome"):gsub("%$(%w+)", dados)
assert(incompleto == "Bob $sobrenome")
assert(contados == 2) -- 2 casamentos, mas só 1 substituição de fato

--------------------------------------------------------------------------------
-- gsub com FUNÇÃO: recebe as capturas, o retorno substitui.

local dobrado, quantos = ("itens: 7 e 9"):gsub("%d+", function(numero)
  return tonumber(numero) * 2
end)
assert(dobrado == "itens: 14 e 18")
assert(quantos == 2)

-- como na tabela, retorno nil (ou false) mantém o casamento original —
-- o que permite substituir SELETIVAMENTE:
local soPares = ("1 2 3 4"):gsub("%d", function(digito)
  if tonumber(digito) % 2 == 0 then
    return "[" .. digito .. "]"
  end
end)
assert(soPares == "1 [2] 3 [4]")

print("Padrões de texto avançados verificados!")
