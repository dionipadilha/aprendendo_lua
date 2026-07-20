-- indice_como_funcao.lua

-- __index pode ser uma TABELA (herança simples, como em ../poo/) ou uma
-- FUNÇÃO, chamada como f(tabela, chave) a cada leitura de chave
-- inexistente. Com __index e __newindex como funções e uma tabela de
-- apoio privada, constrói-se um proxy completo: todo acesso passa pelo
-- invólucro, que pode registrar, validar ou transformar.

--------------------------------------------------------------------------------
-- #1. __index como função: valores calculados sob demanda.

local temperaturas = setmetatable({}, {
  __index = function(_, cidade)
    return "sem leitura para " .. cidade
  end
})

temperaturas.natal = 31
assert(temperaturas.natal == 31) -- chave existente: __index nem é consultado
assert(temperaturas.recife == "sem leitura para recife")

--------------------------------------------------------------------------------
-- #2. Proxy completo de leitura e escrita com tabela de apoio.
-- O truque: o proxy fica sempre VAZIO, então toda leitura cai em
-- __index e toda escrita em __newindex (ambos só disparam para chaves
-- que não existem na tabela). Os dados reais moram na tabela de apoio,
-- privada por ser um upvalue das clausuras.

local function novoProxyComRegistro()
  local apoio = {}    -- os dados de verdade
  local registro = {} -- trilha de acessos

  local proxy = setmetatable({}, {
    __index = function(_, chave)
      table.insert(registro, "leu " .. tostring(chave))
      return apoio[chave]
    end,
    __newindex = function(_, chave, valor)
      table.insert(registro, "escreveu " .. tostring(chave))
      apoio[chave] = valor
    end
  })
  return proxy, registro
end

local config, registro = novoProxyComRegistro()

config.tema = "escuro"          -- passa por __newindex
assert(config.tema == "escuro") -- passa por __index
assert(config.fonte == nil)     -- leitura de chave ausente também passa

assert(table.concat(registro, "; ") == "escreveu tema; leu tema; leu fonte")

--------------------------------------------------------------------------------
-- #3. rawget e rawset ignoram os metamétodos.

-- o proxy em si continua vazio — o dado mora na tabela de apoio:
assert(rawget(config, "tema") == nil)

-- rawset escreve DIRETO no proxy, furando a interceptação:
rawset(config, "furo", true)
assert(config.furo == true)  -- a chave agora existe: __index não dispara
assert(#registro == 3)       -- e nada disso apareceu no registro

-- limitação dos proxies: # e pairs enxergam o PROXY (vazio) — o Lua 5.4
-- não tem __pairs; para iterar, exponha uma função própria sobre o apoio.

print("__index como função e proxy completo verificados!")
