-- cadeias_de_texto.lua

-- Versão executável de cadeias_de_texto.md: cada afirmação do guia é
-- verificada com assert — inclusive as armadilhas de UTF-8.

--------------------------------------------------------------------------------
-- Concatenação e formatação:

local frase = "Olá" .. " " .. "Mundo"
assert(frase == "Olá Mundo")

assert(("Olá, %s! Você tem %d anos."):format("Bob", 30) ==
  "Olá, Bob! Você tem 30 anos.")

local nomes = { "Ana", "Bob", "Carlos" }
assert(table.concat(nomes, ", ") == "Ana, Bob, Carlos")

--------------------------------------------------------------------------------
-- Comprimento: # e string.len contam BYTES, não caracteres.

local texto = "Lua é incrível" -- 14 caracteres, 16 bytes (é e í têm 2 bytes)
assert(#texto == 16 and texto:len() == 16)
assert(utf8.len(texto) == 14)

--------------------------------------------------------------------------------
-- upper/lower operam por byte: caracteres acentuados NÃO são convertidos.

assert(("Lua é incrível"):upper() == "LUA é INCRíVEL") -- e não "LUA É INCRÍVEL"
assert(("Lua é incrível"):lower() == "lua é incrível") -- só o "L" era ASCII

-- normalização para comparação sem diferenciar caixa (texto ASCII):
assert(("lua"):lower() == ("Lua"):lower())

--------------------------------------------------------------------------------
-- Busca e substring (índices em bytes):

local textoDeBusca = "Lua é incrívelmente fácil"
local inicio, fim = textoDeBusca:find("incrível")
assert(inicio == 8 and fim == 16)
assert(textoDeBusca:sub(8, 16) == "incrível")
assert(textoDeBusca:sub(-6) == "fácil") -- índice negativo conta do final

--------------------------------------------------------------------------------
-- gsub devolve DOIS valores: o texto novo e o número de substituições.

local resultado, quantas = ("Lua é fácil"):gsub("fácil", "poderosa")
assert(resultado == "Lua é poderosa" and quantas == 1)

-- %a+ casa QUALQUER sequência de letras — inclusive "O", "o" e "e":
local animais, total = ("O gato, o rato e o elefante"):gsub("%a+", "Animal")
assert(animais == "Animal Animal, Animal Animal Animal Animal Animal")
assert(total == 7)

-- exigindo 3+ letras no padrão, só as palavras longas são substituídas:
local longas, totalLongas = ("O gato, o rato e o elefante"):gsub("%a%a%a+", "Animal")
assert(longas == "O Animal, o Animal e o Animal" and totalLongas == 3)

-- captura na substituição (%1) e escape de caractere mágico (%%):
assert(("O preço é R$ 100"):gsub("(%d+)", "%1,00") == "O preço é R$ 100,00")
assert(("100%"):gsub("%%", " por cento") == "100 por cento")

--------------------------------------------------------------------------------
-- Armadilha de UTF-8 em padrões: %a e %w só casam letras ASCII.

local function titleize(str)
  return (str:gsub("(%a)([%w_']*)", function(primeira, resto)
    return primeira:upper() .. resto:lower()
  end))
end

-- o "í" de "país" interrompe o casamento e o "s" vira "palavra nova":
assert(titleize("bob no país das maravilhas") == "Bob No PaíS Das Maravilhas")

--------------------------------------------------------------------------------
-- gmatch: iterar sobre capturas, palavras e caracteres.

local pares = {}
for chave, valor in ("Nome: Bob; Idade: 30"):gmatch("(%w+): *(%w+)") do
  pares[chave] = valor
end
assert(pares.Nome == "Bob" and pares.Idade == "30")

local palavras = {}
for palavra in ("Lua é incrível"):gmatch("%S+") do
  table.insert(palavras, palavra)
end
assert(#palavras == 3 and palavras[3] == "incrível")

--------------------------------------------------------------------------------
-- Remover espaços do início e do final (trim) com match:

local function trim(str)
  return str:match("^%s*(.-)%s*$")
end
assert(trim("    Olá, Mundo!    ") == "Olá, Mundo!")
assert(trim("sem espaços") == "sem espaços")

print("Todas as verificações de cadeias de texto passaram!")
