-- verificar_saida.lua

-- Valida o PRODUTO do gerador — o site em _saida/ — e não apenas a
-- conversão (essa é testada por testar_markdown/testar_nucleo):
--   * todo .html gerado tem as tags balanceadas;
--   * todo link interno resolve para uma página gerada;
--   * todo link para o GitHub (blob/main) aponta para um arquivo que
--     existe no repositório.
--
-- Regera _saida/ reexecutando gerar.lua (a MESMA composição publicada;
-- _saida/ é gitignorada, então a árvore continua limpa) e valida o que
-- saiu. Roda pela suíte a partir de site/: termina com 0 no sucesso e
-- falha alto (código 1) em qualquer defeito do produto.

-- Mesma guarda de plataforma de gerar.lua (o adaptador usa `find`):
if package.config:sub(1, 1) == "\\" then
  print("Aviso: verificar_saida.lua usa `find` (POSIX); no Windows a verificação é pulada.")
  return
end

local resultado = assert(dofile("gerar.lua"),
  "gerar.lua não devolveu a configuração da geração")
local urlDoRepositorio = resultado.configuracao.urlDoRepositorio

local falhas = 0
local function falhar(mensagem)
  falhas = falhas + 1
  print("DEFEITO NA SAÍDA: " .. mensagem)
end

--------------------------------------------------------------------------------
-- inventário do que foi gerado

local geradas = {}
local paginas = {}
local processo = assert(io.popen("find _saida -type f | sort"))
for caminho in processo:lines() do
  local relativo = caminho:gsub("^_saida/", "")
  geradas[relativo] = true
  if relativo:match("%.html$") then table.insert(paginas, relativo) end
end
processo:close()
assert(#paginas > 0, "nada foi gerado em _saida/")

--------------------------------------------------------------------------------
-- HTML bem formado: tags balanceadas (elementos vazios ignorados)

local VAZIOS = { meta = true, link = true, br = true, hr = true, img = true,
  input = true, source = true, wbr = true }

local function verificarBalanceamento(conteudo, pagina)
  local pilha = {}
  for tag in conteudo:gmatch("<[^>]+>") do
    if tag:match("^</") then
      local nome = tag:match("^</%s*([%w]+)")
      local topo = table.remove(pilha)
      if topo ~= nome then
        falhar(("%s: </%s> fecha <%s>"):format(pagina, nome or "?", topo or "nada"))
        return
      end
    elseif not (tag:match("^<!") or tag:match("/>$")) then -- nem doctype nem auto-fechada
      local nome = tag:match("^<%s*([%w]+)")
      if nome and not VAZIOS[nome:lower()] then
        table.insert(pilha, nome)
      end
    end
  end
  if #pilha > 0 then
    falhar(("%s: %d tag(s) sem fechamento (última: <%s>)")
      :format(pagina, #pilha, pilha[#pilha]))
  end
end

--------------------------------------------------------------------------------
-- links: internos resolvem no _saida/; blob/main resolve no repositório

local function normalizar(base, alvo)
  local absoluto = (base == "" and "" or base .. "/") .. alvo
  local partes = {}
  for parte in absoluto:gmatch("[^/]+") do
    if parte == ".." then
      table.remove(partes)
    elseif parte ~= "." then
      table.insert(partes, parte)
    end
  end
  return table.concat(partes, "/")
end

local function existeNoRepositorio(caminho)
  local arquivo = io.open("../" .. caminho, "rb")
  if arquivo then arquivo:close() end
  return arquivo ~= nil
end

local function verificarLinks(conteudo, pagina)
  local pastaDaPagina = pagina:match("^(.*)/[^/]+$") or ""
  -- blocos <pre> exibem código-fonte ESCAPADO — um href=" ali é texto
  -- da lição, não um link da página; ficam fora da checagem.
  local semCodigo = conteudo:gsub("<pre.-</pre>", "")
  for alvo in semCodigo:gmatch('href="([^"]*)"') do
    if alvo:match("^https?://") then
      local noRepositorio = alvo:match("^" .. urlDoRepositorio:gsub("%p", "%%%1")
        .. "/blob/main/(.+)$")
      if noRepositorio and not existeNoRepositorio(noRepositorio) then
        falhar(("%s: link para fonte inexistente no repositório: %s")
          :format(pagina, noRepositorio))
      end
    elseif not (alvo:match("^#") or alvo:match("^mailto:") or alvo:match("^data:")) then
      -- (âncoras, e-mails e o favicon data: não têm o que resolver)
      local caminho = normalizar(pastaDaPagina, (alvo:gsub("#.*$", "")))
      local resolve = geradas[caminho]
        or (alvo:match("/$") and geradas[caminho .. "/index.html"])
      if not resolve then
        falhar(("%s: link interno não resolve: %s"):format(pagina, alvo))
      end
    end
  end
end

--------------------------------------------------------------------------------

for _, pagina in ipairs(paginas) do
  local arquivo = assert(io.open("_saida/" .. pagina, "rb"))
  local conteudo = arquivo:read("a")
  arquivo:close()
  verificarBalanceamento(conteudo, pagina)
  verificarLinks(conteudo, pagina)
end

if falhas > 0 then
  print(("verificar_saida: %d defeito(s) no site gerado."):format(falhas))
  os.exit(1)
end
print(("saída verificada: %d páginas com HTML balanceado e links íntegros.")
  :format(#paginas))
