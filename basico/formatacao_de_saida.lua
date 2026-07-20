-- formatacao_de_saida.lua

-- Técnicas básicas de formatação de saída

-- Impressão Básica de Strings:
print("Lua", "é", "divertida") --> Lua	é	divertida (separadas por tabulações)

-- Concatenação de Strings:
print("Lua" .. "-" .. "é" .. "-" .. "divertida") --> Lua-é-divertida

-- Formatação de Strings:
print(string.format("%s-%s-%s", "Lua", "é", "divertida")) --> Lua-é-divertida

-- Formatação de Números:
print(string.format("pi é %.2f", 3.1415)) --> pi é 3.14

-- Strings Multilinha:
local multilinha = [[primeira linha
segunda linha
]]
print(multilinha)
--> primeira linha
--> segunda linha

-- Concatenação de Elementos de uma Lista:
local lista = { "Ana", "Bob", "Charlie" }
print("Nomes: ", table.concat(lista, "-")) --> Nomes: 	Ana-Bob-Charlie

-- Desempacotamento de Elementos de uma Lista:
local lista = { "Ana", "Bob", "Charlie" }
print("Nomes: ", table.unpack(lista)) --> Nomes: 	Ana	Bob	Charlie

-- Uso de Metatabelas para __tostring Personalizado:
local p = setmetatable(
  { idade = 42, altura = 102 },
  { __tostring = function(p) return "pessoa de idade " .. p.idade end }
)
print(p) --> pessoa de idade 42

-- Formatação de Data e Hora:
local hoje = os.date("%Y-%m-%d")
print("Data de hoje:", hoje) --> Data de hoje:	2024-06-19

-- Casamento de Padrões:
local texto = "Bom dia Lua!"
local padrao = "(%a+)%s+(%a+)%s+(%a+)!"
local palavra1, palavra2, palavra3 = string.match(texto, padrao)
print(palavra1, palavra2, palavra3) --> Bom	dia	Lua

-- Centralização de Texto:
local function centralizar(str, largura)
  local tamanho = #str
  if tamanho >= largura then return str end
  local preenchimento = (largura - tamanho) / 2
  local preenchimento_esquerda = math.floor(preenchimento)
  local preenchimento_direita = math.ceil(preenchimento)
  return string.rep(" ", preenchimento_esquerda) .. str .. string.rep(" ", preenchimento_direita)
end

print("|" .. centralizar("centro", 10) .. "|") --> |  centro  |
print("|" .. centralizar("centro", 11) .. "|") --> |  centro   |
print("|" .. centralizar("centro", 12) .. "|") --> |   centro   |
