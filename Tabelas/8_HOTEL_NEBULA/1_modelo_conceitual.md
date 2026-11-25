# Modelo Conceitual e Lógico - Hotel Nebula

Este documento descreve as entidades, atributos e relacionamentos do sistema de gestão do Hotel Nebula, resolvendo o caos de informações dispersas e preparando o terreno para a futura API.

## 📌 Entidades e Atributos

As entidades principais identificadas para o funcionamento do hotel são:

*   **hospedes:** Armazena os dados dos clientes (nome, e-mail, CPF, telefone).
*   **quartos:** Guarda as informações físicas dos quartos (número, tipo, capacidade, preço, status).
*   **reservas:** Liga um hóspede a um quarto em um período específico (check-in e check-out previstos).
*   **hospedagens:** Representa a estadia real (quando o hóspede faz o check-in e checkout de fato).
*   **pagamentos:** Registra os valores pagos referentes a cada hospedagem.
*   **funcionarios:** Profissionais do hotel (nome, cargo, turno).
*   **servicos:** Catálogo de serviços extras oferecidos (ex: frigobar, lavanderia, spa).
*   **feedbacks:** Avaliações e comentários dados pelos clientes após a hospedagem.

## 🔗 Relacionamentos (Regras de Negócio)

Para garantir a integridade dos dados, foram definidos os seguintes relacionamentos:

*   Um **Hóspede** pode fazer várias **Reservas** (1:N).
*   Um **Quarto** pode receber várias **Reservas** ao longo do tempo (1:N).
*   Uma **Reserva** gera exatamente uma **Hospedagem** (1:1).
*   Uma **Hospedagem** pode ter vários **Pagamentos** (1:N).
*   Uma **Hospedagem** gera exatamente um **Feedback** (1:1).
*   **Tabelas de Associação (N:N):**
    *   `hospedagem_servicos`: Uma hospedagem pode consumir vários serviços e um serviço pode estar em várias hospedagens. Registra a quantidade consumida.
    *   `funcionario_hospedagem`: Um funcionário pode atender várias hospedagens e uma hospedagem pode ter vários funcionários.

## 📊 Diagrama Entidade-Relacionamento (ER)

Abaixo está o diagrama visual gerado a partir das regras acima:

```mermaid
erDiagram
    HOSPEDES ||--o{ RESERVAS : "faz"
    QUARTOS ||--o{ RESERVAS : "recebe"
    RESERVAS ||--|| HOSPEDAGENS : "gera"
    HOSPEDAGENS ||--o{ PAGAMENTOS : "possui"
    HOSPEDAGENS ||--|| FEEDBACKS : "avalia"
    
    HOSPEDAGENS ||--o{ HOSPEDAGEM_SERVICOS : "consome"
    SERVICOS ||--o{ HOSPEDAGEM_SERVICOS : "é consumido"
    
    HOSPEDAGENS ||--o{ FUNCIONARIO_HOSPEDAGEM : "atendida por"
    FUNCIONARIOS ||--o{ FUNCIONARIO_HOSPEDAGEM : "atende"

    HOSPEDES {
        int id_hospede PK
        string nome
        string email
        string cpf
        string telefone
    }
    
    QUARTOS {
        int id_quarto PK
        string numero
        string tipo
        decimal preco_diaria
        string status
    }
    
    RESERVAS {
        int id_reserva PK
        int id_hospede FK
        int id_quarto FK
        date data_checkin
        date data_checkout
        string status
    }
    
    HOSPEDAGENS {
        int id_hospedagem PK
        int id_reserva FK
        datetime checkin_real
        datetime checkout_real
    }