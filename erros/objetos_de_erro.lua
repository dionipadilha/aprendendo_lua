-- objetos_de_erro.lua

-- error aceita QUALQUER valor, não apenas strings.
-- Lançar uma tabela ("objeto de erro") permite erros estruturados, com
-- código, mensagem e contexto — sem depender de parsear strings.
-- Atenção: o prefixo "arquivo:linha" só é acrescentado a mensagens string;
-- objetos de erro chegam intactos ao pcall.

--------------------------------------------------------------------------------
-- #1: error com tabela

local function sacar(saldo, valor)
  if valor <= 0 then
    error({ codigo = "VALOR_INVALIDO", mensagem = "o valor do saque deve ser positivo", valor = valor })
  end
  if valor > saldo then
    error({ codigo = "SALDO_INSUFICIENTE", mensagem = "saldo insuficiente para o saque", saldo = saldo, valor = valor })
  end
  return saldo - valor
end

local ok1, erro1 = pcall(sacar, 100, 150)
assert(not ok1)
assert(type(erro1) == "table") -- o objeto chega intacto, sem prefixo de posição
assert(erro1.codigo == "SALDO_INSUFICIENTE")
assert(erro1.saldo == 100 and erro1.valor == 150)
print(("erro estruturado: [%s] %s"):format(erro1.codigo, erro1.mensagem))
--> erro estruturado: [SALDO_INSUFICIENTE] saldo insuficiente para o saque

--------------------------------------------------------------------------------
-- #2: inspeção do erro estruturado e re-lançamento

-- Trata apenas o que conhece; re-lança o resto para quem estiver acima.
local function sacarComTratamento(saldo, valor)
  local ok, resultado = pcall(sacar, saldo, valor)
  if ok then return resultado end
  if type(resultado) == "table" and resultado.codigo == "SALDO_INSUFICIENTE" then
    return saldo -- tratamento conhecido: nega o saque e mantém o saldo
  end
  error(resultado, 0) -- não sabe tratar: re-lança o MESMO objeto de erro
end

assert(sacarComTratamento(100, 30) == 70)   -- saque normal
assert(sacarComTratamento(100, 500) == 100) -- saldo insuficiente: tratado aqui

-- O erro desconhecido (VALOR_INVALIDO) atravessa por re-lançamento:
local ok2, erro2 = pcall(sacarComTratamento, 100, -5)
assert(not ok2)
assert(type(erro2) == "table" and erro2.codigo == "VALOR_INVALIDO")
print(("re-lançado até aqui: [%s] %s"):format(erro2.codigo, erro2.mensagem))
--> re-lançado até aqui: [VALOR_INVALIDO] o valor do saque deve ser positivo

--------------------------------------------------------------------------------
-- #3: xpcall + debug.traceback — a razão de ser do xpcall

-- O tratador de erros roda ANTES de a pilha ser desfeita: é o único momento
-- em que o traceback completo ainda existe. Com pcall, quando o erro chega
-- de volta, a pilha já foi descartada.

local function nivel2() error("falha profunda") end
local function nivel1() nivel2() end

local ok3, relatorio = xpcall(nivel1, debug.traceback)
assert(not ok3)
assert(type(relatorio) == "string")
assert(relatorio:match("falha profunda"))
assert(relatorio:match("stack traceback:"))
print(relatorio)
--> objetos_de_erro.lua:NN: falha profunda
--> stack traceback:
-->         [C]: in function 'error'
-->         ... (a cadeia nivel2 → nivel1 aparece aqui) ...

--------------------------------------------------------------------------------
-- Veja também: erro, pcall, xpcall, try_except
