-- teste_unitario_basico.lua

-- Mini-framework de teste unitário:
--   * protege a chamada ao código sob teste com pcall (uma exceção no
--     código testado conta como reprovação, sem derrubar a suíte);
--   * conta aprovados e reprovados e RETORNA os totais, para que quem
--     chama possa fazer assert sobre eles (e reprovar o build de verdade).

local TesteUnitarioBasico = {}
TesteUnitarioBasico.__index = TesteUnitarioBasico

-- define o construtor
function TesteUnitarioBasico:novo(objeto)
  objeto = objeto or {}
  -- Defaults POR INSTÂNCIA: uma tabela default na classe seria
  -- COMPARTILHADA por todos os testes (o antipadrão demonstrado em
  -- ../padroes/observador.lua) — cada instância recebe a sua.
  objeto.id = objeto.id or ""
  objeto.teste = objeto.teste or function(caso) return nil end
  objeto.casos = objeto.casos or {}
  return setmetatable(objeto, self)
end

-- define os logs (constante de classe, compartilhada de propósito:
-- são apenas formatos de mensagem, nunca modificados):
TesteUnitarioBasico.log = {
  execucao = "\n[Executando] Teste Unitário: %s",
  campos = "[Campos] caso, esperado, obtido, asserção",
  teste = "[-->] %s, %s, %s, %s",
  excecao = "[Falha] esperado: %s, obtido: %s",
  finalizacao = "[Concluído] %d aprovado(s), %d reprovado(s), em %f segundos"
}

-- define o fluxo de execução dos testes:
-- retorna: total de aprovados, total de reprovados
function TesteUnitarioBasico:tentar()
  --
  -- registra informações sobre a configuração atual:
  print(self.log.execucao:format(self.id))
  print(self.log.campos)

  -- fluxo de execução dos testes:
  local aprovados, reprovados = 0, 0
  local inicioDoCronometro = os.clock()
  for _, caso in ipairs(self.casos) do
    -- obtém os objetos do teste, protegendo o código sob teste com pcall
    -- (se self.teste lançar um erro, 'obtido' recebe a mensagem do erro):
    local esperado = caso.esperado
    local ok, obtido = pcall(self.teste, caso.entrada)
    local assercao = ok and (esperado == obtido)

    -- contabiliza e registra o resultado:
    if assercao then
      aprovados = aprovados + 1
    else
      reprovados = reprovados + 1
    end
    print(self.log.teste:format(caso.entrada, esperado, obtido, assercao))
    if not assercao then
      print(self.log.excecao:format(esperado, obtido))
    end
  end
  local fimDoCronometro = os.clock()

  -- por fim, registra o término dos testes e retorna os totais:
  print(self.log.finalizacao:format(aprovados, reprovados, fimDoCronometro - inicioDoCronometro))
  return aprovados, reprovados
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

local aprovados, reprovados = meusTestes:tentar()
assert(aprovados == 3 and reprovados == 0)
------------------------------------------------------------------------------]]

-- Independência entre instâncias: os casos de um teste não vazam
-- para outro (é isso que os defaults por instância garantem).
local testeA = TesteUnitarioBasico:novo {}
local testeB = TesteUnitarioBasico:novo {}
table.insert(testeA.casos, { entrada = 1, esperado = 1 })
assert(#testeA.casos == 1 and #testeB.casos == 0)

return TesteUnitarioBasico
