-- serializacao.lua

-- Serializar é converter uma tabela viva em TEXTO que pode ser gravado e
-- reconstruído depois. O formato aqui é o próprio Lua (PiL, cap. 12): o
-- texto emitido é um construtor de tabela válido, e load("return " .. texto)
-- o traz de volta — load é apresentado em modulos/carregadores.lua.
-- Para trocar dados com OUTRAS linguagens, use um formato interoperável
-- como JSON — veja projetos/json/.

--------------------------------------------------------------------------------
-- #1. Strings: por que string.format("%q") e não aspas coladas à mão.

-- Colar aspas em volta quebra no primeiro caso especial — uma quebra de
-- linha ou uma aspa DENTRO da string produz código que nem compila
-- (load devolve nil + mensagem de erro):
local perigosa = "linha 1\nlinha \"citada\""
assert(load("return \"" .. perigosa .. "\"") == nil)

-- %q escapa tudo o que precisa (aspas, \n, \r, \0) e gera uma string
-- citada que o próprio Lua lê de volta idêntica:
local citada = string.format("%q", perigosa)
assert(load("return " .. citada)() == perigosa)
assert(load("return " .. string.format("%q", "a\0b"))() == "a\0b")

--------------------------------------------------------------------------------
-- #2. Números: preservar o subtipo (e a precisão) do 5.4.

local function serializarNumero(numero)
  if math.type(numero) == "integer" then
    return string.format("%d", numero)
  end
  -- float: %.17g emite dígitos suficientes para reconstruir o double
  -- EXATO (tostring usa %.14g e perderia precisão — veja o assert abaixo):
  local texto = string.format("%.17g", numero)
  -- "%.17g" de 2.0 é só "2" — sem marca de float, load leria um INTEIRO;
  -- se não sobrou nenhum sinal de float no texto, acrescentamos ".0":
  if not texto:find("[%.eE]") then
    texto = texto .. ".0"
  end
  return texto
end

assert(serializarNumero(42) == "42")
assert(serializarNumero(2.0) == "2.0")

local terco = load("return " .. serializarNumero(1 / 3))()
assert(terco == 1 / 3 and math.type(terco) == "float")

-- o contraexemplo: com tostring, 1/3 volta como um double DIFERENTE:
assert(load("return " .. tostring(1 / 3))() ~= 1 / 3)

--------------------------------------------------------------------------------
-- #3. serializar: recursão sobre a tabela, chave a chave.

-- Chave que é identificador válido pode sair sem colchetes (nome = ...);
-- todas as outras — espaços, palavras reservadas, números, booleanos —
-- precisam da forma geral [chave] = valor.
local palavrasReservadas = {}
for palavra in ([[and break do else elseif end false for function goto if
    in local nil not or repeat return then true until while]]):gmatch("%a+") do
  palavrasReservadas[palavra] = true
end

local serializar -- declaração adiantada: recursão mútua com serializarChave

local function serializarChave(chave)
  if type(chave) == "string" and chave:match("^[%a_][%w_]*$")
      and not palavrasReservadas[chave] then
    return chave
  end
  return "[" .. serializar(chave) .. "]"
end

function serializar(valor, indentacao)
  indentacao = indentacao or ""
  local tipo = type(valor)
  if tipo == "number" then
    return serializarNumero(valor)
  elseif tipo == "string" then
    return string.format("%q", valor)
  elseif tipo == "boolean" then
    return tostring(valor)
  elseif tipo == "table" then
    local interna = indentacao .. "  "
    local partes = { "{\n" }
    for chave, item in pairs(valor) do
      table.insert(partes, interna .. serializarChave(chave) .. " = "
        .. serializar(item, interna) .. ",\n")
    end
    table.insert(partes, indentacao .. "}")
    return table.concat(partes)
  end
  error("tipo não serializável: " .. tipo)
end

-- com um único campo a saída é determinística e dá para conferir no olho:
print(serializar({ resposta = 42 }))
--> {
-->   resposta = 42,
--> }

-- chaves fora do formato de identificador saem entre colchetes — sem isso
-- o código emitido nem compilaria:
local estranhas = serializar({ ["nome completo"] = "Ana", ["end"] = 1 })
assert(estranhas:find('["nome completo"]', 1, true))
assert(estranhas:find('["end"]', 1, true)) -- "end" é palavra reservada

--------------------------------------------------------------------------------
-- #4. O ciclo completo: serializar, load, e conferir campo a campo.

local original = {
  titulo = "Guia de \"Lua\"\ncom quebra de linha",
  quantidade = 42,  -- inteiro
  fator = 1 / 3,    -- float que exige %.17g
  ativo = false,
  ["nome completo"] = "Ana Lima",
  [10] = "décimo",
  aninhada = { profundidade = 2, itens = { "a", "b" } },
}

local texto = serializar(original)
local reconstruida = assert(load("return " .. texto))()

-- A ordem de pairs NÃO é especificada (tabelas.lua): o TEXTO pode variar
-- de uma execução para outra, então o roundtrip compara os CAMPOS, nunca
-- a string gerada:
assert(reconstruida ~= original) -- tabela NOVA, não a mesma referência
assert(reconstruida.titulo == original.titulo)
assert(reconstruida.quantidade == 42)
assert(math.type(reconstruida.quantidade) == "integer")
assert(reconstruida.fator == 1 / 3)
assert(math.type(reconstruida.fator) == "float")
assert(reconstruida.ativo == false)
assert(reconstruida["nome completo"] == "Ana Lima")
assert(reconstruida[10] == "décimo")
assert(reconstruida.aninhada.profundidade == 2)
assert(reconstruida.aninhada.itens[1] == "a" and reconstruida.aninhada.itens[2] == "b")

--------------------------------------------------------------------------------
-- #5. Limitações — declaradas, não escondidas.

-- a) CICLOS estouram a pilha: a recursão nunca chega a um caso base.
-- (Um serializador completo manteria uma tabela de "já visitados", como a
-- detecção de ciclos de projetos/json/.)
local ciclica = { nome = "eu mesma" }
ciclica.eu = ciclica
local ok, mensagem = pcall(serializar, ciclica)
assert(not ok and mensagem:find("stack overflow", 1, true))

-- b) Funções, userdata e threads não viram texto — só DADOS serializam:
local okFuncao, mensagemFuncao = pcall(serializar, { acao = print })
assert(not okFuncao and mensagemFuncao:find("não serializável", 1, true))

-- c) inf e NaN não têm literal em Lua: o texto emitido não compila de
-- volta (projetos/json/ rejeita os dois pelo mesmo motivo):
assert(load("return " .. serializar({ x = 1 / 0 })) == nil)

-- d) Como a ordem de pairs varia, o texto não é canônico: não sirva o
-- resultado para comparar tabelas por igualdade de string nem para hash.

print("Serialização e roundtrip com load verificados!")
