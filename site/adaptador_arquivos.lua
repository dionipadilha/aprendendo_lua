-- adaptador_arquivos.lua

-- Adaptador de SISTEMA DE ARQUIVOS para as portas do núcleo (POSIX).
-- Todo o código dependente de plataforma do gerador vive AQUI: find,
-- io.open, mkdir, rm. É por este arquivo — e só por ele — que o
-- gerador não roda no Windows; o núcleo em si roda em qualquer lugar
-- (é o que testar_nucleo.lua prova, com o adaptador de memória).
--
-- Contrato das portas (definido pelo núcleo — ver nucleo.lua):
--   leitura.listar(pasta)  -> lista de caminhos relativos à raiz, ordenada
--   leitura.ler(caminho)   -> conteúdo do arquivo
--   escrita.preparar()     -> deixa o destino vazio e pronto
--   escrita.escrever(caminho, conteudo) -> grava a página

local M = {}

-- opcoes: { raiz = "..", saida = "_saida" }
function M.novo(opcoes)
  local raiz, saida = opcoes.raiz, opcoes.saida

  local leitura = {
    listar = function(pasta)
      local lista = {}
      local comando = ("find '%s/%s' -type f -not -path '*/%s/*' | sort")
        :format(raiz, pasta, saida)
      local processo = assert(io.popen(comando))
      for caminho in processo:lines() do
        -- caminho relativo à raiz do repositório (sem o prefixo "../"):
        table.insert(lista, (caminho:gsub("^" .. raiz .. "/", "")))
      end
      processo:close()
      return lista
    end,

    ler = function(caminho)
      local arquivo = assert(io.open(raiz .. "/" .. caminho, "rb"),
        "não consegui ler " .. caminho)
      local conteudo = arquivo:read("a")
      arquivo:close()
      return conteudo
    end,
  }

  local escrita = {
    preparar = function()
      os.execute(("rm -rf '%s' && mkdir -p '%s'"):format(saida, saida))
    end,

    escrever = function(caminho, conteudo)
      local diretorio = caminho:match("^(.*)/[^/]+$")
      if diretorio then
        os.execute(("mkdir -p '%s/%s'"):format(saida, diretorio))
      end
      local arquivo = assert(io.open(saida .. "/" .. caminho, "wb"),
        "não consegui escrever " .. caminho)
      arquivo:write(conteudo)
      arquivo:close()
    end,
  }

  return leitura, escrita
end

return M
