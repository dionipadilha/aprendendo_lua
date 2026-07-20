--srp.lua

-- Princípio da Responsabilidade Única:
-- Cada função tem uma responsabilidade clara e específica.

local SRP = {}

function SRP.validarRequisicao(requisicao)
  -- lógica de validação
end

function SRP.processarRequisicao(requisicao)
  -- lógica de validação
end

function SRP.registrarRequisicao(requisicao)
  -- lógica de registro
end

function SRP:tratarRequisicao(requisicao)
  self.validarRequisicao(requisicao)
  self.processarRequisicao(requisicao)
  self.registrarRequisicao(requisicao)
end

return SRP
