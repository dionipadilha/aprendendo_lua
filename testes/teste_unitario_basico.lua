-- teste_unitario_basico.lua

local TesteUnitarioBasico = {
  id = "",
  teste = function(caso) return nil end,
  casos = {
    { entrada = nil, esperado = nil },
  }
}

-- define o construtor
function TesteUnitarioBasico:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

-- define o msgh usado por xpcall:
function TesteUnitarioBasico.msgh(excecao)
  print(excecao)
end

-- define os logs:
TesteUnitarioBasico.log = {
  execucao = "\n[Executando] Teste Unitário: %s",
  campos = "[Campos] caso, esperado, obtido, asserção",
  teste = "[-->] %s, %s, %s, %s",
  excecao = "[Exceção] esperado: %s, obtido: %s",
  finalizacao = "[Concluído] finalizado em %f segundos"
}

-- define o fluxo de execução dos testes:
function TesteUnitarioBasico:tentar()
  --
  -- registra informações sobre a configuração atual:
  print(self.log.execucao:format(self.id))
  print(self.log.campos)

  -- fluxo de execução dos testes:
  local inicioDoCronometro = os.clock()
  for _, caso in pairs(self.casos) do
    -- obtém os objetos do teste:
    local esperado = caso.esperado
    local obtido = self.teste(caso.entrada)
    local assercao = (esperado == obtido)
    print(self.log.teste:format(caso.entrada, esperado, obtido, assercao))
    -- obtém as possíveis exceções:
    xpcall(
      assert,
      self.msgh,
      assercao,
      self.log.excecao:format(esperado, obtido)
    )
  end
  local fimDoCronometro = os.clock()

  -- por fim, registra o término dos testes:
  print(self.log.finalizacao:format(fimDoCronometro - inicioDoCronometro))
end

--[[----------------------------------------------------------------------------
-- exemplo:

local meusTestes = TesteUnitarioBasico:novo {
  id = "Teste #1 - Exemplo",
  teste = function(n) return n + 1 end,
  casos = {
    { entrada = 1, esperado = 2 },
    { entrada = 3, esperado = 4 },
    { entrada = 5, esperado = 6 }
  }
}

meusTestes:tentar()
------------------------------------------------------------------------------]]

return TesteUnitarioBasico
