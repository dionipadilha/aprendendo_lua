# Depuração

A biblioteca `debug` abre o interpretador para inspeção: pilha de
chamadas, locais, upvalues e ganchos de execução. É ferramenta para
**depurar e construir ferramentas** (depuradores, profilers, cobertura)
— não pertence à lógica normal do programa: é lenta e fura o
encapsulamento de propósito.

| Arquivo | Tema |
|---------|------|
| `introspeccao.lua` | `debug.getinfo`, `getlocal`/`setlocal` e `getupvalue`/`setupvalue`: inspecionar (e alterar) pilha, locais e clausuras |
| `gancho.lua` | `debug.sethook`: gancho `"count"` como freio para laço infinito e gancho `"l"` como mini-cobertura de linhas |

Pontes com o resto do repositório:

- `debug.traceback` em ação está em
  [`../erros/objetos_de_erro.lua`](../erros/objetos_de_erro.lua) (#3,
  citado também em [`../erros/xpcall.lua`](../erros/xpcall.lua)): o
  tratador do `xpcall` roda antes de a pilha ser desfeita — o único
  momento em que o traceback completo existe.
- O freio de `gancho.lua` completa o sandbox de
  [`../modulos/ambientes.lua`](../modulos/ambientes.lua): o ambiente
  limita o que o código **enxerga**; o gancho limita quanto ele
  **executa**.
