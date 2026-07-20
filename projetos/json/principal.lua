local JSON = require "json"

local function principal(tabelaLua)
  local json = JSON:codificar(tabelaLua)
  print(json)
  local tabelaDecodificada = JSON:decodificar(json)
  print(tabelaDecodificada.nome) --> Bob
  for _, passatempo in ipairs(tabelaDecodificada.passatempos) do print(passatempo) end
  return tabelaDecodificada
end

local tabelaLua = {
  nome = "Bob",
  idade = 42,
  ehEstudante = false,
  passatempos = { "leitura", "jogos", "programação" },
  endereco = {
    rua = "123 Lua Lane",
    cidade = "Scripttown",
    cep = "12345"
  }
}

local tabelaDecodificada = principal(tabelaLua)
assert(tabelaDecodificada.nome == "Bob")
assert(tabelaDecodificada.idade == 42)
assert(tabelaDecodificada.ehEstudante == false)
assert(tabelaDecodificada.passatempos[3] == "programação")
assert(tabelaDecodificada.endereco.cidade == "Scripttown")

--------------------------------------------------------------------------------
-- Roundtrip de strings com escapes: codificar e decodificar deve
-- preservar exatamente o valor original.

local function roundtrip(valor)
  return JSON:decodificar(JSON:codificar(valor))
end

-- barra invertida, aspas duplas e caracteres de controle:
assert(roundtrip('caminho C:\\temp\\arquivo') == 'caminho C:\\temp\\arquivo')
assert(roundtrip('ela disse "olá"') == 'ela disse "olá"')
assert(roundtrip("linha 1\nlinha 2") == "linha 1\nlinha 2")
assert(roundtrip("colunas\tseparadas") == "colunas\tseparadas")
assert(roundtrip("retorno\rde carro") == "retorno\rde carro")
assert(roundtrip("\b\f") == "\b\f")

-- tudo junto, inclusive dentro de tabelas aninhadas:
local misto = { texto = 'aspas "\\" e\ncontroles\t\r ok', lista = { "a\nb", 'c"d' } }
local mistoDecodificado = roundtrip(misto)
assert(mistoDecodificado.texto == misto.texto)
assert(mistoDecodificado.lista[1] == misto.lista[1])
assert(mistoDecodificado.lista[2] == misto.lista[2])

-- a saída do codificador é JSON válido (escapes visíveis no texto):
assert(JSON:codificar("a\nb") == '"a\\nb"')
assert(JSON:codificar('a"b') == '"a\\"b"')
assert(JSON:codificar("a\\b") == '"a\\\\b"')

print("Roundtrip de strings com escapes: ok")
