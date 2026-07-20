-- Controlador: Gerencia a interação entre o Modelo e a Visão.

local Classe = require "comum"

local Controlador = Classe:novo {}

-- O modelo e a visão são dependências POR INSTÂNCIA, injetadas no
-- construtor: como defaults na tabela da classe, todos os controladores
-- compartilhariam as MESMAS tabelas mutáveis.
function Controlador:novo(objeto)
  objeto = Classe.novo(self, objeto)
  assert(objeto.modelo and objeto.visao,
    "o controlador requer um modelo e uma visão")
  return objeto
end

function Controlador:definirDados(dados)
  assert(
    type(dados) == "string" and dados ~= "",
    "os dados devem ser uma string não vazia"
  )
  self.modelo:definirDados(dados)
  -- Variante "push": o controlador entrega os dados à visão. No MVC
  -- clássico a visão consulta (ou observa) o modelo; esta forma mais
  -- direta é comum em exemplos e aproxima o desenho de um MVP.
  self.visao:renderizar(dados)
end

function Controlador:obterDados()
  return self.modelo:obterDados()
end

return Controlador
