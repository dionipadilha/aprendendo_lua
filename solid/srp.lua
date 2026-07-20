--srp.lua

-- Princípio da Responsabilidade Única:
-- Cada função tem uma responsabilidade clara e específica.

local SRP = {}

-- responsabilidade nº 1: validar
function SRP.validarRequisicao(requisicao)
  assert(type(requisicao) == "table" and type(requisicao.usuario) == "string",
    "requisição inválida: precisa de um campo `usuario` (string)")
  return true
end

-- responsabilidade nº 2: processar
function SRP.processarRequisicao(requisicao)
  requisicao.processada = true
  return requisicao
end

-- responsabilidade nº 3: registrar
function SRP.registrarRequisicao(requisicao)
  requisicao.registro = ("requisição de %s processada"):format(requisicao.usuario)
  return requisicao.registro
end

-- o orquestrador apenas COMPÕE as três responsabilidades — cada etapa
-- pode evoluir, ser testada e ser trocada de forma independente.
function SRP:tratarRequisicao(requisicao)
  self.validarRequisicao(requisicao)
  self.processarRequisicao(requisicao)
  return self.registrarRequisicao(requisicao)
end

-- Testes:
local requisicao = { usuario = "ana" }
assert(SRP:tratarRequisicao(requisicao) == "requisição de ana processada")
assert(requisicao.processada == true)
assert(requisicao.registro == "requisição de ana processada")

-- uma requisição sem usuário é barrada logo na validação:
local ok = pcall(SRP.tratarRequisicao, SRP, {})
assert(not ok, "requisição inválida deveria ser rejeitada")

return SRP
