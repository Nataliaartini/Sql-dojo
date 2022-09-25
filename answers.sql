-- CREATE TABLE empregados (
--  emp_id int NOT NULL,
--  dep_id int DEFAULT NULL,
--  supervisor_id int DEFAULT NULL,
--  nome varchar(255) DEFAULT NULL,
--  salario int DEFAULT NULL,
--  PRIMARY KEY (emp_id)
-- );

-- CREATE TABLE departamentos (
--  dep_id int NOT NULL ,
--  nome varchar(255) DEFAULT NULL,
--  PRIMARY KEY (dep_id)
-- );


-- INSERT INTO empregados (emp_id, dep_id, supervisor_id, nome, salario)
-- VALUES
--  (1,1,0,'Jose','8000'),
-- 	(2,3,5,'Joao','6000'),
-- 	(3,1,1,'Guilherme','5000'),
-- 	(4,1,1,'Maria','9500'),
-- 	(5,2,0,'Pedro','7500'),
--     (6,1,1,'Claudia','10000'),
--     (7,4,1,'Ana','12200'),
--     (8,2,5,'Luiz','8000');

-- INSERT INTO departamentos (dep_id, nome)
-- VALUES
-- 	(1,'TI'),
-- 	(2,'RH'),
-- 	(3,'Vendas'),
-- 	(4,'Marketing');

--1 Listar os empregados (nomes) que tem salário maior que seu chefe
SELECT emp.nome as empregado, chefe.nome as chefe, emp.salario as emp_sal, chefe.salario as chefe_sal
    from empregados emp join empregados chefe on emp.supervisor_id = chefe.emp_id
        where emp.salario > chefe.salario

--2 Listar o maior salario de cada departamento (pode ser usado o group by)
SELECT dep_id, max(salario) from empregados group by dep_id

--3 Listar o nome do funcionario com maior salario dentro de cada departamento (pode ser usado o IN)
select emp.nome as funcionario, emp.salario as salario
    from empregados emp
        join (
            select dep_id, max(salario) as salario
            from empregados
            group by dep_id
        ) as sub on sub.salario = emp.salario and sub.dep_id = emp.dep_id

--4 Listar os nomes departamentos que tem menos de 3 empregados;
select dep_id, count(salario) as qtd
    from empregados
        group by dep_id having count(salario) < 3

--5 Listar os departamentos  com o número de colaboradores
SELECT departamentos.nome, count(emp_id) FROM departamentos join empregados on departamentos.dep_id = empregados.dep_id
    GROUP BY departamentos.dep_id, departamentos.nome

--6 Listar os empregados que não possuem chefes no mesmo departamento
SELECT emp.nome as empregado, chefe.nome as chefe, d1.nome, d2.nome
    from empregados emp join empregados chefe on emp.supervisor_id = chefe.emp_id
        join departamentos d1 on emp.dep_id = d1.dep_id
        join departamentos d2 on chefe.dep_id = d2.dep_id
            where emp.dep_id  != chefe.dep_id;

--7 Listar os departamentos com o total de salários pagos
SELECT dep_id,sum(salario) from empregados group by dep_id

--8  Listar os colaboradores com salario maior que a média do seu departamento;
select emp.nome as funcionario, emp.salario
    from empregados emp
        join (
            select dep_id, avg(salario) as salario
            from empregados
            group by dep_id
        ) as sub on sub.dep_id = emp.dep_id
            where emp.salario > sub.salario

--9 Compare o salario de cada colaborados com média do seu setor. Dica: usar slide windows functions (https://www.postgresqltutorial.com/postgresql-window-function/)
select emp.nome as funcionario, emp.salario as salario, sub.salario as media_setor
    from empregados emp
        join (
            select dep_id, avg(salario) as salario
            from empregados
            group by dep_id
        ) as sub on sub.dep_id = emp.dep_id

--10 Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)
select emp.nome as funcionario, emp.salario as salario, sub.salario as media_setor
    from empregados emp
        join (
            select dep_id, avg(salario) as salario
            from empregados
            group by dep_id
        ) as sub on sub.dep_id = emp.dep_id
            where emp.salario >= sub.salario
