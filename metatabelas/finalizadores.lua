-- finalizadores.lua

-- Recursos de Lua 5.4 para liberar recursos:
--   __close: variáveis to-be-closed (local x <close>), fechadas de forma
--            DETERMINÍSTICA ao sair do escopo, em ordem inversa à declaração.
--   __gc:    finalizadores chamados pelo coletor de lixo, em momento decidido
--            pelo próprio coletor (aqui, forçado com collectgarbage).

--------------------------------------------------------------------------------
-- Variáveis to-be-closed: __close roda ao sair do escopo.

local registroDeEventos = {}

local function novoRecursoFechavel(nome)
  return setmetatable({ nome = nome }, {
    __close = function(self)
      table.insert(registroDeEventos, self.nome .. " fechado")
    end
  })
end

do
  local primeiro <close> = novoRecursoFechavel("primeiro")
  local segundo <close> = novoRecursoFechavel("segundo")
  table.insert(registroDeEventos, "fim do bloco")
end

print(table.concat(registroDeEventos, " | "))
--> fim do bloco | segundo fechado | primeiro fechado

-- A ordem de fechamento é a inversa da declaração:
assert(registroDeEventos[1] == "fim do bloco")
assert(registroDeEventos[2] == "segundo fechado")
assert(registroDeEventos[3] == "primeiro fechado")

--------------------------------------------------------------------------------
-- __gc: roda quando o coletor recolhe um objeto inalcançável.

local coletados = {}

local function novoRecursoFinalizavel(nome)
  -- __gc precisa estar na metatabela no momento do setmetatable
  -- para o objeto ser marcado para finalização:
  return setmetatable({ nome = nome }, {
    __gc = function(self)
      table.insert(coletados, self.nome .. " finalizado")
    end
  })
end

do
  local recursoA = novoRecursoFinalizavel("recursoA")
  local recursoB = novoRecursoFinalizavel("recursoB")
end
-- Fora do bloco, recursoA e recursoB ficaram inalcançáveis;
-- uma coleta completa chama os finalizadores:
collectgarbage("collect")

print(table.concat(coletados, " | "))
--> recursoB finalizado | recursoA finalizado

-- Os finalizadores rodam na ordem inversa à marcação dos objetos:
assert(#coletados == 2)
assert(coletados[1] == "recursoB finalizado")
assert(coletados[2] == "recursoA finalizado")
