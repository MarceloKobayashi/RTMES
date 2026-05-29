<div align="center">

<p align="center">
	<h1>1. Lógica do Aplicativo</h1>
</p>

</div>

---

## 🎯 Visão Geral

Esta seção documenta a lógica de aplicação usada para preparar informações globais em tempo de execução no Oracle APEX. No RTMES, a principal responsabilidade dessa lógica é identificar o usuário autenticado, buscar seus dados no banco e disponibilizar o nome formatado para uso no cabeçalho e em outras partes da interface.

## 🧩 Componente implementado

Atualmente a lógica do aplicativo utiliza dois elementos principais:

- Item de aplicativo `NOME_USUARIO`.
- Processo de aplicativo `Carregar_nome_usuario`.

O processo executa um bloco PL/SQL antes do carregamento do cabeçalho da página, preenchendo o item `NOME_USUARIO` com o nome formatado do usuário autenticado.

## 🔄 Fluxo de execução

O funcionamento segue esta sequência:

1. O usuário acessa a aplicação e autentica-se via Senado Federal.
2. Antes da renderização da página, o processo `Carregar_nome_usuario` é executado.
3. O processo consulta o vínculo do usuário com base em `:APP_USER`.
4. O nome retornado é tratado para remover acentuação e padronizar a exibição.
5. O valor final é atribuído ao item de aplicação `:NOME_USUARIO`.
6. Caso não exista registro correspondente, uma mensagem de fallback é exibida.

Esse comportamento permite exibir o nome do usuário no cabeçalho ou em outras áreas da aplicação sem repetir a consulta em cada página.

## 🧾 Código PL/SQL

```plsql
BEGIN
    -- Busca o nome formatado e atribui ao item da aplicação
    SELECT UPPER(
               SUBSTR(
                 TRANSLATE(v.nom_pessoa,
                   'ÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇáàâãäéèêëíìîïóòôõöúùûüç',
                   'AAAAAEEEEIIIIOOOOOUUUUCaaaaaeeeeiiiiooooouuuuc'),
                 1,
                 INSTR(v.nom_pessoa, ' ') - 1
               )
           ) || ' (' || v.num_cpf || ')'
      INTO :NOME_USUARIO
      FROM dda.vinculo_sf v
      JOIN dda.usuario_rede u ON u.num_cpf_pessoa = v.num_cpf
      WHERE :APP_USER = u.txt_login_ad
        AND u.nom_situacao_login_ad = 'ATIVO'
        AND ROWNUM = 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        :NOME_USUARIO := 'USUÁRIO NÃO ENCONTRADO';
    WHEN OTHERS THEN
        :NOME_USUARIO := 'ERRO: ' || SQLERRM;
END;
```
