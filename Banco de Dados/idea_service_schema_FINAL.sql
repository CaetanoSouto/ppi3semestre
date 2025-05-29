
-- Criação do banco de dados IDEA SERVICE
CREATE DATABASE IF NOT EXISTS idea_service_db;
USE idea_service_db;

-- Tabela de níveis de acesso
CREATE TABLE IF NOT EXISTS niveis_acesso (
    id_nivel INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    `descricao` TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    id_nivel INT NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso TIMESTAMP NULL,
    ativo BOOLEAN DEFAULT TRUE,
    token_recuperacao VARCHAR(100) NULL,
    token_expiracao TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_nivel) REFERENCES niveis_acesso(id_nivel)
);

-- Tabela de endereços
CREATE TABLE IF NOT EXISTS enderecos (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabela de categorias de serviços
CREATE TABLE IF NOT EXISTS categorias_servicos (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ``descricao`` TEXT,
    icone VARCHAR(50),
    ``ordem`` INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de serviços
CREATE TABLE IF NOT EXISTS servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    ``descricao`` TEXT NOT NULL,
    preco_base DECIMAL(10,2) NOT NULL,
    tempo_estimado INT NOT NULL,
    icone VARCHAR(50),
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categorias_servicos(id_categoria)
);

-- Tabela de pacotes de serviços
CREATE TABLE IF NOT EXISTS pacotes (
    id_pacote INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ``descricao`` TEXT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de relacionamento entre pacotes e serviços
CREATE TABLE IF NOT EXISTS pacotes_servicos (
    id_pacote INT NOT NULL,
    id_servico INT NOT NULL,
    quantidade INT DEFAULT 1,
    desconto DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_pacote, id_servico),
    FOREIGN KEY (id_pacote) REFERENCES pacotes(id_pacote),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico)
);

-- Tabela de status de orçamentos
CREATE TABLE IF NOT EXISTS status_orcamentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ``descricao`` TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de orçamentos
CREATE TABLE IF NOT EXISTS orcamentos (
    id_orcamento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_endereco INT NOT NULL,
    id_status INT NOT NULL,
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_validade DATE NOT NULL,
    observacoes TEXT,
    valor_total DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    valor_final DECIMAL(10,2) NOT NULL,
    motivo_recusa TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_endereco) REFERENCES enderecos(id_endereco),
    FOREIGN KEY (id_status) REFERENCES status_orcamentos(id_status)
);



-- Tabela de itens do orçamento
CREATE TABLE IF NOT EXISTS itens_orcamento (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento INT NOT NULL,
    id_servico INT NULL,
    id_pacote INT NULL,
    `descricao` VARCHAR(255) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_orcamento) REFERENCES orcamentos(id_orcamento),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico),
    FOREIGN KEY (id_pacote) REFERENCES pacotes(id_pacote),
    -- CHECK removido para compatibilidade
);

-- Tabela de status de agendamentos
CREATE TABLE IF NOT EXISTS status_agendamentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ``descricao`` TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de agendamentos
CREATE TABLE IF NOT EXISTS agendamentos (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento INT NOT NULL,
    id_status INT NOT NULL,
    data_agendamento DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_orcamento) REFERENCES orcamentos(id_orcamento),
    FOREIGN KEY (id_status) REFERENCES status_agendamentos(id_status)
);

-- Tabela de técnicos designados para agendamentos
CREATE TABLE IF NOT EXISTS tecnicos_agendamento (
    id_agendamento INT NOT NULL,
    id_usuario INT NOT NULL,
    principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_agendamento, id_usuario),
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabela de status de atendimentos
CREATE TABLE IF NOT EXISTS status_atendimentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    ``descricao`` TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de atendimentos
CREATE TABLE IF NOT EXISTS atendimentos (
    id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NOT NULL,
    id_status INT NOT NULL,
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NULL,
    relatorio_tecnico TEXT,
    observacoes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento),
    FOREIGN KEY (id_status) REFERENCES status_atendimentos(id_status)
);

-- Tabela de depoimentos
CREATE TABLE IF NOT EXISTS depoimentos (
    id_depoimento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_atendimento INT NOT NULL,
    titulo VARCHAR(100),
    texto TEXT NOT NULL,
    avaliacao INT NOT NULL CHECK (avaliacao BETWEEN 1 AND 5),
    aprovado BOOLEAN DEFAULT FALSE,
    data_aprovacao TIMESTAMP NULL,
    destaque BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_atendimento) REFERENCES atendimentos(id_atendimento)
);

-- Tabela de conteúdo do site
CREATE TABLE IF NOT EXISTS conteudo_site (
    id_conteudo INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    conteudo TEXT NOT NULL,
    ``ordem`` INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de contatos/mensagens
CREATE TABLE IF NOT EXISTS contatos (
    id_contato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    assunto VARCHAR(100) NOT NULL,
    mensagem TEXT NOT NULL,
    lido BOOLEAN DEFAULT FALSE,
    data_leitura TIMESTAMP NULL,
    respondido BOOLEAN DEFAULT FALSE,
    data_resposta TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de logs do sistema
CREATE TABLE IF NOT EXISTS logs_sistema (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NULL,
    acao VARCHAR(50) NOT NULL,
    tabela VARCHAR(50) NOT NULL,
    id_registro INT NULL,
    dados_antigos TEXT NULL,
    dados_novos TEXT NULL,
    ip VARCHAR(45) NOT NULL,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Conteúdo inicial do site
INSERT INTO conteudo_site (tipo, titulo, conteudo, ``ordem``) VALUES 
('faq', 'Como solicitar um orçamento?', 'Para solicitar um orçamento, basta clicar no botão "Solicitar Orçamento" na página inicial ou entrar em contato pelo WhatsApp.', 1),
('faq', 'Qual o prazo de instalação?', 'O prazo de instalação varia conforme o serviço contratado, mas geralmente é entre 2 a 5 dias úteis.', 2);
