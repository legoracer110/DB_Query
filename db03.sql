use scott;

-- 1. emp 와 dept Table 을 JOIN 하여 이름 , 급여 , 부서명을 검색하세요
select e.ename 이름, e.sal 급여, d.dname 부서명
from emp e inner join dept d
where e.deptno = d.deptno;

-- 2. 이름이 KING’ 인 사원의 부서명을 검색하세요
select d.dname
from emp e inner join dept d
on e.deptno = d.deptno
where e.ename = 'KING';

-- 3. dept Table 에 있는 모든 부서를 출력하고 , emp Table 에 있는 DATA 와 JOIN 하여
#	 모든 사원의 이름 , 부서번호 , 부서명 , 급여를 출력 하라
select dname
from dept;

select e.ename, e.deptno, d.dname, e.sal
from emp e inner join dept d
on e.deptno = d.deptno;

-- 4. emp Table 에 있는 empno 와 mgr 을 이용하여 서로의 관계를 다음과 같이 출력되도록 
#	  쿼리를 작성하세요 . ‘SCOTT 의 매니저는 JONES 이다’
select concat(e.ename, ' 의 매니저는 ', m.ename, ' 이다')
from emp e inner join emp m
on e.mgr = m.empno;
-- where e.ename = 'SCOTT';

-- 5.'SCOTT' 의 직무와 같은 사람의 이름 , 부서명 , 급여 , 직무를 검색하세요
select e.ename, d.dname, e.sal, e.job
from emp e inner join dept d
on e.deptno = d.deptno
where job like (
				select job
				from emp e1
				where ename like 'SCOTT'
                ) 
and e.ename not like 'SCOTT';

-- 6.'SCOTT' 가 속해 있는 부서의 모든 사람의 사원번호 , 이름 , 입사일 , 급여를 검색하세요
select empno, ename, hiredate, sal
from emp
where deptno = (
				select deptno
				from emp
                where ename = 'SCOTT'
                )
and ename not like 'SCOTT';

-- 7. 전체 사원의 평균급여보다 급여가 많은 사원의 사원번호 , 이름, 부서명 , 입사일 , 지역 , 급여를 검색하세요
select e.empno, e.ename, d.dname, e.hiredate, d.loc, e.sal
from emp e, dept d
where e.deptno = d.deptno
and
e.sal > ( select avg(sal) from emp );

-- 8. 30 번 부서와 같은 일을 하는 사원의 사원번호 , 이름 , 부서명, 지역 , 급여를 급여가 많은 순으로 검색하세요.
select e.empno, e.ename, d.dname, d.loc, e.sal
from emp e join dept d
on e.deptno = d.deptno
where e.job in (
				select job
				from emp
                where deptno = 30
                )
order by sal;

-- 9. 10 번 부서 중에서 30 번 부서에는 없는 업무를 하는 사원의 사원번호 , 이름 , 부서명 , 입사일 , 지역을 검색하세요
select e.empno, e.ename, e.hiredate, d.loc
from emp e join dept d
on e.deptno = d.deptno
where e.deptno=10
and
e.job not in (
				select job
                from emp
                where deptno = 30
                );
                
-- 10. 'KING’ 이나 JAMES' 의 급여와 같은 사원의 사원번호 , 이름, 급여를 검색하세요
select empno, ename, sal
from emp
where sal in (
				select sal
                from emp
                where ename = 'KING' or ename = 'JAMES'
                )
and ename not in ('KING', 'JAMES');

-- 11. 급여가 30 번 부서의 최고 급여보다 높은 사원의 사원번호, 이름, 급여를 검색하세요
select empno, ename, sal
from emp
where sal > all(
				select sal
                from emp
                where deptno = 30
                );
                
-- 12. 14. 15. 제외

-- 13. 이름이 'ALLEN' 인 사원의 입사연도가 같은 사원들의 이름과 급여를 출력하세요
select ename, sal
from emp
where hiredate = (select hiredate from emp where ename like 'ALLEN')
and
ename not like 'ALLEN';