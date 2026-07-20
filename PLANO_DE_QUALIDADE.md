# Plano de Qualidade de Conteúdo — Repositório de Tutoriais de Lua

Plano derivado da análise aprofundada de 2026-07-20: cinco frentes de revisão leram todos os arquivos do repositório e executaram os exemplos com Lua 5.4 para conferir as saídas reais. Diferente do primeiro plano (`PLANO_DE_ACAO.md`, hoje histórico), que tratou de estrutura e infraestrutura, este trata de **correção de conteúdo**: o que o material ensina e como garantir que continue certo.

Cada item traz o problema, a ação e o critério de aceitação. Gravidade indicada por fase.

---

## Fase 1 — Bugs objetivos em código (gravidade alta)

### 1.1 `basico/tipos.lua:29` — demonstração do tipo `thread` quebrada
- **Problema:** falta o `=` em `local co coroutine.create(...)` — parseia como duas instruções, `co` fica `nil` e `print(type(co))` imprime `nil`, contrariando o comentário `--> thread`. É a única demonstração de `thread` do repositório.
- **Ação:** corrigir para `local co = coroutine.create(quadratica)` e acrescentar `assert(type(co) == "thread")`.
- **Aceitação:** o arquivo imprime `thread` e o assert protege contra regressão.

### 1.2 `projetos/pluralizador/regulares.lua` — regra defeituosa e regra morta
- **Problema:** a regra `"on$" → "a"` super-generaliza (`lion → lia`, `lemon → lema`, `dragon → draga`); a regra `"us → i"` (linhas 64-70) é inalcançável porque `[xsz]$` captura antes (`focus → focuses`). Nenhum caso de teste cobre essas palavras, então o defeito passa despercebido.
- **Ação:** restringir a regra "on→a" a uma lista fechada (criterion, phenomenon); remover ou reordenar a regra "us→i"; adicionar `lion`, `lemon`, `focus` e `bus` a `validacao.lua`.
- **Aceitação:** `lion → lions`, `criterion → criteria`; `teste.lua` cobre os novos casos e passa.

### 1.3 `projetos/equipe/ferramentas_basicas.lua:41` — guarda de divisão por zero inerte
- **Problema:** `assert(type(segundo_numero) ~= 0, ...)` nunca dispara (`type()` retorna string); `dividir(6, 0)` devolve `inf` silenciosamente.
- **Ação:** corrigir para `assert(segundo_numero ~= 0, ...)`.
- **Aceitação:** dividir por zero gera o erro com a mensagem prevista; um caso de teste comprova.

### 1.4 `projetos/json/` — codificador gera JSON inválido; decodificador ignora escapes
- **Problema:** o codificador só escapa `"` — strings com `\` ou caracteres de controle produzem JSON inválido; o decodificador não interpreta sequências de escape (`\n` fica literal; `\uXXXX` não suportado). O readme só traz ressalva genérica.
- **Ação:** escapar `\`, `"` e controles no codificador; interpretar os escapes básicos no decodificador; documentar no `readme.md` as limitações que permanecerem (`\u`/unicode, `null` dentro de array, tabela vazia sempre vira `[]`).
- **Aceitação:** roundtrip de string com `\`, `"` e `\n` preserva o valor; readme lista as limitações restantes explicitamente.

---

## Fase 2 — Conteúdo que ensina o conceito errado (gravidade alta)

### 2.1 `solid/lsp.lua` — princípio ilustrado pelo seu contraexemplo
- **Problema:** usa Quadrado-herda-de-Retângulo — o contraexemplo canônico de violação de LSP — como exemplo positivo; o teste só imprime áreas, sem verificar substituibilidade.
- **Ação:** reescrever em duas partes: (a) mostrar a violação (setters que quebram o invariante do retângulo quando o subtipo é Quadrado) e (b) o redesenho conforme. O teste deve substituir o subtipo onde se espera a base e verificar um invariante com `assert`.
- **Aceitação:** o arquivo demonstra a violação e a solução, com asserts que passam.

### 2.2 `sistema/` — tempo de CPU confundido com tempo de parede
- **Problema:** `cronometro.lua` e `relogio.lua` usam `os.clock()` (tempo de CPU) como se fosse relógio de parede — só "funcionam" porque o busy-wait ocupa a CPU; `fonte_de_tempo.lua` rotula `os.clock()` como "hora atual" na simulação de NTP.
- **Ação:** basear cronômetro/relógio em `os.time`/`os.difftime`; reservar `os.clock` explicitamente para medição de CPU/benchmark, com um exemplo mostrando a diferença sob espera ociosa; fonte "NTP" passa a retornar `os.time()`.
- **Aceitação:** um exemplo demonstra `os.clock` parado e `os.time` avançando durante espera ociosa; comentários `-->` refletem o comportamento real.

