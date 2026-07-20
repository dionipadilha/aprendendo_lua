-- utf8_na_pratica.lua

-- Aprofundamento da biblioteca utf8 (Lua 5.3+). Pré-requisito:
-- cadeias_de_texto.lua/.md, que apresentam a diferença bytes vs
-- caracteres, utf8.len, utf8.codes e utf8.offset básico. Aqui entram
-- as partes que faltavam: construir e decompor caracteres, VALIDAR
-- entrada suspeita, iterar com utf8.charpattern, índices negativos e
-- a limitação honesta da biblioteca: ela não normaliza Unicode.

--------------------------------------------------------------------------------
-- utf8.char e utf8.codepoint: a ponte caractere <-> código

-- utf8.char monta uma string a partir de códigos Unicode (aceita vários):
assert(utf8.char(231, 227, 111) == "ção")

-- utf8.codepoint faz o caminho inverso; com (s, 1, -1) devolve TODOS os
-- códigos da string, em múltiplos retornos:
local c1, c2, c3 = utf8.codepoint("ção", 1, -1)
assert(c1 == 231 and c2 == 227 and c3 == 111)

-- Ida e volta completa (roundtrip):
assert(utf8.char(utf8.codepoint("água", 1, -1)) == "água")

-- Também se escreve código Unicode direto no literal, com \u{...}:
assert("\u{E9}" == "é" and utf8.codepoint("é") == 0xE9)

--------------------------------------------------------------------------------
-- Validação de entrada: utf8.len devolve nil + posição em bytes inválidos

-- Nem toda sequência de bytes é UTF-8 válido — arquivos corrompidos,
-- truncamento no meio de um acento, outra codificação (Latin-1)...
-- Em vez de erro, utf8.len reporta: devolve nil E a posição do primeiro
-- byte inválido:
local truncada = "ol\xC3" -- "olá" cortado no meio do "á" (2 bytes: C3 A1)
local n, posicao = utf8.len(truncada)
assert(n == nil and posicao == 3) -- byte 3 começa uma sequência incompleta

-- Com a sequência completa, a contagem volta ao normal:
assert(utf8.len("ol\xC3\xA1") == 3) -- "olá"

-- Isso dá um validador de UTF-8 em uma linha — o idioma para checar
-- entrada externa ANTES de processá-la:
local function ehUtf8Valido(s)
  return utf8.len(s) ~= nil
end
assert(ehUtf8Valido("coração"))
assert(not ehUtf8Valido(truncada))
assert(not ehUtf8Valido("caf\xE9")) -- "café" em Latin-1, não em UTF-8

-- Já utf8.codes não reporta: LANÇA erro ao encontrar bytes inválidos.
-- Validar com utf8.len primeiro; iterar com utf8.codes depois:
local ok, mensagem = pcall(function()
  for _ in utf8.codes(truncada) do end
end)
assert(not ok and mensagem:find("invalid UTF-8 code", 1, true))

--------------------------------------------------------------------------------
-- utf8.charpattern: iterar CARACTERES com a biblioteca de padrões

-- utf8.charpattern é um padrão pronto ("[\0-\x7F\xC2-\xFD][\x80-\xBF]*")
-- que casa exatamente um caractere UTF-8 por vez, para usar com gmatch:
local caracteres = {}
for caractere in ("olá"):gmatch(utf8.charpattern) do
  caracteres[#caracteres + 1] = caractere
end
assert(#caracteres == 3 and caracteres[3] == "á")

-- Aplicação clássica: reverter POR CARACTERES. (string.reverse inverte
-- BYTES: os 2 bytes do "á" trocariam de ordem e a string corromperia.)
local function reverterCaracteres(s)
  local invertida = {}
  for caractere in s:gmatch(utf8.charpattern) do
    table.insert(invertida, 1, caractere)
  end
  return table.concat(invertida)
end
assert(reverterCaracteres("olá") == "álo")
assert(("olá"):reverse() ~= "álo") -- a versão por bytes sai corrompida
assert(reverterCaracteres(reverterCaracteres("coração")) == "coração")

--------------------------------------------------------------------------------
-- utf8.offset com índice negativo: contar do FIM

-- utf8.offset(s, n) converte posição de CARACTERE em posição de BYTE;
-- com n negativo, conta a partir do fim — os últimos N caracteres sem
-- percorrer a string inteira à mão:
local palavra = "coração"
local inicio = utf8.offset(palavra, -3) -- onde começa o 3º caractere do fim
assert(inicio == 5)                     -- ("ç" e "ã" têm 2 bytes cada)
assert(palavra:sub(inicio) == "ção")

-- O idioma "últimos N caracteres" empacotado:
local function sufixo(s, n)
  return s:sub(utf8.offset(s, -n))
end
assert(sufixo("programação", 4) == "ação")

--------------------------------------------------------------------------------
-- Limitação honesta: a biblioteca utf8 NÃO normaliza Unicode

-- O mesmo "é" visível pode ser escrito de duas formas: pré-composto
-- (U+00E9) ou "e" + acento combinante (U+0301). Elas PARECEM iguais na
-- tela, mas são bytes diferentes — e a utf8 compara bytes, não grafemas:
local preComposto = "\u{E9}"   -- é (1 código)
local combinado = "e\u{301}"   -- e + ´ (2 códigos)
print(preComposto, combinado)  --> é	é (indistinguíveis na tela)
assert(preComposto ~= combinado)         -- ...mas diferentes para ==
assert(utf8.len(preComposto) == 1)
assert(utf8.len(combinado) == 2)         -- e até no comprimento

-- Normalizar (NFC/NFD) exigiria as tabelas do Unicode, que a biblioteca
-- não traz — é papel de bibliotecas externas. A lição prática: ao
-- comparar texto de fontes diferentes (teclado, arquivo, web), iguais
-- na tela não garante iguais nos bytes.

print("utf8 na prática: validação, iteração e limites verificados!")
