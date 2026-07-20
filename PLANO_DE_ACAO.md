# Plano de Ação — Repositório de Tutoriais de Lua

Plano baseado em uma auditoria executada em 2026-07-20: todos os arquivos `.lua` da raiz e os subprojetos foram executados com Lua 5.4, e os guias em Markdown foram revisados. O plano está organizado em quatro fases, da mais urgente à mais opcional. Cada item traz o problema, a ação proposta e o critério de aceitação.

---

## Fase 1 — Corrigir código quebrado (prioridade alta)

O README promete "códigos revisados e testados"; esta fase torna a promessa verdadeira.

### 1.1 `class.lua` — stack overflow no mecanismo de `super`
- **Problema:** `ClassC:fc()` sobrescreve o método original e `self:super(ClassC, "fc")` busca o método na própria `ClassC`, que já contém a versão sobrescrita — recursão infinita (`class.lua:25`). Os asserts finais nunca executam.
- **Ação:** guardar a referência ao método original antes do override (ex.: `local base_fc = ClassC.fc`) ou implementar `super` com cadeia real de herança (classe pai via metatable), que é o modelo idiomático em Lua.
- **Aceitação:** `lua5.4 class.lua` termina com código 0 e todos os asserts passam.

### 1.2 `output_formatting.lua` — incompatibilidade de versão
- **Problema:** usa `unpack` (Lua 5.1/LuaJIT); em Lua 5.3+ é `table.unpack` (`output_formatting.lua:31`). O script morre no meio.
- **Ação:** trocar por `table.unpack` (ou `table.unpack or unpack` se quiser manter compatibilidade com 5.1).
- **Aceitação:** o script executa até o fim em Lua 5.4.

### 1.3 `json/` — caminhos de `require` inconsistentes
- **Problema:** `json/json.lua` faz `require "json.json_decode"` (relativo à raiz), mas `json/main.lua` faz `require "json"` (relativo à pasta). O exemplo não roda de nenhum diretório.
- **Ação:** padronizar os requires para execução a partir da pasta `json/` (`require "json_decode"` etc.) e documentar no `json/readme.md` de onde executar.
- **Aceitação:** `cd json && lua5.4 main.lua` funciona.

### 1.4 `loaders.lua` — dependência ausente
- **Problema:** carrega `file.lua`, que não existe no repositório.
- **Ação:** adicionar o `file.lua` de exemplo ou reescrever a demonstração usando um arquivo existente.
- **Aceitação:** `lua5.4 loaders.lua` executa sem erro.

### 1.5 `require.lua` e `interface.lua` — arquivos sintaticamente inválidos
- **Problema:** cada um concatena dois "arquivos virtuais" (módulo com `return` no meio + código consumidor), o que não é Lua válido. Os subdiretórios `interface/` e `strategy/` já demonstram o mesmo conceito da forma correta.
- **Ação:** converter esses arquivos em `.md` (mostrando os dois arquivos em blocos de código separados) ou removê-los, apontando para os subdiretórios equivalentes.
- **Aceitação:** nenhum arquivo `.lua` do repositório falha por erro de sintaxe.

### 1.6 Erros demonstrativos não capturados
- **Problema:** `readonly.lua:13` e `unit_tests.lua:88` lançam erros propositais, mas sem captura — o script termina no meio e o restante do exemplo nunca roda.
- **Ação:** envolver as chamadas demonstrativas em `pcall`, imprimindo a mensagem capturada (o que, aliás, ensina o padrão correto de tratamento de erros).
- **Aceitação:** os scripts executam até a última linha com código de saída 0.

---

## Fase 2 — Padronização e qualidade (prioridade média)

### 2.1 Definir a versão-alvo de Lua
- **Ação:** declarar no README que o repositório tem Lua 5.4 como alvo (versão atual e a usada na auditoria) e revisar os exemplos para essa versão.

### 2.2 Corrigir typos
- **Ação:** renomear `anonymous_functios.md` → `anonymous_functions.md`; corrigir "abstracat" e "instace" em `class.lua`; fazer uma varredura ortográfica nos demais comentários.

### 2.3 Padronizar idioma
- **Problema:** mistura de português e inglês em nomes e conteúdo (`corotinas.md` vs `coroutines_expanded.md`, `tipos.md`, `fluxo.md`).
- **Ação:** escolher uma convenção (sugestão: nomes de arquivos em inglês, texto didático em português, que é o público do README) e aplicá-la.

### 2.4 Adicionar `.gitignore`
- **Problema:** vários exemplos geram arquivos ao executar (`demofile.txt`, `test.txt`, `solid/log.txt`), que ficam como sujeira no `git status`.
- **Ação:** criar `.gitignore` com esses artefatos.

---

## Fase 3 — Infraestrutura do repositório (prioridade média)

### 3.1 Licença
- **Problema:** o README diz que o uso é livre, mas sem arquivo `LICENSE` o padrão legal é "todos os direitos reservados".
- **Ação:** adicionar `LICENSE` MIT, que corresponde ao espírito já expresso no README.

### 3.2 CI com GitHub Actions
- **Ação:** criar workflow que instala `lua5.4` e executa todos os `.lua` como smoke test (a mesma verificação da auditoria), com lista de exclusão para exemplos intencionalmente interativos ou de longa duração (`clock.lua`, os que usam busy-wait de `delay.lua`).
- **Aceitação:** badge verde no README; regressões como as da Fase 1 passam a ser detectadas automaticamente.

### 3.3 README atualizado
- **Ação:** incluir versão-alvo, instruções de execução, badge de CI e um índice do conteúdo.

---

## Fase 4 — Reorganização estrutural (opcional, maior impacto)

### 4.1 Estrutura de pastas guiada pelo roadmap
- **Problema:** mais de 100 arquivos achatados na raiz dificultam a navegação.
- **Ação:** usar o próprio `lua_roadmap.yml` como esqueleto de pastas — por exemplo: `basics/`, `functions/`, `tables/`, `oop/`, `coroutines/`, `errors/`, `patterns/`, `solid/`, `projects/` (Pluralizer, json, mvc, crew). Fazer a migração com `git mv` para preservar o histórico.
- **Aceitação:** raiz contendo apenas README, LICENSE, .gitignore, workflow e as pastas temáticas; links do índice do README funcionando.

### 4.2 Consolidar duplicações
- **Ação:** unificar pares que cobrem o mesmo tema (`corotinas.md` / `coroutines_expanded.md`; `basic_unit_test.lua` / `unit_tests.lua` / `Test/`), mantendo a melhor versão de cada.

---

## Ordem de execução sugerida

| Etapa | Itens | Esforço estimado |
|-------|-------|------------------|
| 1 | Fase 1 completa (1.1–1.6) | pequeno — correções pontuais |
| 2 | 2.4 e 3.1 (`.gitignore` + LICENSE) | trivial |
| 3 | 3.2 e 3.3 (CI + README) | pequeno |
| 4 | 2.1–2.3 (padronização) | médio — muitos arquivos |
| 5 | Fase 4 (reorganização) | médio/grande — mexe em tudo, fazer por último e em PR próprio |

A lógica da ordem: primeiro tornar o código correto (Fase 1), depois blindar contra regressões (CI) antes de qualquer renomeação ou reorganização em massa, para que as fases 2 e 4 possam ser validadas automaticamente.
