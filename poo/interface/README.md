# Carrinho de Compras em Lua com Sistema de Pagamento

Este projeto demonstra uma implementação simples de carrinho de compras em Lua, com suporte a múltiplos métodos de pagamento por meio de um design baseado em interface.

## Componentes Principais

-   **Interface `IPagamento` (`ipagamento.lua`)**: Define o contrato para os métodos de pagamento, especificando as propriedades obrigatórias (`data`, `dadosDoMetodo`) e os métodos obrigatórios (`podeRealizarPagamento`, `processarPagamento`, `pagar`).

-   **Implementações de Pagamento**:

    -   **`CartaoDeCredito` (`cartao_de_credito.lua`)**: Lida com pagamentos por cartão de crédito, armazenando os dados do cartão e simulando o processamento do pagamento.
    -   **`Pix` (`pix.lua`)**: Suporta pagamentos via Pix, armazenando a chave Pix e simulando o processamento do pagamento.
-   **`CarrinhoDeCompras` (`carrinho_de_compras.lua`)**: Representa o carrinho de compras em si. Permite definir um método de pagamento e iniciar o processo de finalização da compra.

-   **`principal.lua`**: Fornece um exemplo de uso, criando um carrinho de compras, definindo diferentes métodos de pagamento e finalizando compras.


## Como Funciona

1.  **Interface de Pagamento**: A interface `IPagamento` garante que todos os métodos de pagamento sigam uma estrutura comum, tornando o carrinho de compras adaptável a diferentes opções de pagamento.

2.  **Classes de Pagamento**: As classes `CartaoDeCredito` e `Pix` implementam a interface `IPagamento`, fornecendo implementações concretas para pagamentos por cartão de crédito e Pix, respectivamente.

3.  **Carrinho de Compras**: A classe `CarrinhoDeCompras` mantém uma referência ao método de pagamento selecionado. Quando `finalizarCompra` é chamado, ela delega o processamento do pagamento ao objeto de pagamento associado.

4.  **Script Principal**: O script `principal.lua` demonstra como criar um carrinho de compras, definir métodos de pagamento e finalizar compras.


## Uso

1.  **Incluir os Módulos**: Faça o require dos módulos necessários no seu script Lua:

```lua
local CarrinhoDeCompras = require "carrinho_de_compras"
local CartaoDeCredito = require "cartao_de_credito"
local Pix = require "pix"
```
2. **Criar Instâncias**: Crie instâncias do carrinho de compras e dos métodos de pagamento:

```lua
local carrinho = CarrinhoDeCompras:novo()
local cartaoDeCredito = CartaoDeCredito:novo {}
local pix = Pix:novo {}
```
3. **Definir o Método de Pagamento**: Associe um método de pagamento ao carrinho:
```lua
carrinho:definirPagamento(cartaoDeCredito)  -- Ou carrinho:definirPagamento(pix)
```

4. **Finalizar a Compra**: Inicie o processo de finalização da compra com o valor desejado:
```lua
carrinho:finalizarCompra(100)
```

## Observações Adicionais

-   **Simulação**: O processamento de pagamento neste exemplo é simulado. Em uma aplicação real, você integraria gateways de pagamento reais.

-   **Tratamento de Erros**: O código inclui tratamento básico de erros para valores de pagamento inválidos e falhas no processamento do pagamento.

-   **Extensibilidade**: Você pode adicionar facilmente mais métodos de pagamento criando novas classes que implementem a interface `IPagamento`.
