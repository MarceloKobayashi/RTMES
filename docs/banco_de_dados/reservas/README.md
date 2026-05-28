<div align="center">
	<h1>RESERVAS</h1>
</div>

Descrição: registros principais das reservas do sistema RTMES.

---

## 📖 Índice

- [Visão Geral](#-visão-geral)
- [Campos](#-campos)
- [Constraints / Triggers](#-constraints--triggers)
- [Exemplos (queries/rotinas)](#-exemplos-queriesrotinas)
- [Contribuir](#-contribuir)

---

## 🔎 Visão Geral

Armazena todas as reservas feitas no sistema, incluindo dados do solicitante, arquivos anexados e flags de controle para fluxos de aprovação.

## 🧾 Campos

- `id_reserva` — NUMBER — not null — identificador de cada reserva
- `dat_inicio` — TIMESTAMP(6) — not null — data de começo do evento da reserva
- `dat_fim` — TIMESTAMP(6) — not null — data de término do evento da reserva
- `tip_reservas` — VARCHAR2(20) — not null — tipo da reserva (porta-banner, porta-cartaz, adesivagem, mezanino)
- `status` — VARCHAR2(20) — not null — estado da reserva (Em andamento, confirmado, cancelado, realizado)
- `num_participantes` — NUMBER — estimativa de participantes (mezanino)
- `titulo_reserva` — VARCHAR2(400) — not null — nome do evento/campanha
- `des_reserva` — VARCHAR2(4000) — not null — descrição do evento
- `cod_pessoa` — NUMBER — not null — CPF do solicitante
- `pendente` — VARCHAR2(1) — not null — índice para ver se o solicitante confirmou a solicitação dessa reserva
- `loc` — VARCHAR2(4000) — local do evento (válido apenas para os totens)
- `justificativa` — VARCHAR2(4000) — resposta da ASQUALOG quanto à reserva
- `obs` — VARCHAR2(4000) — observação dada pelo solicitante quanto à reserva
- `arq` — BLOB — arquivo com identidade visual, adesivo ou PDF sobre o evento
- `mimetype` — VARCHAR2(200) — extensão/tipo do arquivo (ex: application/pdf)
- `filename` — VARCHAR2(200) — nome do arquivo
- `email_enviado` — VARCHAR2(1) — not null — índice para ver se o e-mail de resposta já foi enviado ao solicitante
- `cod_grupo_reserva` — NUMBER — para agrupar reservas e mostrar numa região dinâmica
- `dat_criacao` — TIMESTAMP(6) — not null — data de criação da reserva
- `ramal` — VARCHAR2(10) — not null — ramal do solicitante para contato
- `ind_patrimonio` — VARCHAR2(1) — not null — índice para ver se o e-mail ao patrimônio já foi solicitado

## ⚙️ Constraints

- `AAA_RESERVAS_PK` - Define a coluna de identificador como primary key.
```sql
CONSTRAINT "AAA_RESERVAS_PK" PRIMARY KEY ("ID_RESERVA") USING INDEX ENABLE
```

- `AAA_RESERVAS_STATUS` - Checa se o valor de status está dentro do esperado.
```sql
CONSTRAINT "AAA_RESERVAS_STATUS" CHECK ("STATUS" IN ('Em andamento', 'Cancelado', 'Confirmado', 'Realizado')) ENABLE
```

- `AAA_RESERVAS_TIPO` - Checa se o valor de tipo está dentro do esperado.
```sql
CONSTRAINT "AAA_RESERVAS_TIPO" CHECK ("TIP_RESERVAS" IN ('Adesivagem', 'Mezanino', 'Porta-Banner', 'Porta-Cartaz')) ENABLE
```

## ⚙️ Triggers

- `TRG_RESERVAS_B_I` - Coloquei uma trigger para fazer verificações antes de inserir no banco de dados. Isso não é uma boa prática, pois acaba concentrando muitas regras de negócio diretamente no banco, dificultando manutenção, rastreabilidade e reutilização da lógica pela aplicação. Por isso me arrependo e indico para não fazerem o mesmo, e colocar as validações na camada de aplicação.
```sql
	CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_RESERVAS_B_I" 
	BEFORE INSERT ON "RESERVAS"      
	FOR EACH ROW    
	DECLARE    
		v_count NUMBER;    
	BEGIN      
		-- Utiliza essa sequencia como valor para a PK
		SELECT SEQ_RESERVAS.NEXTVAL INTO :NEW.ID_RESERVA FROM DUAL;      
		
		-- Regra dos 8 porta-banner por dia   
		IF :NEW.TIP_RESERVAS = 'Porta-Banner' THEN    
			SELECT COUNT(*) INTO v_count    
			FROM RESERVAS    
			WHERE TIP_RESERVAS = 'Porta-Banner'    
				AND STATUS NOT IN ('Cancelado')    
				AND :NEW.DAT_INICIO <= DAT_FIM    
				AND :NEW.DAT_FIM >= DAT_INICIO;    
		
			IF v_count >= 8 THEN    
				RAISE_APPLICATION_ERROR(-20002, 'Número de porta-banners nesse período esgotado. Consulte o calendário acima para visualizar a disponibilidade das datas. Número máximo de porta-banners por dia: 8.');    
			END IF;    
		
			-- Regra do local e dia simultâneos para PB
			SELECT COUNT(*) INTO v_count    
			FROM RESERVAS    
			WHERE TIP_RESERVAS = 'Porta-Banner'    
				AND STATUS NOT IN ('Cancelado')    
				AND :NEW.DAT_INICIO <= DAT_FIM    
				AND :NEW.DAT_FIM >= DAT_INICIO    
				AND TRIM(UPPER(LOC)) = TRIM(UPPER(:NEW.LOC));    
		
			IF v_count > 0 THEN    
				RAISE_APPLICATION_ERROR(-20003, 'Já existe um porta-banner reservado nesse período e local.');    
			END IF;    
		END IF;    
		
		-- Regras para porta-cartaz (iguais aos do banner)    
		IF :NEW.TIP_RESERVAS = 'Porta-Cartaz' THEN    
			SELECT COUNT(*) INTO v_count    
			FROM RESERVAS    
			WHERE TIP_RESERVAS = 'Porta-Cartaz'    
				AND STATUS NOT IN ('Cancelado')    
				AND :NEW.DAT_INICIO <= DAT_FIM    
				AND :NEW.DAT_FIM >= DAT_INICIO;    

			-- Regra dos 4 porta-cartazes
			IF v_count >= 4 THEN    
				RAISE_APPLICATION_ERROR(-20004, 'Número de porta-cartazes nesse período esgotado. Consulte o calendário acima para visualizar a disponibilidade das datas. Número máximo de porta-cartazes por dia: 4.');    
			END IF;    
		
			SELECT COUNT(*) INTO v_count    
			FROM RESERVAS    
			WHERE TIP_RESERVAS = 'Porta-Cartaz'    
				AND STATUS NOT IN ('Cancelado')    
				AND :NEW.DAT_INICIO <= DAT_FIM    
				AND :NEW.DAT_FIM >= DAT_INICIO    
				AND TRIM(UPPER(LOC)) = TRIM(UPPER(:NEW.LOC));    
		
			-- Regra do local e dia simultâneos para PC
			IF v_count > 0 THEN    
				RAISE_APPLICATION_ERROR(-20005, 'Já existe um porta-cartaz reservado nesse período e local.');    
			END IF;    
		END IF;    
		
		-- Regra para adesivagem    
		IF :NEW.TIP_RESERVAS = 'Adesivagem' THEN    
			SELECT COUNT(*) INTO v_count    
			FROM RESERVAS    
			WHERE TIP_RESERVAS = 'Adesivagem'    
				AND STATUS NOT IN ('Cancelado')    
				AND :NEW.DAT_INICIO <= DAT_FIM    
				AND :NEW.DAT_FIM >= DAT_INICIO;    
		
			IF v_count > 0 THEN    
				RAISE_APPLICATION_ERROR(-20006, 'Já existe uma reserva de adesivagem nesse período.');    
			END IF;    
		END IF;    
		
		-- Regra para não reservar no passado    
		IF :NEW.DAT_INICIO < TRUNC(SYSDATE) THEN    
			RAISE_APPLICATION_ERROR(-20007, 'Não é possível fazer uma reserva no passado.');    
		END IF;    
		
		-- Regra para data início sempre ser menor ou igual à data de fim    
		IF :NEW.DAT_INICIO > :NEW.DAT_FIM THEN    
			RAISE_APPLICATION_ERROR(-20008, 'Data de início deve ser anterior ou igual à data de fim.');    
		END IF;    
		
		-- Regra para não poder fazer a reserva com menos de 2 dias úteis    
		IF :NEW.DAT_INICIO >= TRUNC(SYSDATE) AND :NEW.DAT_INICIO <= TRUNC(SYSDATE) + 1 THEN    
			RAISE_APPLICATION_ERROR(-20009, 'Data de início deve ter um prazo de pelo menos 2 dias.');    
		END IF; 
	
		IF :NEW.TIP_RESERVAS LIKE 'Porta-%' THEN 
			IF :NEW.LOC IS NULL OR TRIM(:NEW.LOC) = '' THEN 
				RAISE_APPLICATION_ERROR(-20010, 'Por favor, selecione um local para a reserva.'); 
			END IF; 
		END IF; 
	
		-- Verificação: datas obrigatórias 
		IF :NEW.DAT_INICIO IS NULL OR :NEW.DAT_FIM IS NULL THEN 
			RAISE_APPLICATION_ERROR(-20011, 'As datas de início e fim devem ser informadas.'); 
		END IF;    
	END;
```

## 🧪 Exemplos (queries/rotinas)

- Exemplo: buscar reservas confirmadas no mês atual

```sql
SELECT * FROM reservas WHERE status = 'confirmado' AND dat_inicio >= TRUNC(SYSDATE, 'MM');
```

---

Voltar para: [Visão geral do BD](../README.md)
