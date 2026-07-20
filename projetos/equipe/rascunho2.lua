-- equipe.lua

--------------------------------------------------------------------------------
-- Passo nº 1: Classes

local Classe = {}

function Classe:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

local Ferramenta = Classe:novo {
  descricao = "",
  estado = ""
}

local Agente = Classe:novo {
  papel = "",
  objetivo = "",
  historia = "",
  ferramentas = {},
  estado = "ocioso",
}

local Tarefa = Classe:novo {
  descricao = "",
  saida_esperada = "",
  agente = nil,
  permitir_delegacao = true,
  prioridade = 1,
  dependencias = {}
}

local Processo = Classe:novo {
  hierarquico = function(self, tarefas)
    table.sort(tarefas, function(a, b)
      if a.prioridade == b.prioridade then
        return a.descricao < b.descricao
      end
      return a.prioridade > b.prioridade
    end)
    return tarefas
  end
}

local Equipe = Classe:novo {
  agentes = {},
  tarefas = {},
  processo = {},
  iniciar = function(self)
    return "ainda não implementado"
  end
}

--------------------------------------------------------------------------------
-- Passo nº 2: Criando as Ferramentas

local Nave = Ferramenta:novo {
  forcaDeAtaque = 0,
  velocidade = 0,

  ligar = function(self)
    self.estado = "sistemasAtivados"
    return true
  end,

  atacar = function(self)
    self.estado = "atacando"
    return self.forcaDeAtaque
  end,

  desligar = function(self)
    self.estado = "sistemasDesativados"
    return true
  end
}

local xWing = Nave:novo {
  descricao = "projetada para destruir a DeathStar",
  forcaDeAtaque = 0.7,
  velocidade = 0.9,
  estado = "parada"
}

local millenniumFalcon = Nave:novo {
  descricao = "projetada para transporte de carga, mas foi fortemente modificada",
  forcaDeAtaque = 0.9,
  velocidade = 0.5,
  estado = "parada"
}

--------------------------------------------------------------------------------
-- Passo nº 3: Montar os Agentes

local leia = Agente:novo {
  papel = "coordenadora",
  objetivo = "coordenar o ataque à DeathStar",
  historia = "princesa líder da rebelião",
  ferramentas = {}
}

local luke = Agente:novo {
  papel = "atacante",
  objetivo = "Destruir a DeathStar",
  historia = "Jovem piloto, destinado a ser um Jedi",
  ferramentas = { xWing }
}

local han = Agente:novo {
  papel = "protetor",
  objetivo = "proteger o atacante",
  historia = "Contrabandista audacioso que se torna um herói",
  ferramentas = { millenniumFalcon }
}

--------------------------------------------------------------------------------
-- Passo nº 4: Definir as Tarefas

local coordenacaoDoAtaque = Tarefa:novo {
  agente = leia,
  permitir_delegacao = true,
  descricao = "Coordenar protetor e atacante",
  saida_esperada = "Missão de ataque concluída com sucesso",
  prioridade = 3
}

local protecaoParaPilotoDeAtaque = Tarefa:novo {
  agente = han,
  permitir_delegacao = false,
  descricao = "Atacar as naves inimigas para proteger o piloto de ataque.",
  saida_esperada = "piloto de ataque em segurança",
  prioridade = 2,
  dependencias = { coordenacaoDoAtaque }
}

local destruirDeathStar = Tarefa:novo {
  agente = luke,
  permitir_delegacao = false,
  descricao = "atacar para destruir a DeathStar.",
  saida_esperada = "DeathStar destruída",
  prioridade = 1,
  dependencias = { protecaoParaPilotoDeAtaque }
}

--------------------------------------------------------------------------------
-- Passo nº 5: Formar a Equipe

local aliancaRebelde = Equipe:novo {
  agentes = { leia, han, luke },
  tarefas = { coordenacaoDoAtaque, protecaoParaPilotoDeAtaque, destruirDeathStar },
  processo = { Processo.hierarquico }
}

-- Atribuição Dinâmica de Tarefas

function aliancaRebelde:atribuirTarefas(agentes, tarefas)
  for _, tarefa in pairs(tarefas) do
    for _, agente in pairs(agentes) do
      if agente.papel == "coordenadora" and tarefa.permitir_delegacao then
        tarefa.agente = agente
        break
      elseif agente.papel == "atacante" and tarefa.descricao:find("destruir a Death Star") then
        tarefa.agente = agente
        break
      elseif agente.papel == "protetor" and tarefa.descricao:find("proteger") then
        tarefa.agente = agente
        break
      end
    end
  end
end

--------------------------------------------------------------------------------
-- Passo nº 6: Dar a Partida

function aliancaRebelde:iniciar()
  print("Partida iniciada. Executando tarefas...\n")
  for _, tarefa in pairs(self.tarefas) do
    -- Verifica se as dependências da tarefa foram atendidas
    local dependencias_atendidas = true
    for _, dependencia in pairs(tarefa.dependencias) do
      if dependencia.agente.estado ~= "concluido" then
        dependencias_atendidas = false
        break
      end
    end

    if dependencias_atendidas then
      print("Agente: " .. tarefa.agente.papel)
      print("Tarefa: " .. tarefa.descricao)
      print("Objetivo: " .. tarefa.agente.objetivo)
      print("História: " .. tarefa.agente.historia)
      print("Ferramentas: ")
      for _, ferramenta in pairs(tarefa.agente.ferramentas) do
        print("  - " .. ferramenta.descricao .. " (Estado: " .. ferramenta.estado .. ")")
      end

      -- Simula a execução da tarefa com resultados
      local sucesso = math.random() < 0.8 -- 80% de chance de sucesso
      if sucesso then
        print("Resultado: " .. tarefa.saida_esperada .. "\n")
        tarefa.agente.estado = "concluido"
        if tarefa == destruirDeathStar then
          -- DeathStar destruída, fim de jogo
          print("A DeathStar foi destruída! A Rebelião triunfa!\n")
          return
        end
      else
        print("Resultado: A tarefa falhou!\n")
        tarefa.agente.estado = "falhou"
        -- Opcionalmente, tente novamente ou reatribua a tarefa
      end
    else
      print("Tarefa: " .. tarefa.descricao .. " não pode ser executada devido a dependências não atendidas.\n")
    end
  end
end

aliancaRebelde.processo = Processo:novo()
aliancaRebelde.tarefas = aliancaRebelde.processo:hierarquico(aliancaRebelde.tarefas)
aliancaRebelde:iniciar()