### 2.3 Guias de corrotinas — idioma de erro falso e estado faltante
- **Problema:** `corrotinas_aprofundamento.md:70-79` ensina `pcall(coroutine.resume, co)`, que nunca captura nada (`resume` não lança erro; retorna `false, msg`) — o comentário de saída do exemplo é falso. Ambos os guias afirmam 3 estados; Lua 5.4 tem 4 (falta `normal`).
- **Ação:** corrigir para `local ok, err = coroutine.resume(co)`; documentar os 4 estados com exemplo do `normal`; mencionar `coroutine.close` (5.4).
- **Aceitação:** todos os trechos de código dos guias executam produzindo exatamente a saída anotada.

### 2.4 `controle_de_fluxo/controle_de_fluxo.md` — truthiness deturpado
- **Problema:** afirma que condições "retornam um valor booleano"; em Lua qualquer valor serve e só `nil`/`false` são falsos (`0` e `""` são verdadeiros). A descrição de `repeat`/`until` trata a estrutura como duas.
- **Ação:** reescrever a regra de condição com a semântica correta e exemplo do `0` verdadeiro; corrigir `repeat...until` como estrutura única que executa ao menos uma vez.
- **Aceitação:** o guia declara explicitamente que só `nil` e `false` são falsos.

### 2.5 `documentacao/roteiro_de_estudos.yml` — API inexistente
- **Problema:** ensina `frutas:insert("laranja")` e `frutas:insert("manga", 3)` (sintaxe de método não existe para tabelas comuns, e a ordem posição/valor está invertida) e menciona "parâmetros com valor padrão", que Lua não tem.
- **Ação:** corrigir para `table.insert(frutas, "laranja")` / `table.insert(frutas, 3, "manga")` / `table.remove(...)`; substituir "parâmetro padrão" pelo idioma real `parametro = parametro or padrao`.
- **Aceitação:** todo trecho de código do roteiro é Lua válido e correto.

### 2.6 `__add` mal exemplificado (duas ocorrências)
- **Problema:** `metatabelas/metatabela.lua` demonstra um `__add` que **muta o segundo operando e retorna string**; `documentacao/guia_de_estudos.md:131` promete `(15, 35)` mas o resultado não tem metatable — imprimiria `table: 0x...`.
- **Ação:** reescrever ambos com `__add` puro que retorna nova tabela com `setmetatable` (herdando `__tostring`).
- **Aceitação:** operandos intactos após a soma; saída impressa igual à anotada.

### 2.7 `poo/poo.md` — terminologia
- **Problema:** chama de "sobrecarga" (overloading) o que é sobrescrita (overriding); comentário cita método errado (linha 150).
- **Ação:** corrigir terminologia e o comentário.
- **Aceitação:** o termo "sobrecarga" não aparece para descrever override.

### 2.8 Correções pontuais de exemplos e comentários falsos
- `erros/erro.lua` e `erros/assercao.lua`: os erros demonstrados nunca disparam (idade=1) e o `--> assertion failed!` nunca ocorre — fazer os exemplos dispararem de fato e capturarem com `pcall`, mostrando também o prefixo `arquivo:linha` de `error` e o parâmetro `nivel`.
- `basico/operadores.lua:32`: anotação binária do XOR errada (`3` grafado como `0101`); `:79`: global acidental `argumentos`.
- `tabelas/tabelas.lua:23-36`: cabeçalho diz `ipairs` mas usa `pairs`; comentários assumem ordem de `pairs` — corrigir e registrar que a ordem não é garantida.
- `funcoes/funcoes.lua:104` e `corrotinas/corrotinas.md:52`: comentários omitem o prefixo de posição das mensagens de erro.
- `basico/fundamentos.md:81-82`: lista com identificadores nus (globais nil) — usar strings.
- `corrotinas/argumentos_de_corrotinas.lua:24`: `--> false` onde a saída real é `true`.
- **Aceitação:** todo comentário `-->` do repositório confere com a execução real.

---

## Fase 3 — Verificação que reprova de verdade (gravidade alta)

