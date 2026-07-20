-- principal.lua

-- Este projeto pluraliza substantivos do INGLÊS (ex.: man --> men, child --> children).
-- Por isso, os dados (as palavras em inglês) não são traduzidos; apenas os
-- identificadores, comentários e mensagens estão em português.

-- Requisitos:

local irregulares = require "irregulares"
local excecoes = require "excecoes"
local regulares = require "regulares"

-- Defina sua função principal:
local function plural(palavra)
  -- Validação da entrada
  assert(palavra and type(palavra) == "string", "Palavra inválida")

  -- Pré-processamento
  palavra = palavra:lower()

  -- Verifica os irregulares
  local pluralIrregular = irregulares(palavra)
  if pluralIrregular then return pluralIrregular end

  -- Verifica as exceções
  local pluralExcecao = excecoes(palavra)
  if pluralExcecao then return pluralExcecao end

  -- Padrão: aplica as regras
  local pluralRegular = regulares(palavra)
  return pluralRegular
end

return plural
