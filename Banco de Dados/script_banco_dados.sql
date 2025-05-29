```sql
-- Criação do banco de dados IDEA SERVICE
CREATE DATABASE idea_service_db;
USE idea_service_db;

-- Tabela de níveis de acesso
CREATE TABLE niveis_acesso (
    id_nivel INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de usuários
CREATE TABLE usuarios (
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
CREATE TABLE enderecos (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(20) NOT NULL, -- residencial, comercial, etc.
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
CREATE TABLE categorias_servicos (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    icone VARCHAR(50),
    ordem INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de serviços
CREATE TABLE servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    preco_base DECIMAL(10,2) NOT NULL,
    tempo_estimado INT NOT NULL, -- em minutos
    icone VARCHAR(50),
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_categoria) REFERENCES categorias_servicos(id_categoria)
);

-- Tabela de pacotes de serviços
CREATE TABLE pacotes (
    id_pacote INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de relacionamento entre pacotes e serviços
CREATE TABLE pacotes_servicos (
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
CREATE TABLE status_orcamentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de orçamentos
CREATE TABLE orcamentos (
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
CREATE TABLE itens_orcamento (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento INT NOT NULL,
    id_servico INT NULL,
    id_pacote INT NULL,
    descricao VARCHAR(255) NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    valor_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_orcamento) REFERENCES orcamentos(id_orcamento),
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico),
    FOREIGN KEY (id_pacote) REFERENCES pacotes(id_pacote),
    CHECK (id_servico IS NOT NULL OR id_pacote IS NOT NULL)
);

-- Tabela de status de agendamentos
CREATE TABLE status_agendamentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de agendamentos
CREATE TABLE agendamentos (
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
CREATE TABLE tecnicos_agendamento (
    id_agendamento INT NOT NULL,
    id_usuario INT NOT NULL, -- técnico
    principal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_agendamento, id_usuario),
    FOREIGN KEY (id_agendamento) REFERENCES agendamentos(id_agendamento),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabela de status de atendimentos
CREATE TABLE status_atendimentos (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    cor VARCHAR(7) DEFAULT '#000000',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de atendimentos
CREATE TABLE atendimentos (
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
CREATE TABLE depoimentos (
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
CREATE TABLE conteudo_site (
    id_conteudo INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL, -- faq, termo, política, etc.
    titulo VARCHAR(100) NOT NULL,
    conteudo TEXT NOT NULL,
    ordem INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de contatos/mensagens
CREATE TABLE contatos (
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
CREATE TABLE logs_sistema (
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

-- Inserção de dados iniciais

-- Níveis de acesso
INSERT INTO niveis_acesso (nome, descricao) VALUES 
('Cliente', 'Usuário final que contrata serviços'),
('Técnico', 'Funcionário que realiza os serviços'),
('Administrador', 'Gerencia o sistema e usuários'),
('Super Admin', 'Acesso total ao sistema');

-- Status de orçamentos
INSERT INTO status_orcamentos (nome, descricao, cor) VALUES 
('Pendente', 'Orçamento aguardando análise', '#FFA500'),
('Em análise', 'Orçamento sendo analisado pela equipe', '#3498DB'),
('Aprovado', 'Orçamento aprovado pelo cliente', '#27AE60'),
('Recusado', 'Orçamento recusado pelo cliente', '#E74C3C'),
('Expirado', 'Orçamento com prazo de validade vencido', '#95A5A6');

-- Status de agendamentos
INSERT INTO status_agendamentos (nome, descricao, cor) VALUES 
('Agendado', 'Visita agendada', '#3498DB'),
('Confirmado', 'Agendamento confirmado', '#27AE60'),
('Em andamento', 'Serviço em execução', '#F39C12'),
('Concluído', 'Serviço finalizado', '#2ECC71'),
('Cancelado', 'Agendamento cancelado', '#E74C3C'),
('Reagendado', 'Visita remarcada', '#9B59B6');

-- Status de atendimentos
INSERT INTO status_atendimentos (nome, descricao, cor) VALUES 
('Iniciado', 'Atendimento em andamento', '#F39C12'),
('Pausado', 'Atendimento temporariamente interrompido', '#E67E22'),
('Concluído', 'Atendimento finalizado com sucesso', '#2ECC71'),
('Pendente', 'Atendimento com pendências', '#3498DB'),
('Cancelado', 'Atendimento cancelado', '#E74C3C');

-- Categorias de serviços
INSERT INTO categorias_servicos (nome, descricao, icone, ordem) VALUES 
('Monitoramento', 'Serviços de monitoramento 24h', 'fa-video', 1),
('Alarmes', 'Sistemas de alarme e segurança', 'fa-bell', 2),
('Instalações Elétricas', 'Serviços de instalação e manutenção elétrica', 'fa-bolt', 3),
('Automação', 'Soluções de automação residencial e comercial', 'fa-cogs', 4);

-- Serviços de Monitoramento
INSERT INTO servicos (id_categoria, nome, descricao, preco_base, tempo_estimado, icone, destaque) VALUES 
(1, 'Instalação de Câmeras', 'Instalação de câmeras de segurança com monitoramento', 250.00, 120, 'fa-video', TRUE),
(1, 'Monitoramento Básico', 'Serviço de monitoramento básico 24h', 99.90, 0, 'fa-eye', FALSE),
(1, 'Monitoramento Avançado', 'Serviço de monitoramento avançado com alertas', 199.90, 0, 'fa-shield-alt', TRUE),
(1, 'Manutenção de Câmeras', 'Serviço de manutenção preventiva de câmeras', 150.00, 90, 'fa-tools', FALSE);

-- Serviços de Alarmes
INSERT INTO servicos (id_categoria, nome, descricao, preco_base, tempo_estimado, icone, destaque) VALUES 
(2, 'Instalação de Alarme Residencial', 'Instalação de sistema de alarme para residências', 350.00, 180, 'fa-home', TRUE),
(2, 'Instalação de Alarme Comercial', 'Instalação de sistema de alarme para empresas', 550.00, 240, 'fa-store', FALSE),
(2, 'Manutenção de Alarmes', 'Serviço de manutenção preventiva de alarmes', 180.00, 120, 'fa-tools', FALSE),
(2, 'Monitoramento de Alarmes', 'Serviço de monitoramento de alarmes 24h', 89.90, 0, 'fa-bell', TRUE);

-- Serviços de Instalações Elétricas
INSERT INTO servicos (id_categoria, nome, descricao, preco_base, tempo_estimado, icone, destaque) VALUES 
(3, 'Instalação Elétrica Residencial', 'Serviço completo de instalação elétrica para residências', 800.00, 480, 'fa-plug', TRUE),
(3, 'Instalação Elétrica Comercial', 'Serviço completo de instalação elétrica para empresas', 1200.00, 720, 'fa-building', FALSE),
(3, 'Manutenção Elétrica', 'Serviço de manutenção preventiva e corretiva', 250.00, 180, 'fa-tools', TRUE),
(3, 'Instalação de Quadros de Distribuição', 'Instalação de quadros elétricos', 450.00, 240, 'fa-th-large', FALSE);

-- Serviços de Automação
INSERT INTO servicos (id_categoria, nome, descricao, preco_base, tempo_estimado, icone, destaque) VALUES 
(4, 'Automação Residencial Básica', 'Controle de iluminação e dispositivos básicos', 1500.00, 360, 'fa-lightbulb', TRUE),
(4, 'Automação Residencial Completa', 'Sistema completo de automação para residências', 3500.00, 720, 'fa-home', TRUE),
(4, 'Automação Comercial', 'Soluções de automação para empresas', 4500.00, 960, 'fa-building', FALSE),
(4, 'Integração com Assistentes de Voz', 'Integração de sistemas com Alexa, Google Assistant, etc.', 800.00, 240, 'fa-microphone', FALSE);

-- Pacotes
INSERT INTO pacotes (nome, descricao, preco, destaque) VALUES 
('Monitoramento Básico', 'Pacote básico de monitoramento com 2 câmeras HD', 899.90, FALSE),
('Monitoramento Avançado', 'Pacote avançado com 4 câmeras Full HD e monitoramento 24h', 1799.90, TRUE),
('Monitoramento Premium', 'Pacote premium com 8 câmeras 4K e resposta rápida', 2999.90, FALSE),
('Alarme Residencial', 'Sistema de alarme completo para residências', 899.90, TRUE),
('Alarme Comercial', 'Sistema de alarme avançado para empresas', 1799.90, FALSE),
('Casa Inteligente Básica', 'Automação básica para residências', 2999.90, TRUE),
('Casa Inteligente Premium', 'Automação completa com integração total', 5999.90, FALSE);

-- Relacionamento entre pacotes e serviços
INSERT INTO pacotes_servicos (id_pacote, id_servico, quantidade, desconto) VALUES 
(1, 1, 1, 10.00), -- Instalação de Câmeras no pacote Monitoramento Básico
(1, 2, 12, 15.00), -- 12 meses de Monitoramento Básico
(2, 1, 1, 15.00), -- Instalação de Câmeras no pacote Monitoramento Avançado
(2, 3, 12, 20.00), -- 12 meses de Monitoramento Avançado
(3, 1, 1, 20.00), -- Instalação de Câmeras no pacote Monitoramento Premium
(3, 3, 12, 25.00), -- 12 meses de Monitoramento Avançado
(4, 5, 1, 10.00), -- Instalação de Alarme Residencial no pacote Alarme Residencial
(4, 8, 12, 15.00), -- 12 meses de Monitoramento de Alarmes
(5, 6, 1, 15.00), -- Instalação de Alarme Comercial no pacote Alarme Comercial
(5, 8, 12, 20.00), -- 12 meses de Monitoramento de Alarmes
(6, 13, 1, 10.00), -- Automação Residencial Básica no pacote Casa Inteligente Básica
(7, 14, 1, 15.00); -- Automação Residencial Completa no pacote Casa Inteligente Premium

-- Conteúdo do site
INSERT INTO conteudo_site (tipo, titulo, conteudo, ordem) VALUES 
('faq', 'Como solicitar um orçamento?', 'Para solicitar um orçamento, basta clicar no botão "Solicitar Orçamento" na página inicial ou entrar em contato pelo WhatsApp.', 1),
('faq', 'Qual o prazo de instalação?', 'O prazo de instalação varia conforme o serviço contratado, mas
(Content truncated due to size limit. Use line ranges to read in chunks)