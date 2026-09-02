-- DB01 — Banco do LG01
-- Compatível com MySQL 8+ e MariaDB 10.5+

-- ============================================================
-- LIGAÇÃO LG01 ↔ BACKEND ↔ DB01
-- ============================================================
-- NÃO conecte login.html diretamente a este arquivo .sql.
-- O fluxo correto é:
--
--   LG01 (login.html)
--        ↓ HTTP/JSON
--   BACKEND / API
--        ↓ conexão MySQL/MariaDB
--   DB01 (banco catalogo_login_lg01 / tabela usuarios)
--
-- No código do LG01, edite exatamente estas duas linhas:
--   const ENDPOINT_LOGIN = '/api/login';
--   const ENDPOINT_CADASTRO = '/api/cadastro';
--
-- O backend dessas rotas deve conectar neste banco:
--   BANCO:  catalogo_login_lg01
--   TABELA: usuarios
--
-- Contrato recebido do LG01:
--   POST /api/cadastro
--   { nome, email, senha, confirmarSenha }
--
--   POST /api/login
--   { email, senha }
--
-- IMPORTANTE:
-- - confirmarSenha serve apenas para validação e NÃO é armazenada.
-- - senha chega ao backend como texto de entrada, mas NÃO deve ser salva.
-- - o backend deve gerar um hash seguro e gravá-lo em senha_hash.
-- - use consultas parametrizadas/prepared statements no backend.
-- ============================================================

CREATE DATABASE IF NOT EXISTS catalogo_login_lg01
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE catalogo_login_lg01;

CREATE TABLE IF NOT EXISTS usuarios (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT pk_usuarios PRIMARY KEY (id),
  CONSTRAINT uq_usuarios_email UNIQUE (email)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- CONSULTAS QUE O BACKEND DO LG01 DEVE USAR
-- Os sinais ? representam parâmetros enviados pelo backend.
-- ============================================================

-- CADASTRO
-- LG01.nome  -> usuarios.nome
-- LG01.email -> usuarios.email
-- LG01.senha -> backend gera hash -> usuarios.senha_hash
INSERT INTO usuarios (nome, email, senha_hash)
VALUES (?, ?, ?);

-- LOGIN
-- LG01.email localiza o usuário.
-- Depois o backend compara LG01.senha com usuarios.senha_hash.
SELECT id, nome, email, senha_hash
FROM usuarios
WHERE email = ?
LIMIT 1;
