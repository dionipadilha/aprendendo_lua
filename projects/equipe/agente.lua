local Classe = require "classe"

-- Os agentes são os blocos de construção da Equipe:
local Agente = Classe:novo {
  -------------------------------- Obrigatórios --------------------------------
  -- propriedade: papel
  --- Define a função do agente dentro da equipe.
  --- Determina o tipo de tarefas para as quais o agente é mais adequado.
  papel = "",

  -- propriedade: objetivo
  --- O objetivo individual que o agente pretende alcançar.
  --- Ele guia o processo de tomada de decisão do agente.
  objetivo = "",

  -- propriedade: historia
  --- Fornece contexto ao papel e ao objetivo do agente,
  --- enriquecendo a dinâmica de interação e colaboração.
  historia = [[]],

  --------------------------------- Opcionais ----------------------------------
  -- propriedade: ferramentas
  --- Conjunto de capacidades ou funções que o agente pode usar para executar
  --- tarefas. Espera-se que sejam instâncias de classes personalizadas
  --- compatíveis com o ambiente de execução do agente.
  ferramentas = {},

  -- propriedade: max_iteracoes
  --- Número máximo de iterações que o agente pode executar antes de ser
  --- forçado a dar sua melhor resposta.
  max_iteracoes = 25,

  -- propriedade: max_rpm
  --- O número máximo de requisições por minuto que o agente pode fazer para
  --- evitar limites de taxa.
  max_rpm = nil,

  -- propriedade: max_tempo_execucao
  --- Tempo máximo de execução para um agente executar uma tarefa.
  --- Com um valor padrão de nil, significando sem tempo máximo de execução.
  max_tempo_execucao = nil,

  -- propriedade: verboso
  --- Fornece registros detalhados de execução, auxiliando na depuração e no
  --- monitoramento dos registros.
  verboso = true,

  -- propriedade: permitir_delegacao
  --- Delegar tarefas ou perguntas uns aos outros,
  --- garantindo que cada tarefa seja tratada pelo agente mais adequado.
  permitir_delegacao = true,

  -- propriedade: callback_de_passo
  --- Uma função que é chamada após cada passo do agente.
  --- Pode ser usada para registrar as ações do agente ou executar outras
  --- operações. Ela sobrescreve o callback_de_passo da equipe.
  callback_de_passo = nil,

  -- propriedade: cache
  --- Indica se o agente deve usar um cache para o uso de ferramentas.
  cache = true,

  ---------------------------- Integração com LLM ------------------------------
  -- propriedade: llm
  --- Representa o modelo de linguagem que executará o agente.
  llm = nil,

  -- propriedade: llm_chamada_de_funcoes
  --- Modelo de linguagem que tratará a chamada de ferramentas para este
  --- agente, sobrescrevendo o LLM de chamada de funções da equipe, se passado.
  llm_chamada_de_funcoes = nil
}

function Agente:usar(ferramenta, ...)
  -- Verifica se a ferramenta existe na tabela de ferramentas
  for _, _ferramenta in ipairs(self.ferramentas) do
    if _ferramenta == ferramenta then
      -- Chama a função da ferramenta com os argumentos
      return ferramenta:executar(...)
    end
  end
  return nil
end

return Agente
