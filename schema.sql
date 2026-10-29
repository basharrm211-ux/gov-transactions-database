-- ==========================================================
-- gov_transactions : نظام معاملات حكومية
-- ==========================================================

CREATE DATABASE gov_transactions
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE gov_transactions;

CREATE TABLE departments (
  department_id   INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(100) NOT NULL UNIQUE,
  parent_id       INT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_dept_parent FOREIGN KEY (parent_id)
    REFERENCES departments(department_id)
);

CREATE TABLE employees (
  employee_id     INT AUTO_INCREMENT PRIMARY KEY,
  department_id   INT NOT NULL,
  manager_id      INT NULL,
  full_name       VARCHAR(120) NOT NULL,
  job_title       VARCHAR(80)  NOT NULL,
  email           VARCHAR(120) NOT NULL UNIQUE,
  hire_date       DATE NOT NULL,
  salary          DECIMAL(10,2) NOT NULL CHECK (salary > 0),
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_emp_dept    FOREIGN KEY (department_id) REFERENCES departments(department_id),
  CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id)    REFERENCES employees(employee_id)
);


CREATE TABLE citizens (
  citizen_id      INT AUTO_INCREMENT PRIMARY KEY,
  national_no     CHAR(10) NOT NULL UNIQUE,
  full_name       VARCHAR(120) NOT NULL,
  birth_date      DATE NOT NULL,
  phone           VARCHAR(20),
  city            VARCHAR(60),
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE transaction_types (
  type_id         INT AUTO_INCREMENT PRIMARY KEY,
  department_id   INT NOT NULL,
  name            VARCHAR(120) NOT NULL,
  fee             DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK (fee >= 0),
  sla_days        SMALLINT NOT NULL CHECK (sla_days > 0),
  UNIQUE (department_id, name),
  CONSTRAINT fk_type_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


CREATE TABLE statuses (
  status_id       TINYINT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(30) NOT NULL UNIQUE,   
  is_final        BOOLEAN NOT NULL DEFAULT FALSE
);


CREATE TABLE transactions (
  transaction_id  INT AUTO_INCREMENT PRIMARY KEY,
  citizen_id      INT NOT NULL,
  type_id         INT NOT NULL,
  status_id       TINYINT NOT NULL,
  assigned_to     INT NULL,                      ا
  submitted_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at    DATETIME NULL,
  CHECK (completed_at IS NULL OR completed_at >= submitted_at),
  CONSTRAINT fk_tr_citizen  FOREIGN KEY (citizen_id)  REFERENCES citizens(citizen_id),
  CONSTRAINT fk_tr_type     FOREIGN KEY (type_id)     REFERENCES transaction_types(type_id),
  CONSTRAINT fk_tr_status   FOREIGN KEY (status_id)   REFERENCES statuses(status_id),
  CONSTRAINT fk_tr_employee FOREIGN KEY (assigned_to) REFERENCES employees(employee_id)
);

CREATE TABLE transaction_history (
  history_id      BIGINT AUTO_INCREMENT PRIMARY KEY,
  transaction_id  INT NOT NULL,
  from_status_id  TINYINT NULL,
  to_status_id    TINYINT NOT NULL,
  changed_by      INT NOT NULL,
  changed_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes           VARCHAR(255),
  CONSTRAINT fk_h_tr     FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
  CONSTRAINT fk_h_from   FOREIGN KEY (from_status_id) REFERENCES statuses(status_id),
  CONSTRAINT fk_h_to     FOREIGN KEY (to_status_id)   REFERENCES statuses(status_id),
  CONSTRAINT fk_h_emp    FOREIGN KEY (changed_by)     REFERENCES employees(employee_id)
);


CREATE TABLE payments (
  payment_id      INT AUTO_INCREMENT PRIMARY KEY,
  transaction_id  INT NOT NULL,
  amount          DECIMAL(8,2) NOT NULL CHECK (amount > 0),
  method          ENUM('cash','card','online') NOT NULL,
  paid_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_pay_tr FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);


CREATE TABLE documents (
  document_id     INT AUTO_INCREMENT PRIMARY KEY,
  transaction_id  INT NOT NULL,
  doc_name        VARCHAR(120) NOT NULL,
  file_path       VARCHAR(255) NOT NULL,
  uploaded_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_doc_tr FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
);

