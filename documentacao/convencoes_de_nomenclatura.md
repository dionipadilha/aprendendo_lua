# Guia Rápido para Nomenclatura em Lua

Este guia visa auxiliar programadores Lua na criação de nomes eficazes para variáveis, funções, classes e outros elementos.

## Criando Nomes

Investir tempo na escolha de nomes adequados para as variáveis e funções é crucial para a qualidade e legibilidade do código, tornando-o mais fácil de entender, manter e reutilizar.

## Clareza

Nomes devem comunicar imediatamente sua funcionalidade.

```lua
-- Calcular a média de um conjunto de notas
local function calcularMedia(notas)
  local soma = 0
  for _, nota in ipairs(notas) do
    soma = soma + nota
  end
  return soma / #notas
end

-- Conjuntos de notas semestrais
local notasPrimeiroSemestre = {10, 8, 7, 9}
local notasSegundoSemestre = {6, 8, 8, 7}

-- Imprimir a média do primeiro semestre
local media = calcularMedia(notasPrimeiroSemestre)
print("Média do primeiro semestre: " .. media) --> 8.5
```

### Precisão

Evitar ambiguidades e diferenciar nomes com propósitos semelhantes.

```lua
calcularAreaCirculo(raio)
calcularAreaQuadrado(lado)
calcularAreaTriangulo(base, altura)
```

### Consistência — convenção oficial deste repositório

Todos os exemplos e exercícios deste repositório seguem uma única convenção. Não é uma lista de opções: é a regra a ser aplicada.

| Elemento | Estilo | Exemplo |
| --- | --- | --- |
| Variáveis, funções e métodos | camelCase | `calcularMedia`, `notasParciais` |
| Classes e módulos-classe | PascalCase | `PedidoDeVenda`, `ContaBancaria` |
| Constantes | MAIUSCULAS_COM_SUBLINHADO | `RAZAO_AUREA`, `TAMANHO_MAXIMO` |
| Nomes de arquivo | minusculas_com_sublinhado | `controle_de_fluxo.lua` |

```lua
local notasParciais = {8, 7, 9}         -- variável: camelCase
local function calcularMedia(notas) end -- função: camelCase
local ContaBancaria = {}                -- classe: PascalCase
local RAZAO_AUREA <const> = 1.61803     -- constante: MAIUSCULAS_COM_SUBLINHADO
```

Identificadores não levam acento: Lua 5.4 só aceita letras ASCII (`A`–`Z`, `a`–`z`), dígitos e `_` em nomes. Escreva `calcularMedia`, e não `calcularMédia`; acentuação fica para strings e comentários.

### Iteradores Simples

Utilize nomes curtos, desde que permaneçam significativos.

```lua
-- Iteradores indexados
for i=1, #lista do print(lista[i]) end

-- Iteradores descritivos
for _, item in ipairs(lista) do print(item) end
```

### Comentários

Comentar o propósito, evitar o óbvio.

```lua
-- comentários desnecessário
  local soma = 0 -- Variável para armazenar a soma dos números

-- comentários descritivo
  -- Conjuntos de notas da turma do bob:
  local notasPrimeiroSemestre = {10, 8, 7, 9}
  local notasSegundoSemestre = {6, 8, 8, 7}
```

### Constantes

Use MAIUSCULAS_COM_SUBLINHADO. Em Lua 5.4, marque com `<const>` quando o valor não deve ser reatribuído.

```lua
local RAZAO_AUREA <const> = 1.61803
local PI <const> = 3.14
```

### Verbos no infinitivo e imperativo

Descrever a ação principal da função.

```lua
gerarRelatorioTrimestral()
fazerAlgumaCoisa()
imprimirDadosFormatados()
```

### Advérbios

Enfatizar como a função realiza sua ação.

```lua
ordenarListaPorNomes(listaUsuarios)
ordenarListaPorIdades(listaUsuarios)
```

### Substantivos

Representar claramente o objeto da função.

```lua
ordenarLista(listaUsuarios)
lerArquivo("usuario.txt")
```

### Adjetivos

Enfatizar características do substantivo.

```lua
ordenarLista(listaUsuariosNovos)
ordenarLista(listaUsuariosAntigos)
```

### Prefixos e Sufixos

Informar propósito, escopo ou tipo de retorno.

```lua
salvarArquivoXML()
processarDadosCSV()
validarUsuarioAdmin()
```

### Siglas

Usar para conceitos técnicos bem conhecidos.

```lua
calcularROI()
parseJSON()
criarPDF()
```

## Números em Nomes

- Evite o uso de números em nomes de variáveis e funções.

```lua
--  Nomes que não fornecem informações sobre o propósito da variável ou função.
local variavel1
funcao2()

-- Não use números para diferenciar variáveis ou funções semelhantes
processarDados1()
processarDados2()
```

- Use números em nomes quando eles tiverem um significado claro e justificado.

```lua
-- Casos onde o número é uma parte integral e bem conhecida do item
statusHTTP404()
codificacaoUTF8()

-- Contextos matemáticos ou científicos
eixoX1()
eixoY2()
```

## Nomenclatura de Classes e Objetos

### Classes

- Use substantivos ou frases nominais.
- Use a convenção PascalCase.

```lua
local PedidoDeVenda = {}
```

### Objetos

- Use camelCase.
- Use nomes descritivos.
- O nome do objeto geralmente deve ter uma relação clara com o nome da classe.

```lua
local pedidoDeVenda = PedidoDeVenda:novo()
```

## Exemplos de Nomes em diferentes contextos

### Manipulação de Strings

```lua
converterParaMaiusculas(string)
removerEspacosEmBranco(string)
substituirSubstrings(original, antigo, novo)
```

### Operações Matemáticas

```lua
calcularFatorial(numero)
verificarNumeroPrimo(numero)
calcularMediaPonderada(notas, pesos)
```

### Trabalhando com Listas

```lua
filtrarElementos(lista, condicao)
encontrarMaiorElemento(lista)
mesclarListas(lista1, lista2)
```

### Interações com Banco de Dados

```lua
buscarUsuarioPorID(id)
atualizarRegistro(registro)
inserirNovoUsuario(dados)
```

### Manipulação de Arquivos

```lua
lerConteudoArquivo(caminho)
escreverArquivo(caminho, dados)
copiarArquivo(origem, destino)
```

### Validações

```lua
validarEmail(email)
validarData(data)
verificarPermissaoAcesso(usuario, recurso)
```

### Gráficos e Visualizações

```lua
gerarGraficoBarras(dados)
criarMapaCalor(dados)
exibirGraficoPizza(dados)
```

## Armadilhas ao Criar Nomes

### Nomes Muito Longos

Priorize clareza sem tornar os nomes excessivamente longos, encontrando um equilíbrio entre clareza e concisão.

### Abreviações Excessivas

Use abreviações com moderação, escolhendo aquelas amplamente reconhecidas na comunidade de desenvolvimento.

### Sinônimos

Evite sinônimos para a mesma ação ou entidade, a menos que haja uma razão específica para a variação.

### Nomes Genéricos

Evite nomes genéricos como `funcao1()` ou `func_temporaria()`, pois não fornecem informações sobre a finalidade da função.

### Prefixos/Sufixos Redundantes

Evite partes que não agregam valor ao nome.

```lua
calcularMediaTotal(notasLista) -- redundante
calcularMedia(notas) -- suficiente
```
