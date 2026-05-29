BEGIN
    -- Busca o nome formatado e atribui ao item da página
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