# SQL & PL/SQL Reference (run-sql)

All commands in this file use the `run-sql` MCP tool.

## Queries

```sql
-- Basic select
SELECT * FROM employees WHERE department_id = 10;

-- Aggregation
SELECT department_id, COUNT(*), AVG(salary)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 5
ORDER BY 2 DESC;

-- Joins
SELECT e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Subqueries
SELECT * FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Analytic functions
SELECT employee_name, salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) rnk
FROM employees;

-- FETCH FIRST (12c+)
SELECT * FROM employees ORDER BY salary DESC FETCH FIRST 10 ROWS ONLY;

-- PIVOT
SELECT * FROM (SELECT department_id, job_id, salary FROM employees)
PIVOT (SUM(salary) FOR job_id IN ('CLERK','MANAGER','ANALYST'));

-- WITH clause (CTE)
WITH dept_stats AS (
  SELECT department_id, AVG(salary) avg_sal FROM employees GROUP BY department_id
)
SELECT e.employee_name, e.salary, d.avg_sal
FROM employees e JOIN dept_stats d ON e.department_id = d.department_id;

-- JSON (21c+)
SELECT JSON_SERIALIZE(data PRETTY) FROM json_documents WHERE id = 1;
```

## DML

```sql
-- Insert
INSERT INTO employees (id, name, department_id, salary)
VALUES (100, 'John Smith', 10, 5000);

-- Insert from select
INSERT INTO emp_archive SELECT * FROM employees WHERE status = 'INACTIVE';

-- Update
UPDATE employees SET salary = salary * 1.1 WHERE department_id = 10;

-- Delete
DELETE FROM employees WHERE status = 'INACTIVE';

-- Merge (upsert)
MERGE INTO employees tgt
USING (SELECT 100 id, 'John' name, 5000 salary FROM dual) src
ON (tgt.id = src.id)
WHEN MATCHED THEN UPDATE SET tgt.salary = src.salary
WHEN NOT MATCHED THEN INSERT (id, name, salary) VALUES (src.id, src.name, src.salary);

-- Commit / Rollback
COMMIT;
ROLLBACK;
```

## DDL

```sql
-- Tables
CREATE TABLE app_config (
  config_key   VARCHAR2(100) PRIMARY KEY,
  config_value VARCHAR2(4000),
  created_at   TIMESTAMP DEFAULT SYSTIMESTAMP,
  updated_at   TIMESTAMP
);

ALTER TABLE employees ADD (email VARCHAR2(255));
ALTER TABLE employees MODIFY (name VARCHAR2(200));
ALTER TABLE employees DROP COLUMN middle_name;
ALTER TABLE employees RENAME COLUMN name TO full_name;

DROP TABLE temp_data PURGE;

-- Indexes
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE UNIQUE INDEX idx_emp_email ON employees(email);
DROP INDEX idx_emp_dept;

-- Views
CREATE OR REPLACE VIEW v_active_employees AS
SELECT id, name, department_id, salary
FROM employees WHERE status = 'ACTIVE';

-- Materialized views
CREATE MATERIALIZED VIEW mv_dept_stats
REFRESH ON DEMAND
AS SELECT department_id, COUNT(*) cnt, AVG(salary) avg_sal
FROM employees GROUP BY department_id;

-- Sequences
CREATE SEQUENCE emp_seq START WITH 1000 INCREMENT BY 1 NOCACHE;

-- Synonyms
CREATE OR REPLACE SYNONYM emp FOR hr.employees;

-- Comments
COMMENT ON TABLE employees IS 'Main employee master table';
COMMENT ON COLUMN employees.salary IS 'Annual salary in USD';

-- Grants
GRANT SELECT ON employees TO report_user;
GRANT EXECUTE ON pkg_util TO app_user;
```

## PL/SQL

