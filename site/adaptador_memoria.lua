-- adaptador_memoria.lua

-- Adaptador de MEMÓRIA para as portas do núcleo: um "repositório" e um
-- "disco" feitos de tabelas Lua. É o segundo implementador das portas
-- — a razão de elas existirem — e o que permite testar o núcleo em
-- qualquer plataforma, sem find nem sistema de arquivos
-- (ver testar_nucleo.lua).
--
-- Contrato das portas: o mesmo documentado em adaptador_arquivos.lua.

local M = {}

-- arquivos: { ["pasta/arquivo.md"] = "conteúdo", ... }
-- Devolve leitura, escrita e a tabela `saida` (caminho -> conteúdo
-- escrito), que os testes inspecionam diretamente.
function M.novo(arquivos)
  local leitura = {
    listar = function(pasta)
      local lista = {}
      for caminho in pairs(arquivos) do
        if caminho:sub(1, #pasta + 1) == pasta .. "/" then
          table.insert(lista, caminho)
        end
      end
      table.sort(lista) -- mesma garantia de ordem do find ... | sort
      return lista
    end,

    ler = function(caminho)
      return assert(arquivos[caminho], "arquivo fictício não existe: " .. caminho)
    end,
  }

  local saida = {}
  local escrita = {
    preparar = function()
      for chave in pairs(saida) do saida[chave] = nil end
    end,

    escrever = function(caminho, conteudo)
      saida[caminho] = conteudo
    end,
  }

  return leitura, escrita, saida
end

return M
