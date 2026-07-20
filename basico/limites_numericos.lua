-- limites_numericos.lua

-- Continuação da seção "Inteiro vs float" de tipos.lua: o que acontece nas
-- BORDAS da representação numérica de Lua 5.4 — inteiros de 64 bits com
-- sinal e floats IEEE 754 de 64 bits (double).

--------------------------------------------------------------------------------
-- Os limites dos inteiros: math.maxinteger e math.mininteger.

print(math.maxinteger) --> 9223372036854775807  (2^63 - 1)
print(math.mininteger) --> -9223372036854775808 (-2^63)
assert(math.type(math.maxinteger) == "integer")
assert(math.type(math.mininteger) == "integer")

-- Estourar o limite NÃO é erro nem vira float: a aritmética de inteiros é
-- módulo 2^64 (wraparound) — passar do maior valor "dá a volta" e cai no
-- menor, como um hodômetro:
assert(math.maxinteger + 1 == math.mininteger)
assert(math.mininteger - 1 == math.maxinteger)
assert(math.type(math.maxinteger + 1) == "integer") -- continua inteiro

--------------------------------------------------------------------------------
-- O limite de precisão EXATA dos floats: 2^53.

-- Um double tem 53 bits de precisão: todo inteiro até 2^53 é representável,
-- mas a partir daí os floats andam de 2 em 2 — e 2^53 + 1 simplesmente não
-- existe: a soma arredonda de volta para 2^53.
local limiteExato = 2.0 ^ 53
print(limiteExato) --> 9.007199254741e+15
assert(math.type(limiteExato) == "float")
assert(limiteExato == limiteExato + 1)  -- somar 1 não muda NADA!
assert(limiteExato - 1 ~= limiteExato)  -- abaixo do limite ainda é exato

-- Contraste com inteiros, que são exatos na faixa toda até math.maxinteger:
assert(math.maxinteger ~= math.maxinteger - 1)

--------------------------------------------------------------------------------
-- Divisão por zero: com float é infinito; com inteiro é ERRO.

-- `/` sempre produz float (tipos.lua), então 1/0 nunca é erro — o resultado
-- é o infinito do IEEE 754, o mesmo valor de math.huge:
print(1 / 0)  --> inf
print(-1 / 0) --> -inf
assert(1 / 0 == math.huge and -1 / 0 == -math.huge)
assert(math.type(math.huge) == "float")

-- Já `//` e `%` ENTRE INTEIROS exigem divisor não nulo — divisor 0 lança
-- erro em tempo de execução (o texto exato varia entre builds do 5.4:
-- "attempt to perform 'n//0'" nos mais antigos, "attempt to divide by zero"
-- nos mais novos; find com plain=true busca literal — veja padroes_de_texto.lua):
local ok, mensagem = pcall(function() return 1 // 0 end)
assert(not ok)
assert(mensagem:find("n//0", 1, true) or mensagem:find("divide by zero", 1, true))

local okResto, mensagemResto = pcall(function() return 1 % 0 end)
assert(not okResto)
assert(mensagemResto:find("n%0", 1, true) or mensagemResto:find("zero", 1, true))

-- Basta UM operando float para valer a regra dos floats — sem erro:
print(1.0 // 0) --> inf
assert(1.0 // 0 == math.huge and math.type(1.0 // 0) == "float")

--------------------------------------------------------------------------------
-- NaN (Not a Number): o resultado de 0/0.

local nan = 0 / 0
print(nan) --> -nan (o texto exato varia por plataforma: "nan", "-nan"...)
assert(math.type(nan) == "float")

-- NaN é o ÚNICO valor de Lua diferente de si mesmo — qualquer comparação
-- com NaN (inclusive com outro NaN) é falsa:
assert(nan ~= nan)
local igualASiMesma = (nan == nan)
assert(igualASiMesma == false) -- == com NaN é sempre false
assert(42 == 42) -- qualquer outro valor é igual a si mesmo

-- ...e é exatamente essa propriedade que dá o idioma de detecção:
local function ehNaN(x)
  return x ~= x
end
assert(ehNaN(0 / 0))
assert(not ehNaN(1) and not ehNaN(math.huge) and not ehNaN("texto"))

-- A pegadinha da tabela: ESCREVER com chave NaN é erro (uma chave que não é
-- igual a si mesma nunca poderia ser encontrada de novo)...
local tabela = {}
local okEscrita, mensagemEscrita = pcall(function() tabela[0 / 0] = 1 end)
assert(not okEscrita)
assert(mensagemEscrita:find("table index is NaN", 1, true))

-- ...mas LER com chave NaN não é erro: nenhuma chave casa e o resultado é nil:
assert(tabela[0 / 0] == nil)

--------------------------------------------------------------------------------
-- Conversões nos limites.

-- math.tointeger converte float de valor inteiro que CAIBA nos 64 bits:
print(math.tointeger(2.0 ^ 53)) --> 9007199254740992
assert(math.tointeger(2.0 ^ 53) == 9007199254740992)
assert(math.type(math.tointeger(2.0 ^ 53)) == "integer")

-- fora da faixa dos inteiros (2^63 > math.maxinteger) devolve nil; NaN idem:
assert(math.tointeger(2.0 ^ 63) == nil)
assert(math.tointeger(0 / 0) == nil)

-- na direção contrária, converter math.maxinteger para float ARREDONDA:
-- 2^63 - 1 não é representável num double (está acima do limite de 2^53):
assert(math.maxinteger + 0.0 == 2.0 ^ 63)

-- tostring carrega a marca do subtipo: floats de valor inteiro ganham ".0" —
-- dá para "ver" o subtipo na saída sem chamar math.type:
print(1)   --> 1
print(1.0) --> 1.0
assert(tostring(1) == "1" and tostring(1.0) == "1.0")

print("Limites e sutilezas numéricas do Lua 5.4 verificados!")