```sql
-- Anonymous block
BEGIN
  DBMS_OUTPUT.PUT_LINE('Current user: ' || USER);
  FOR r IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    DBMS_OUTPUT.PUT_LINE('  ' || r.table_name);
  END LOOP;
END;

-- Package spec
CREATE OR REPLACE PACKAGE pkg_employees AS
  FUNCTION get_salary(p_id NUMBER) RETURN NUMBER;
  PROCEDURE update_salary(p_id NUMBER, p_new_salary NUMBER);
END pkg_employees;

-- Package body
CREATE OR REPLACE PACKAGE BODY pkg_employees AS
  FUNCTION get_salary(p_id NUMBER) RETURN NUMBER IS
    v_salary NUMBER;
  BEGIN
    SELECT salary INTO v_salary FROM employees WHERE id = p_id;
    RETURN v_salary;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_salary;

  PROCEDURE update_salary(p_id NUMBER, p_new_salary NUMBER) IS
  BEGIN
    UPDATE employees SET salary = p_new_salary, updated_at = SYSTIMESTAMP WHERE id = p_id;
    COMMIT;
  END update_salary;
END pkg_employees;

-- Stored procedure
CREATE OR REPLACE PROCEDURE purge_old_logs(p_days NUMBER DEFAULT 90) AS
  v_count NUMBER;
BEGIN
  DELETE FROM app_log WHERE created_at < SYSDATE - p_days;
  v_count := SQL%ROWCOUNT;  -- capture before COMMIT clears it
  COMMIT;
  DBMS_OUTPUT.PUT_LINE(v_count || ' rows purged');
END;

-- Function
CREATE OR REPLACE FUNCTION is_valid_email(p_email VARCHAR2) RETURN BOOLEAN IS
BEGIN
  RETURN REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
END;

-- Trigger
CREATE OR REPLACE TRIGGER trg_emp_audit
BEFORE UPDATE ON employees FOR EACH ROW
BEGIN
  :NEW.updated_at := SYSTIMESTAMP;
END;

-- Type
CREATE OR REPLACE TYPE t_varchar2_tab AS TABLE OF VARCHAR2(4000);
```

## Useful Dictionary Queries

```sql
-- All user tables
SELECT table_name, num_rows, last_analyzed FROM user_tables ORDER BY table_name;

-- Table columns
SELECT column_name, data_type, data_length, nullable, data_default
FROM user_tab_columns WHERE table_name = 'EMPLOYEES' ORDER BY column_id;

-- Constraints
SELECT constraint_name, constraint_type, search_condition, r_constraint_name
FROM user_constraints WHERE table_name = 'EMPLOYEES';

-- Indexes
SELECT index_name, uniqueness, column_name, column_position
FROM user_ind_columns NATURAL JOIN user_indexes
WHERE table_name = 'EMPLOYEES' ORDER BY index_name, column_position;

-- Invalid objects
SELECT object_name, object_type, status
FROM user_objects WHERE status = 'INVALID' ORDER BY object_type, object_name;

-- Compilation errors
SELECT name, type, line, position, text
FROM user_errors WHERE name = 'PKG_EMPLOYEES' ORDER BY sequence;

-- Dependencies
SELECT name, type, referenced_name, referenced_type
FROM user_dependencies WHERE referenced_name = 'EMPLOYEES';

-- Session info
SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') db, SYS_CONTEXT('USERENV','CURRENT_SCHEMA') schema FROM dual;

-- Privileges
SELECT * FROM session_privs ORDER BY privilege;
SELECT * FROM user_tab_privs WHERE table_name = 'EMPLOYEES';

-- DB version
SELECT banner_full FROM v$version;

-- Space usage
SELECT segment_name, segment_type, bytes/1024/1024 mb
FROM user_segments ORDER BY bytes DESC FETCH FIRST 20 ROWS ONLY;
```

## Recompile Invalid Objects

```sql
BEGIN
  FOR r IN (SELECT object_name, object_type FROM user_objects WHERE status = 'INVALID'
            ORDER BY DECODE(object_type, 'PACKAGE BODY', 1, 'TYPE BODY', 1, 0)) LOOP
    BEGIN
      IF r.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE ' || r.object_name || ' COMPILE BODY';
      ELSIF r.object_type = 'TYPE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER TYPE ' || r.object_name || ' COMPILE BODY';
      ELSE
        EXECUTE IMMEDIATE 'ALTER ' || r.object_type || ' ' || r.object_name || ' COMPILE';
      END IF;
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Failed: ' || r.object_type || ' ' || r.object_name || ' - ' || SQLERRM);
    END;
  END LOOP;
END;
```

**Note:** `ALTER PACKAGE BODY x COMPILE` is invalid syntax -- use `ALTER PACKAGE x COMPILE BODY` instead. Same for TYPE BODY.
