-- formatacao_de_saida.lua

-- Técnicas básicas de formatação de saída

-- Impressão Básica de Strings:
print("Lua", "é", "divertida") --> Lua	é	divertida (separadas por tabulações)

-- Concatenação de Strings:
print("Lua" .. "-" .. "é" .. "-" .. "divertida") --> Lua-é-divertida
assert("Lua" .. "-" .. "é" .. "-" .. "divertida" == "Lua-é-divertida")

-- Formatação de Strings:
print(string.format("%s-%s-%s", "Lua", "é", "divertida")) --> Lua-é-divertida
assert(string.format("%s-%s-%s", "Lua", "é", "divertida") == "Lua-é-divertida")

-- Formatação de Números:
print(string.format("pi é %.2f", 3.1415)) --> pi é 3.14
assert(string.format("pi é %.2f", 3.1415) == "pi é 3.14")

-- Strings Multilinha:
local multilinha = [[primeira linha
segunda linha
]]
print(multilinha)
--> primeira linha
--> segunda linha
assert(multilinha == "primeira linha\nsegunda linha\n")

-- Concatenação de Elementos de uma Lista:
local lista = { "Ana", "Bob", "Charlie" }
print("Nomes: ", table.concat(lista, "-")) --> Nomes: 	Ana-Bob-Charlie
assert(table.concat(lista, "-") == "Ana-Bob-Charlie")

-- Desempacotamento de Elementos de uma Lista:
local lista = { "Ana", "Bob", "Charlie" }
print("Nomes: ", table.unpack(lista)) --> Nomes: 	Ana	Bob	Charlie

-- Uso de Metatabelas para __tostring Personalizado:
local p = setmetatable(
  { idade = 42, altura = 102 },
  { __tostring = function(p) return "pessoa de idade " .. p.idade end }
)
print(p) --> pessoa de idade 42
assert(tostring(p) == "pessoa de idade 42")

-- Formatação de Data e Hora:
local hoje = os.date("%Y-%m-%d")
print("Data de hoje:", hoje) --> Data de hoje:	AAAA-MM-DD (varia conforme o dia)
assert(hoje:match("^%d%d%d%d%-%d%d%-%d%d$")) -- verifica o formato, não o valor

-- Casamento de Padrões:
local texto = "Bom dia Lua!"
local padrao = "(%a+)%s+(%a+)%s+(%a+)!"
local palavra1, palavra2, palavra3 = string.match(texto, padrao)
print(palavra1, palavra2, palavra3) --> Bom	dia	Lua
assert(palavra1 == "Bom" and palavra2 == "dia" and palavra3 == "Lua")

-- Centralização de Texto:
local function centralizar(str, largura)
  local tamanho = #str
  if tamanho >= largura then return str end
  local preenchimento = (largura - tamanho) / 2
  local preenchimentoEsquerda = math.floor(preenchimento)
  local preenchimentoDireita = math.ceil(preenchimento)
  return string.rep(" ", preenchimentoEsquerda) .. str .. string.rep(" ", preenchimentoDireita)
end

print("|" .. centralizar("centro", 10) .. "|") --> |  centro  |
print("|" .. centralizar("centro", 11) .. "|") --> |  centro   |
print("|" .. centralizar("centro", 12) .. "|") --> |   centro   |
assert(centralizar("centro", 10) == "  centro  ")
assert(centralizar("centro", 11) == "  centro   ")
assert(centralizar("centro", 12) == "   centro   ")
