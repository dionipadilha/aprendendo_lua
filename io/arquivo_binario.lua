-- arquivo_binario.lua

-- Arquivos binários com string.pack/unpack/packsize (Lua 5.3+).
--
-- O "b" de "wb"/"rb" importa: no Windows, o modo texto TRADUZ "\n" em
-- "\r\n" ao escrever (e desfaz a tradução ao ler) — qualquer byte de
-- valor 10 no meio dos dados seria corrompido. Em sistemas POSIX o "b"
-- é inócuo; usá-lo sempre que o conteúdo não for texto é a forma
-- portátil de abrir arquivos binários.

local NOME_DO_ARQUIVO <const> = "binario_demo.bin"

--------------------------------------------------------------------------------
-- #1. string.byte e string.char: a ponte entre bytes e números.
-- Em Lua, dado binário é string comum — strings carregam QUALQUER byte,
-- inclusive o zero. char monta uma string a partir de números; byte lê
-- o valor numérico de uma posição.

assert(string.char(65, 66, 67) == "ABC")
assert(string.byte("ABC", 2) == 66)
assert(#string.char(0) == 1) -- o byte zero é um byte como outro qualquer

--------------------------------------------------------------------------------
-- #2. Um mini-formato binário:
--   cabeçalho: assinatura "NOTA" (c4) + versão (i2) + contagem (i4)
--   registro : id (i4) + nota (d — float de 8 bytes)
-- O "<" fixa little-endian: o arquivo fica IDÊNTICO em qualquer máquina.
-- (Sem "<" nem ">", pack usa a ordem nativa da CPU — não portátil.)

local FORMATO_CABECALHO <const> = "<c4 i2 i4"
local FORMATO_REGISTRO <const> = "<i4 d"

-- packsize diz quantos bytes um formato (de tamanho fixo) ocupa:
assert(string.packsize(FORMATO_CABECALHO) == 10) -- 4 + 2 + 4
assert(string.packsize(FORMATO_REGISTRO) == 12)  -- 4 + 8

local registros = {
  { id = 101, nota = 8.5 },
  { id = 102, nota = 7.0 },
  { id = 103, nota = 9.25 },
}

--------------------------------------------------------------------------------
-- #3. Gravação ("wb"): string.pack converte valores em bytes.

local escrita = assert(io.open(NOME_DO_ARQUIVO, "wb"))
escrita:write(string.pack(FORMATO_CABECALHO, "NOTA", 1, #registros))
for _, registro in ipairs(registros) do
  escrita:write(string.pack(FORMATO_REGISTRO, registro.id, registro.nota))
end
assert(escrita:close())

--------------------------------------------------------------------------------
-- #4. Releitura ("rb") e roundtrip completo.

local leitura = assert(io.open(NOME_DO_ARQUIVO, "rb"))
local dados = leitura:read("a")
assert(leitura:close())
assert(#dados == 10 + 3 * 12) -- cabeçalho + 3 registros = 46 bytes

-- unpack devolve os valores E a posição do primeiro byte AINDA não lido:
local assinatura, versao, contagem, posicao = string.unpack(FORMATO_CABECALHO, dados)
assert(assinatura == "NOTA")
assert(versao == 1)
assert(contagem == 3)
assert(posicao == 11) -- os 10 bytes do cabeçalho foram consumidos

for i = 1, contagem do
  local id, nota
  id, nota, posicao = string.unpack(FORMATO_REGISTRO, dados, posicao)
  assert(id == registros[i].id)     -- roundtrip exato do inteiro...
  assert(nota == registros[i].nota) -- ...e do float ("d" preserva o double inteiro)
end
assert(posicao == #dados + 1) -- o arquivo foi consumido até o fim

print(("Roundtrip de %d registros em %d bytes verificado."):format(contagem, #dados))
--> Roundtrip de 3 registros em 46 bytes verificado.

--------------------------------------------------------------------------------
-- #5. Endianness: "<" (little) e ">" (big) mudam a ORDEM dos bytes,
-- nunca o tamanho. 258 em i2 é 0x0102: os mesmos dois bytes, invertidos.

assert(string.packsize("<i2") == string.packsize(">i2")) -- 2 bytes em ambos
local bytesLittle = string.pack("<i2", 258)
local bytesBig = string.pack(">i2", 258)
assert(bytesLittle ~= bytesBig)
-- string.byte inspeciona a diferença byte a byte:
assert(string.byte(bytesLittle, 1) == 0x02 and string.byte(bytesLittle, 2) == 0x01)
assert(string.byte(bytesBig, 1) == 0x01 and string.byte(bytesBig, 2) == 0x02)
-- lido com o MESMO formato com que foi gravado, o valor volta intacto:
assert(string.unpack("<i2", bytesLittle) == 258)
assert(string.unpack(">i2", bytesBig) == 258)

-- Limpeza do artefato de demonstração (como nos demais exemplos de io/):
assert(os.remove(NOME_DO_ARQUIVO))
