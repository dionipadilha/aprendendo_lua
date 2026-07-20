# Para instalar Lua no Windows 10, siga estas etapas:

1. **Download do Arquivo**:
   - Acesse o site oficial do Lua ou uma fonte confiável e faça o download do arquivo `lua-x.x.x_Win64_bin.zip`. Substitua `x.x.x` pela versão mais recente disponível.

2. **Descompacte o Arquivo**:
   - Após o download, clique com o botão direito no arquivo `.zip` e escolha a opção para descompactar ou extrair os arquivos. Você pode usar ferramentas como WinRAR ou 7-Zip.

3. **Mova a Pasta Descompactada**:
   - Recorte a pasta resultante da descompactação e cole-a em `C:\Arquivos de Programas\`. Esta ação pode exigir permissões de administrador.

4. **Renomeie o Arquivo Executável**:
   - Entre na pasta que você acabou de mover. Localize o arquivo executável (por exemplo, `lua54.exe`) e renomeie-o para `lua.exe`. Isso facilitará a execução do Lua a partir da linha de comando.

5. **Copie o Caminho da Pasta**:
   - Copie o caminho completo da pasta onde o Lua está instalado. Deve ser algo como `C:\Program Files\lua-x.x.x_Win64_bin`.

6. **Edite as Variáveis de Ambiente**:
   - No menu Iniciar, digite “Editar as variáveis de ambiente do sistema” e abra a opção correspondente.
   - Na janela do Sistema, clique em “Variáveis de Ambiente”.

7. **Atualize o Path**:
   - Na seção Variáveis de Sistema, encontre e selecione a variável `Path`. Clique em “Editar”.
   - Na janela de edição, clique em “Novo” e cole o caminho da pasta do Lua que você copiou anteriormente.
   - Clique em “OK” para fechar as janelas de edição.

8. **Teste a Instalação**:
   - Abra o Prompt de Comando (cmd).
   - Digite `lua` e pressione Enter.
   - Se a instalação foi bem-sucedida, você deverá ver o prompt do Lua, algo como `>`.

Lembre-se de substituir `x.x.x` pela versão específica do Lua que você baixou.
