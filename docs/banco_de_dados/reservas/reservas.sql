
  CREATE TABLE "RESERVAS" 
   (	"ID_RESERVA" NUMBER NOT NULL ENABLE, 
	"DAT_INICIO" TIMESTAMP (6) NOT NULL ENABLE, 
	"DAT_FIM" TIMESTAMP (6) NOT NULL ENABLE, 
	"TIP_RESERVAS" VARCHAR2(20 CHAR) NOT NULL ENABLE, 
	"STATUS" VARCHAR2(20 CHAR) DEFAULT 'Em andamento' NOT NULL ENABLE, 
	"NUM_PARTICIPANTES" NUMBER, 
	"TITULO_RESERVA" VARCHAR2(400 CHAR) NOT NULL ENABLE, 
	"DES_RESERVA" VARCHAR2(4000 CHAR) NOT NULL ENABLE, 
	"COD_PESSOA" NUMBER NOT NULL ENABLE, 
	"PENDENTE" VARCHAR2(1 CHAR) NOT NULL ENABLE, 
	"LOC" VARCHAR2(4000), 
	"JUSTIFICATIVA" VARCHAR2(4000), 
	"OBS" VARCHAR2(4000), 
	"ARQ" BLOB, 
	"MIMETYPE" VARCHAR2(200), 
	"FILENAME" VARCHAR2(200), 
	"EMAIL_ENVIADO" VARCHAR2(1) NOT NULL ENABLE, 
	"COD_GRUPO_RESERVA" NUMBER, 
	"DAT_CRIACAO" TIMESTAMP (6) NOT NULL ENABLE, 
	"OBS_ASQUALOG" VARCHAR2(4000), 
	"RAMAL" VARCHAR2(10) NOT NULL ENABLE, 
	"IND_PATRIMONIO" VARCHAR2(1) NOT NULL ENABLE, 
	 CONSTRAINT "AAA_RESERVAS_TIPO" CHECK ( "TIP_RESERVAS" IN ('Adesivagem', 'Mezanino', 'Porta-Banner', 'Porta-Cartaz') ) ENABLE, 
	 CONSTRAINT "AAA_RESERVAS_STATUS" CHECK ( "STATUS" IN ('Em Andamento', 'Cancelado', 'Confirmado', 'Realizado') ) ENABLE, 
	 CONSTRAINT "AAA_RESERVAS_PK" PRIMARY KEY ("ID_RESERVA")
  USING INDEX  ENABLE
   ) ;

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_RESERVAS_B_I" 
BEFORE INSERT ON "RESERVAS"      
FOR EACH ROW    
DECLARE    
    v_count NUMBER;    
BEGIN      
    SELECT SEQ_RESERVAS.NEXTVAL INTO :NEW.ID_RESERVA FROM DUAL;      
    
    -- Regra dos 8 porta-banner    
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
    
        -- Regra do local e dia    
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
 
    -- ¿ Verificação: datas obrigatórias 
    IF :NEW.DAT_INICIO IS NULL OR :NEW.DAT_FIM IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20011, 'As datas de início e fim devem ser informadas.'); 
    END IF;    
END;