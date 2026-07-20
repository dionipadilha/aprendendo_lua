-- xpcall.lua

-- xpcall(funcao, tratador, ...) executa a função em modo protegido e,
-- em caso de erro, chama o tratador ANTES de desfazer a pilha.
-- Retorna: true e os resultados da função, ou false e o retorno do tratador.

local App = {
  tentar = function(a, b)
    assert(a + b == 7, "a soma deve ser 7")
    return a + b
  end,

  capturar = function(excecao)
    print("capturado: " .. excecao)
    return excecao
  end
}

-- Caso de sucesso: o tratador não é chamado.
local ok1, resultado = xpcall(App.tentar, App.capturar, 3, 4)
assert(ok1)
assert(resultado == 7)

-- Caso de falha: o tratador roda e xpcall retorna false + retorno do tratador.
local ok2, excecao = xpcall(App.tentar, App.capturar, 6, 3)
assert(not ok2)
assert(type(excecao) == "string")
assert(excecao:match("a soma deve ser 7$"))

print("finalmente ...")

--------------------------------------------
-- Veja também: pcall, try_except, objetos_de_erro (xpcall + debug.traceback)
