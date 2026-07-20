-- erro_estruturado.lua

-- Objetos de erro com classe e __tostring: o erro carrega campos
-- estruturados (código, campo) para quem TRATA, e uma apresentação
-- legível para quem só REGISTRA. Complementa objetos_de_erro.lua, que
-- mostra o básico de error() com tabelas.

local ErroDeValidacao = {}
ErroDeValidacao.__index = ErroDeValidacao

ErroDeValidacao.__tostring = function(erro)
  return ("[%s] %s (campo: %s)"):format(erro.codigo, erro.mensagem, erro.campo)
end

function ErroDeValidacao.novo(campo, mensagem)
  return setmetatable({
    codigo = "VALIDACAO",
    campo = campo,
    mensagem = mensagem
  }, ErroDeValidacao)
end

-- identificação pelo tipo, não por casar texto de mensagem:
local function ehErroDeValidacao(valor)
  return getmetatable(valor) == ErroDeValidacao
end

--------------------------------------------------------------------------------

local function cadastrar(usuario)
  if type(usuario.nome) ~= "string" or usuario.nome == "" then
    error(ErroDeValidacao.novo("nome", "o nome é obrigatório"))
  end
  return "cadastrado: " .. usuario.nome
end

-- sucesso:
local ok, resultado = pcall(cadastrar, { nome = "Ana" })
assert(ok and resultado == "cadastrado: Ana")

-- falha: o OBJETO chega intacto ao pcall (valores que não são strings
-- não ganham o prefixo arquivo:linha), com os campos à disposição:
local okFalha, erro = pcall(cadastrar, {})
assert(not okFalha)
assert(ehErroDeValidacao(erro))
assert(erro.campo == "nome" and erro.codigo == "VALIDACAO")

-- e o __tostring dá a forma legível para registro:
assert(tostring(erro) == "[VALIDACAO] o nome é obrigatório (campo: nome)")
print(tostring(erro)) --> [VALIDACAO] o nome é obrigatório (campo: nome)

--------------------------------------------------------------------------------
-- warn (Lua 5.4): avisos que NÃO interrompem o programa. Começam
-- desligados até o controle "@on"; a saída vai para o stderr.

warn("@on")
warn("aviso: isto vai para o stderr, sem afetar o fluxo do programa")
warn("@off")

print("Erros estruturados com __tostring e warn verificados!")
