use scott;

-- 1. 부서위치가 CHICAGO 인 모든 사원에 대해 이름, 업무, 급여를 출력하는 SQL을 작성하세요
select e.ename, e.job, e.sal
from emp e, dept d
where e.deptno=d.deptno and d.loc like "CHICAGO";

-- 2. 부하직원이 없는 사원의 사원번호, 이름, 업무, 부서번호를 출력하는 SQL 을 작성하세요
select e1.empno, e1.ename, e1.job, e1.deptno
from emp e1 left outer join emp e2
on e1.empno = e2.mgr
where e2.empno is null;

-- 3. BLAKE 와 같은 상사를 가진 사원의 이름, 업무, 상사번호를 출력하는 SQL 을 작성하세요
select ename, job, mgr
from emp
where mgr like (select mgr from emp where ename like "BLAKE") 
and ename not like "BLAKE";

-- 4. 입사일이 가장 오래된 사람 5 명을 검색하세요
select ename, hiredate
from emp
order by hiredate
limit 5;

-- 5. JONES 의 부하 직원의 이름 , 업무 , 부서명을 검색하세요
select e1.ename, e1.job, (select d.dname from dept d where d.deptno=e1.deptno)
from emp e1 inner join emp e2
on e1.mgr = e2.empno
where e2.ename like "JONES";