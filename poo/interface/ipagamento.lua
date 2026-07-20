-- ipagamento.lua

local IPagamento = {

  -- propriedades do contrato:
  dataDoPagamento = "string",
  dadosDoMetodo = "string",

  -- métodos do contrato:
  podeRealizarPagamento = "function",
  processarPagamento = "function",
  pagar = "function"
}

-- Verificador do contrato, compartilhado pelas classes que o assinam.
-- Vive na METATABELA para que pairs(IPagamento) — usado abaixo —
-- continue enumerando apenas os membros do contrato.
return setmetatable(IPagamento, {
  __index = {
    verificarImplementacao = function(interface, classe)
      local log = "\nfalha: a classe %s não implementa o membro %s de IPagamento"
      local nomeDaClasse = classe.classe or "?"
      for nomeDoMembro, tipoDoMembro in pairs(interface) do
        assert(
          tipoDoMembro == type(classe[nomeDoMembro]),
          log:format(nomeDaClasse, nomeDoMembro)
        )
      end
      return true
    end
  }
})
