-- somente_leitura.lua

-- Invólucro somente leitura via PROXY: o invólucro devolvido é uma
-- tabela VAZIA, então toda leitura cai no __index (que delega à tabela
-- original) e toda escrita cai no __newindex (que lança um erro).
local function somenteLeitura(t)
  return setmetatable({}, {
    __index = t,
    __newindex = function()
      error("tentativa de atualizar uma tabela somente leitura", 2)
    end
  })
end

local dias = somenteLeitura { "Domingo", "Segunda", "Terça" }

print(dias[1]) --> Domingo
assert(dias[1] == "Domingo")

-- Atualizar uma tabela somente leitura gera um erro; capture-o com pcall.
-- A mensagem vem com o prefixo arquivo:linha (aqui, a linha da atribuição):
local ok, err = pcall(function() dias[2] = "Nenhumdia" end)
print(ok, err) --> false	somente_leitura.lua:22: tentativa de atualizar uma tabela somente leitura
assert(ok == false)
-- o número da linha mudaria a cada edição do arquivo; casamos com %d+:
assert(err:match("somente_leitura%.lua:%d+: tentativa de atualizar uma tabela somente leitura"))

--------------------------------------------------------------------------------
-- O que o proxy QUEBRA: protegemos um ARRAY, mas nem toda operação
-- consulta os metamétodos — várias enxergam o próprio proxy, vazio.

-- O operador # não segue __index (só consultaria __len, que não
-- definimos), então mede o proxy:
assert(#dias == 0) -- e não 3!

-- pairs também itera o proxy vazio (o remédio seria __pairs, mas ele
-- foi DEPRECIADO no 5.4 — ver indice_como_funcao.lua):
local visitados = 0
for _ in pairs(dias) do visitados = visitados + 1 end
assert(visitados == 0)

-- table.insert consulta # (que devolve 0) e tenta escrever em dias[1];
-- a escrita cai no __newindex e falha — mas a mensagem de erro fala em
-- "atualizar", sem explicar o problema real de comprimento:
local inseriu = pcall(table.insert, dias, "Quarta")
assert(inseriu == false)

-- Já ipairs FUNCIONA, porque respeita __index (desde Lua 5.3):
local percorridos = {}
for _, dia in ipairs(dias) do percorridos[#percorridos + 1] = dia end
assert(table.concat(percorridos, ", ") == "Domingo, Segunda, Terça")

-- E a proteção tem furos: rawset escreve DIRETO no proxy (sem passar
-- pelo __newindex), e setmetatable(dias, nil) removeria a proteção
-- inteira (bloqueável com um campo __metatable na metatabela):
rawset(dias, 4, "Quarta")
assert(dias[4] == "Quarta")

-- Moral: este invólucro serve bem para REGISTROS lidos chave a chave
-- (configuração, constantes). Para proteger um array de verdade seria
-- preciso ao menos um __len delegando à tabela original — e ainda
-- assim pairs continuaria vendo o proxy vazio.
print("proxy somente leitura e suas limitações verificados!")
