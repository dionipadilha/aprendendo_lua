# Comece aqui: seus 3 primeiros dias com Lua

Este roteiro conduz quem nunca escreveu uma linha de Lua do zero ao
primeiro programa próprio, em três sessões curtas de estudo. Cada passo
diz **o que abrir** e **o que executar** — sem decisões para tomar.
Ao terminar, siga para a trilha completa em
[`guia_de_estudos.md`](guia_de_estudos.md).

> **Pré-requisito:** Lua 5.4 instalado. No Linux: `sudo apt install lua5.4`.
> No Windows: siga [`instalacao_lua_win10.md`](instalacao_lua_win10.md)
> (lá o comando final é `lua`; neste roteiro usamos `lua5.4` — são o
> mesmo interpretador).

---

## Dia 1 — Instalar, executar e conhecer os tipos

1. **Confirme a instalação.** No terminal:

   ```sh
   lua5.4 -v
   ```

   Deve aparecer `Lua 5.4.x`. Sem isso, nada abaixo funciona — resolva
   a instalação primeiro.

2. **Execute o primeiro programa.** A partir da raiz do repositório:

   ```sh
   cd basico
   lua5.4 ola_mundo.lua
   ```

3. **Abra e leia [`basico/ola_mundo.lua`](../basico/ola_mundo.lua).**
   Uma linha. Modifique a mensagem, execute de novo. Você acabou de
   editar um programa Lua.

4. **Faça o tour da linguagem.** Execute e depois **leia por inteiro**
   [`basico/lua_introducao_rapida.lua`](../basico/lua_introducao_rapida.lua):

   ```sh
   lua5.4 lua_introducao_rapida.lua
   ```

   Ele mostra, em ~160 linhas, quase tudo que os próximos dias
   aprofundam. Não precisa entender tudo — precisa *ver* tudo.

5. **Termine o dia com os tipos.** Leia
   [`basico/tipos.md`](../basico/tipos.md) e execute
   [`basico/tipos.lua`](../basico/tipos.lua). Guarde uma ideia-chave:
   em Lua, `nil` e `false` são os únicos valores falsos.

## Dia 2 — Controle de fluxo e funções

1. **Condicionais e laços.** Leia
   [`controle_de_fluxo/controle_de_fluxo.md`](../controle_de_fluxo/controle_de_fluxo.md)
   e execute, um a um, a partir da pasta `controle_de_fluxo/`:

   ```sh
   cd controle_de_fluxo
   lua5.4 valores_verdadeiros.lua
   lua5.4 lacos.lua
   ```

2. **Funções.** Execute a partir da pasta `funcoes/`:

   ```sh
   cd ../funcoes
   lua5.4 funcoes.lua
   lua5.4 argumentos.lua
   ```

   Repare no padrão dos arquivos: cada afirmação termina num `assert`.
   Se o arquivo rodou sem erro, tudo que ele afirma é verdade — use
   isso a seu favor: **quebre um assert de propósito** e veja o erro.

3. **Primeiro exercício.** Abra o exercício 1 da lista no fim desta
   página e tente resolver sem olhar a solução.

## Dia 3 — Tabelas e o primeiro mini-projeto

1. **Tabelas são TUDO em Lua** (listas, dicionários, objetos, módulos).
   Execute a partir da pasta `tabelas/`:

   ```sh
   cd ../tabelas
   lua5.4 tabelas.lua
   lua5.4 vetores.lua
   ```

2. **Um clássico completo.** Leia e execute
   [`basico/fizzbuzz.lua`](../basico/fizzbuzz.lua) — repare que a
   lógica vive numa função *testável*, e os asserts no fim provam que
   ela funciona.

3. **Seu primeiro programa.** Faça os exercícios 2 e 3 abaixo. Eles
   usam apenas o que você viu nos três dias.

---

## Exercícios propostos

Tente cada um por conta própria antes de comparar com as soluções em
[`projetos/exercicios/`](../projetos/exercicios/) — elas seguem o padrão
do repositório (funções + asserts) e rodam na CI como qualquer lição.

1. **Par ou ímpar** — escreva uma função `parOuImpar(n)` que devolve a
   string `"par"` ou `"impar"`. (Dica: operador `%`.)
   Solução: [`projetos/exercicios/par_ou_impar.lua`](../projetos/exercicios/par_ou_impar.lua)

2. **Maior da lista** — escreva `maiorDaLista(numeros)` que devolve o
   maior número de uma lista, sem usar `math.max`. (Dica: `ipairs`.)
   Solução: [`projetos/exercicios/maior_da_lista.lua`](../projetos/exercicios/maior_da_lista.lua)

3. **Contador de palavras** — escreva `contarPalavras(frase)` que
   devolve quantas palavras há numa frase separada por espaços.
   (Dica: `string.gmatch(frase, "%S+")`.)
   Solução: [`projetos/exercicios/contar_palavras.lua`](../projetos/exercicios/contar_palavras.lua)

4. **Inverter tabela** — escreva `inverter(lista)` que devolve uma
   lista nova com os elementos na ordem contrária, sem modificar a
   original. Solução: [`projetos/exercicios/inverter_tabela.lua`](../projetos/exercicios/inverter_tabela.lua)

## E depois?

- A trilha completa, tópico por tópico: [`guia_de_estudos.md`](guia_de_estudos.md)
- O mapa de tudo que existe no repositório: [`roteiro_de_estudos.yml`](roteiro_de_estudos.yml)
- Projetos completos para estudar: [`../projetos/`](../projetos/)
