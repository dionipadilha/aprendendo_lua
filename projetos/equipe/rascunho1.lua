--------------------------------------------------------------------------------
-- Passo nº 1: Criando ferramentas
-- Defina quaisquer ferramentas ou utilitários de que os agentes precisarão.
--------------------------------------------------------------------------------

-- Ferramenta: Registrador
local Registrador = {
  registrar = function(mensagem)
      print("[REGISTRO] " .. mensagem)
  end
}

-- Ferramenta: Inventário
Inventario = {
  novo = function(self)
      local inventario = { itens = {} }
      setmetatable(inventario, self)
      self.__index = self
      return inventario
  end,
  adicionarItem = function(self, item)
      table.insert(self.itens, item)
  end,
  listarItens = function(self)
      for _, item in ipairs(self.itens) do
          Registrador.registrar("Item: " .. item)
      end
  end
}

--------------------------------------------------------------------------------
-- Passo nº 2: Montar os Agentes
-- Defina os agentes da nossa equipe, dando a eles atributos e habilidades.
--------------------------------------------------------------------------------

local Agente = {
  novo = function(self, nome, papel, habilidades)
      local agente = {
          nome = nome,
          papel = papel,
          habilidades = habilidades,
          inventario = Inventario:novo()
      }
      setmetatable(agente, self)
      self.__index = self
      return agente
  end,
  executarTarefa = function(self, tarefa)
      if self.habilidades[tarefa] then
          Registrador.registrar(self.nome .. " está executando a tarefa: " .. tarefa)
          self.habilidades[tarefa]()
      else
          Registrador.registrar(self.nome .. " não pode executar a tarefa: " .. tarefa)
      end
  end,
  adicionarItemAoInventario = function(self, item)
      self.inventario:adicionarItem(item)
  end,
  listarInventario = function(self)
      self.inventario:listarItens()
  end
}

--------------------------------------------------------------------------------
-- Passo nº 3: Definir as Tarefas
-- Defina as tarefas ou objetivos que a equipe precisará cumprir.
--------------------------------------------------------------------------------

local Tarefas = {
  coletarRecursos = function()
      Registrador.registrar("Coletando recursos...")
  end,
  construirAbrigo = function()
      Registrador.registrar("Construindo abrigo...")
  end,
  explorarArea = function()
      Registrador.registrar("Explorando a área...")
  end
}

--------------------------------------------------------------------------------
-- Passo nº 4: Formar a Equipe
-- Monte a equipe atribuindo agentes às tarefas.
--------------------------------------------------------------------------------

Equipe = {
  novo = function(self)
      local equipe = { agentes = {} }
      setmetatable(equipe, self)
      self.__index = self
      return equipe
  end,
  adicionarAgente = function(self, agente)
      table.insert(self.agentes, agente)
  end,
  atribuirTarefas = function(self, atribuicoesDeTarefas)
      for nomeDoAgente, tarefa in pairs(atribuicoesDeTarefas) do
          for _, agente in ipairs(self.agentes) do
              if agente.nome == nomeDoAgente then
                  agente:executarTarefa(tarefa)
              end
          end
      end
  end
}


-- Criar os agentes
local john = Agente:novo("John", "Construtor", {construirAbrigo = Tarefas.construirAbrigo})
local sarah = Agente:novo("Sarah", "Batedora", {explorarArea = Tarefas.explorarArea})
local alex = Agente:novo("Alex", "Coletor", {coletarRecursos = Tarefas.coletarRecursos})

-- Formar a equipe
local equipe = Equipe:novo()
equipe:adicionarAgente(john)
equipe:adicionarAgente(sarah)
equipe:adicionarAgente(alex)

--------------------------------------------------------------------------------
-- Passo nº 5: Dar a Partida
-- Execute as tarefas e gerencie a equipe.
--------------------------------------------------------------------------------

local atribuicoesDeTarefas = {
  John = "construirAbrigo",
  Sarah = "explorarArea",
  Alex = "coletarRecursos"
}

equipe:atribuirTarefas(atribuicoesDeTarefas)

-- Adicionando itens ao inventário dos agentes
john:adicionarItemAoInventario("Martelo")
sarah:adicionarItemAoInventario("Binóculos")
alex:adicionarItemAoInventario("Mochila")

-- Listar o inventário de cada agente
john:listarInventario()
sarah:listarInventario()
alex:listarInventario()
