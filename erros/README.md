# Tratamento de erros

Lua sinaliza erros com `error` e os captura com `pcall`/`xpcall`;
`assert` transforma condições falsas em erro. O valor do erro pode ser
uma string (que ganha o prefixo `arquivo:linha`) ou qualquer outro
valor — inclusive tabelas estruturadas.

| Arquivo | Tema |
|---------|------|
| `erro.lua` | `error`, o parâmetro de nível e o prefixo `arquivo:linha` |
| `assercao.lua` | `assert` com mensagens e verificação robusta do prefixo |
| `pcall.lua` | Modo protegido básico |
| `xpcall.lua` | Tratador de erros (executa antes de desfazer a pilha) |
| `objetos_de_erro.lua` | Valores de erro que não são strings |
| `erro_estruturado.lua` | Erro com classe, campos e `__tostring`; `warn` (5.4) |
| `try_except.lua` | Um try/except/finally construído sobre pcall |

Convenção do repositório: os asserts que valem como teste ficam no
**topo** do arquivo — um assert que falha dentro de `pcall` é capturado
e não afeta o código de saída, então não serve como verificação de CI.