### 3.1 Mini-framework de teste que engole falhas
- **Problema:** `testes/teste_unitario_basico.lua` imprime a exceção mas sai com código 0; a chamada ao código sob teste não é protegida; a suíte tem um caso falhando comitado (`"gatosx"`) e o CI fica verde.
- **Ação:** o framework passa a contar aprovados/reprovados, retornar os totais e proteger a chamada ao código sob teste com `pcall`. A suíte declara expectativa explícita (lote 1: 3/3 aprovados; lote 2: exatamente 1 reprovação demonstrativa) e faz `assert` sobre os totais — a falha demonstrativa continua didática, mas qualquer desvio derruba o build.
- **Aceitação:** alterar um caso correto faz `suite_de_testes.lua` sair com código ≠ 0.

### 3.2 Asserts de topo nos exemplos-chave
- **Problema:** 83 dos 120 arquivos (69%) não têm nenhum `assert`; vários dos que têm embrulham em `pcall`/`xpcall`, sem afetar o exit code. O CI garante "não quebra", não "está correto" — foi assim que os bugs da Fase 1 sobreviveram.
- **Ação:** adicionar asserts de topo (fora de pcall) aos exemplos com saída determinística, priorizando: `basico/tipos.lua`, `tabelas/`, `funcoes/`, `poo/`, `metatabelas/`, `padroes/`. Exemplos de saída volátil (datas, aleatórios) verificam propriedades (tipo, faixa) em vez de valores.
- **Aceitação:** ≥ 70% dos arquivos com verificação efetiva; meta registrada no plano.

### 3.3 Determinismo e tempo de CI
- **Problema:** a suíte de testes usa busy-wait de duração aleatória (até ~18s de CPU); `rascunho2.lua` usa `math.random` sem semente.
- **Ação:** reduzir as esperas simuladas para décimos de segundo; semear `math.random` quando a saída for verificada.
- **Aceitação:** `./executar_testes.sh` completa em < 15s com saída estável.

---

## Fase 4 — POO segura e eliminação de código morto (gravidade média)

### 4.1 Estado de classe compartilhado entre instâncias
- **Problema:** tabelas mutáveis declaradas na classe e não reinicializadas em `novo` fazem instâncias compartilharem estado — demonstrado em `padroes/estrategia/carrinho_de_compras.lua` (dois carrinhos somam `$30.10` em vez de `$10.10`); latente em `tabelas/pilha.lua`, `tabelas/crud.lua`, `padroes/observador.lua`, `equipe/registrador.lua`.
- **Ação:** `novo` inicializa os campos mutáveis por instância (`self.itens = itens or {}`); adicionar um teste com duas instâncias em cada arquivo.
- **Aceitação:** duas instâncias independentes não se contaminam (assert comprova).

### 4.2 Globais acidentais
- **Ação:** tornar `local` as classes/variáveis em `padroes/fachada/*` (5 arquivos), `poo/polimorfismo.lua`, `solid/dip.lua`, `basico/operadores.lua:79`.
- **Aceitação:** nenhum exemplo cria globais além do necessário.

### 4.3 Código morto e duplicações
- `erros/try_except.lua` é byte-idêntico a `xpcall.lua` — substituir por uma abstração real `tentar/capturar/finalmente` (com `pcall` + bloco de limpeza) ou remover.
- Remover a classe `Visao` duplicada dentro de `padroes/mvc/modelo.lua`.
- Remover `projetos/equipe/rascunho1.lua` e `rascunho2.lua` (esboços com código morto, bug do "Death Star" e APIs incompatíveis com a versão final).
- Consolidar `poo/heranca_multipla.lua` dentro de `classe.lua`; unificar as duas implementações divergentes de `intervalo` em `testes/`; remover `esperados[6]` órfão em `testes_unitarios.lua`; dar propósito a `sistema/espera.lua` (chamar a função) ou removê-lo; reescrever `controle_de_fluxo/goto.lua` com o idioma útil (`goto continue`).
- Consolidar as quatro introduções redundantes de `basico/` em no máximo duas.
- **Aceitação:** nenhum arquivo byte-duplicado; nenhuma função definida e nunca usada.

### 4.4 Fundir os dois guias de corrotinas
- **Problema:** ~75% de sobreposição e os nomes invertidos (o "básico" é mais profundo que o "aprofundamento").
- **Ação:** fundir num único `corrotinas.md` — exemplos executáveis do guia atual + seções de vantagens/limitações do outro (já com as correções da Fase 2.3).
- **Aceitação:** um único guia, sem afirmações duplicadas ou contraditórias.

