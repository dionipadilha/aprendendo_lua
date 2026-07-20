# Codificação/decodificação de JSON

Este projeto cobre a codificação e a decodificação básicas de JSON sem a
necessidade de bibliotecas externas.

O codificador escapa `\`, `"` e os caracteres de controle (`\n`, `\t`, `\r`,
`\b`, `\f`; os demais controles viram `\u00XX`). O decodificador interpreta as
sequências de escape básicas (`\"`, `\\`, `\/`, `\n`, `\t`, `\r`, `\b`, `\f`).
Os testes de roundtrip estão em `principal.lua`.

## Limitações conhecidas

Esta implementação é didática e simplificada. As limitações abaixo permanecem
de propósito — para uso em produção prefira uma biblioteca madura (ex.:
dkjson, lua-cjson):

- **`\uXXXX`/Unicode:** o decodificador não interpreta escapes `\uXXXX`
  (lança erro ao encontrá-los). O codificador emite `\u00XX` apenas para
  caracteres de controle raros; texto UTF-8 é copiado byte a byte, sem
  validação.
- **`null` dentro de array é perdido:** `null` decodifica para `nil`, e
  inserir `nil` numa tabela Lua não cria posição — `[1, null, 3]` vira
  `{1, 3}`, deslocando os elementos seguintes.
- **Tabela vazia sempre vira `[]`:** Lua não distingue "objeto vazio" de
  "array vazio", então `{}` é sempre codificada como `[]`, nunca como `{}`.
