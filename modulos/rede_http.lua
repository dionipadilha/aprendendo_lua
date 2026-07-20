-- rede_http.lua

-- Rede com guarda de dependência OPCIONAL — o mesmo padrão de
-- ../banco_de_dados/sqlite3.lua: detectar a ferramenta antes de usá-la
-- e, na ausência, avisar e encerrar com sucesso (exit 0).
--
-- Por que o LuaSocket não é dependência dura do repositório: a
-- biblioteca padrão de Lua NÃO inclui rede (sockets vêm de módulos C
-- externos), e material didático precisa rodar com PUC-Lua puro.
-- Exigir o luasocket quebraria a CI e o primeiro contato de quem só
-- instalou o interpretador. A lição principal deste arquivo É a guarda.

-- A guarda: pcall(require, ...) devolve false em vez de propagar o erro
-- quando o módulo não está instalado (require sem pcall ABORTARIA aqui).
local temSocket, socket = pcall(require, "socket")
if not temSocket then
  print("Aviso: o módulo 'socket' (LuaSocket) não está instalado; demonstração pulada.")
  print("Instale-o com o LuaRocks para executar este exemplo:")
  print("  luarocks install luasocket")
  -- O return encerra o script com exit 0: dependência OPCIONAL ausente
  -- não é falha — mesmo contrato de ../banco_de_dados/sqlite3.lua.
  return
end

-- socket.http é um submódulo separado; com o luasocket instalado, existe:
local temHttp, http = pcall(require, "socket.http")
assert(temHttp, "luasocket instalado, mas socket.http indisponível")
print("LuaSocket disponível: " .. tostring(socket._VERSION))

--------------------------------------------------------------------------------
-- Requisição HTTP — protegida também contra AUSÊNCIA DE REDE: numa
-- máquina com luasocket porém offline (CI atrás de firewall), o request
-- falha e este exemplo avisa e sai com 0 do mesmo jeito. O que se
-- verifica aqui é a guarda, não a disponibilidade da internet.

local URL <const> = "http://example.com/"
local corpo, codigo = http.request(URL)
if not corpo then
  -- na falha, o segundo retorno é a MENSAGEM de erro do socket
  -- (ex.: "timeout", "host or service not provided"):
  print(("Aviso: requisição a %s falhou (%s); sem acesso à rede?"):format(URL, tostring(codigo)))
  return
end

-- Com rede, corpo é o documento e codigo é o status HTTP numérico:
assert(codigo == 200, "esperava status 200, obtive " .. tostring(codigo))
assert(#corpo > 0)
print(("HTTP %d de %s (%d bytes recebidos)"):format(codigo, URL, #corpo))