---

## Fase 5 — Alinhamento documentação ↔ código (gravidade média)

### 5.1 Construtor `:new()` → `:novo()` nos guias
- **Problema:** `guia_de_estudos.md:77,88`, `paradigmas_de_programacao.md:38,60` e `convencoes_de_nomenclatura.md:188` ensinam `:new()`; os 100+ exemplos do código usam `:novo()`.
- **Aceitação:** zero ocorrências de `:new(` na documentação.

### 5.2 Grafias e referências
- Padronizar "corrotina" (sem hífen) nos `.md`; padronizar `readme.md` → `README.md` nas subpastas; remover as referências quebradas em `tabelas/vetores.lua:107,167`; corrigir "LUA"→"Lua" e "Jhon" em `funcoes/`; corrigir o markdown quebrado em `convencoes_de_nomenclatura.md:272`.

### 5.3 Convenção única de identificadores
- **Problema:** camelCase e snake_case misturados entre pastas e dentro do mesmo arquivo (`sistema/cronometro.lua` usa `tempoInicial` e `tempo_inicial` para o mesmo conceito).
- **Ação:** adotar camelCase (maioria atual e favorecida pelas convenções); converter os focos de snake_case; atualizar `convencoes_de_nomenclatura.md` para prescrever (não apenas listar opções) e usar `local` nos próprios exemplos.
- **Aceitação:** um estilo por arquivo em 100% e por repositório nos arquivos tocados.

### 5.4 Trilha de estudo conectada à árvore
- **Ação:** no `roteiro_de_estudos.yml` e no `guia_de_estudos.md`, apontar a pasta correspondente a cada tópico (`poo/`, `corrotinas/`...).
- **Aceitação:** cada tópico da trilha referencia uma pasta existente.

---

## Fase 6 — Lacunas de Lua 5.4 (expansão, prioridade menor)

Em ordem de valor didático:

1. **Inteiro vs float** — `math.type`, `math.tointeger`, por que `/` e `^` sempre produzem float e `//` preserva inteiro (em `basico/tipos.*`).
2. **Truthiness** — exemplo dedicado (`0` e `""` verdadeiros) em `controle_de_fluxo/` (complementa 2.4).
3. **`<const>` e `<close>`** — em `basico/escopo.lua` e novo exemplo com `__close` (+ `__gc`, ponte com `gc/`; `coroutine.close` em `corrotinas/`; `local f <close>` em `io/`).
4. **Bytes vs caracteres** — biblioteca `utf8` em `basico/cadeias_de_texto.md` (o material usa strings acentuadas e `#` conta bytes).
5. **GC incremental vs geracional** — `collectgarbage("generational"/"incremental"/"count"/"step")` e `__mode="v"/"kv"` em `gc/`.
6. **Erros ricos** — `error` com tabela (error objects), `xpcall` + `debug.traceback`, re-lançamento (em `erros/`).
7. **Padrões ausentes** — Prototype (o mais natural em Lua), Singleton, Builder, Adapter, Command em `padroes/`.
8. **Infra menor** — `banco_de_dados/roteiro.sql` idempotente (`DROP TABLE IF EXISTS`) e checagem da presença do CLI; fallback `gtimeout` no `executar_testes.sh` para macOS/BSD.

---

## Ordem de execução sugerida

| Etapa | Itens | Esforço | Justificativa |
|-------|-------|---------|---------------|
| 1 | Fase 1 (bugs) + 2.8 (comentários falsos) | pequeno | correções sem ambiguidade |
| 2 | Fase 3 (verificação) | médio | blinda tudo o que vem depois |
| 3 | Fase 2 restante (conceitos errados) | médio | maior risco didático, já protegido pela etapa 2 |
| 4 | Fase 4 (POO segura + código morto) | médio | reduz a superfície antes do alinhamento |
| 5 | Fase 5 (docs e estilo) | médio | renomeações e prosa por último, validadas pela CI |
| 6 | Fase 6 (expansão 5.4) | contínuo | conteúdo novo, um tópico por vez |

A lógica repete a do primeiro plano: corrigir → blindar → padronizar → expandir. A diferença é o alvo: agora a blindagem é de **correção de conteúdo** (asserts que reprovam), não apenas de execução.
