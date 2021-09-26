use world;

select @@autocommit;
set autocommit = false;

-- 1. country에서 전체 자료의 수와 독립 연도가 있는 자료의 수를 각각 출력하시오.
select count(*) 전체, (select count(*) from country where indepyear is not null) as "독립 연도 보유"
from country;

-- 2. country에서 기대 수명의 합계, 평균, 최대, 최소를 출력하시오. 평균은 소수점 2자리로 반올림한다.
select sum(lifeexpectancy) 합계, round(avg(lifeexpectancy),2) 평균, max(lifeexpectancy) 최대, min(lifeexpectancy) 최소
from country;

-- 3. country에서 continent 별 국가의 개수와 인구의 합을 구하시오. 국가 수로 정렬 처리한다.(7건)
select continent, count(*) as "국가 수", sum(population) as "인구 합"
from country
group by continent
order by count(*) desc;

-- 4. country에서 대륙별 국가 표면적의 합을 구하시오. 면적의 합으로 내림차순 정렬하고 상위 3건만 출력한다.
select continent, sum(surfacearea) as "표면적 합"
from country
group by continent
order by sum(surfacearea) desc
limit 3;

-- 5. country에서 대륙별로 인구가 50,000,000이상인 나라의 gnp 총 합을 구하시오. 합으로 오름차순 정렬한다.(5건)
select continent, sum(gnp) as "gnp 합"
from country
where population>=50000000
group by continent
order by sum(gnp);

-- 6. country에서 대륙별로 인구가 50,000,000이상인 나라의 gnp 총 합을 구하시오. 이때 gnp의 합이 5,000,000 이상인 것만 구하시오.
select continent, sum(gnp) as "gnp 합"
from country
where population>=50000000
group by continent
having sum(gnp)>=5000000;

-- 7. country에서 연도별로 10개 이상의 나라가 독립한 해는 언제인가?
select indepyear, count(*) as "독립 국가 수"
from country
group by indepyear
having count(*)>10 and indepyear is not null;

-- 8. country에서 국가별로 gnp와 함께 전세계 평균 gnp, 대륙 평균 gnp를 출력하시오.(239건)
select c.continent, c.name, c.gnp, (select avg(gnp) from country) as "전세계 평균", (select avg(gnp) from country where continent = c.continent) as "대륙 평균"
from country c
order by continent;

-- 9. countrylanguage에 countrycode='AAA', language='외계어', isOfficial='F', percentage=10을 추가하시오. 
#    값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.

-- >> countrylanguage 의 countrycode가 기본키임과 동시에 외래키인데
#     참조해오는 원본테이블 country에 해당 countrycode (code) 가 없기 때문에 문제 발생
#     따라서 country 테이블에 code='AAA'를 추가해주어야 함.
insert into country(code, name)
values ('AAA', 'TEMP');

insert into countrylanguage(countrycode, language, isofficial, percentage)
values('AAA', '외계어', 'F', '10');

savepoint s1;

-- 10. countrylanguage에 countrycode='ABW', language='Dutch', isOfficial='F', percentage=10을 추가하시오. 
#      값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.

-- >> countrycode와 language는 countrylanguage 테이블의 기본키이므로 유일성을 충족해야한다.
#	  하지만 이미 countrycode=ABW, language=Dutch 인 데이터가 존재하므로
#	  값을 새로 추가하는 것이 아닌 기존 값 데이터를 수정하는 방식으로 변경해야함.
update countrylanguage
set isofficial = 'F', percentage='10'
where countrycode='ABW' and language='Dutch';

-- 11. country에 다음 자료를 추가하시오. 
# Code='TCode', Region='TRegion',Code2='TC' 
# 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.

-- >> code column은 char(3)으로 지정되어있기 때문에 크기가 4인 'TCode' 가 들어갈 수 없으므로 더 작은 값인 'T'로 수정,
#	  name은 (table 생성 시) null 값이 아니고, default 값을 지정해주지 않았기 때문에 값을 정해주어야 함.
insert into country(code, name, region, code2)
values('T', 'TEMP', 'TRegion', 'TC');

-- 12. city에서 id가 2331인 자료의 인구를 10% 증가시킨 후 조회하시오.
update city
set population = population * 1.1
where id=2331;

select id, name, population
from city
where id=2331;

-- 13. country에서 code가 'USA'인 자료를 삭제하시오. 
# 삭제가 안되는 이유를 생각하고 성공하려면 어떤 절차가 필요한지 생각만 하시오.
delete from country
where code = 'USA';		-- 실패!!
-- country 테이블의 code를 외래키이자 기본키로 삼는 countrylanguage 테이블이 존재하기 때문.
-- 따라서 해당 쿼리를 수행하려면, countrylanguage에서 code = 'USA'인 자료 인스턴스를 먼저 지우는 절차를 선행해야 함.

-- 14. 이제 까지의 DML 작업을 모두 되돌리기 위해 rollback 처리하시오.
rollback;

-- 15. ssafy_ws_5th라는 이름으로 새로운 schema를 생성하시오.
create schema ssafy_ws_5th;
use ssafy_ws_5th;

-- 16. 만약 user라는 테이블이 존재한다면 삭제하시오.
drop table IF EXISTS user CASCADE;

-- 17. ssafy_ws_5th에 다음 조건을 만족하는 테이블을 생성하시오.
create table user
	(
	id				VARCHAR(50)
    ,name			VARCHAR(100) DEFAULT '익명'
    ,pass			VARCHAR(100)
    ,PRIMARY KEY(id)
    );
    
-- 18. user 테이블에 다음의 자료를 추가하시오.
insert into user(id,pass,name)
values ('ssafy', '1234', '김싸피'),
		('hong', '5678', '홍싸피'),
        ('test', 'test', '테스트');

-- 19. id가 test인 계정의 pass를 id@pass 형태로 변경하고 조회하시오.
select id, name, concat(id, '@', pass) pass
from user
where id like "test";

-- 20. id가 test인 계정의 자료를 삭제하고 조회하시오.
delete from user
where id='test';
select *
from user;

-- 21. 현재까지의 내용을 영구 저장하기 위해서 commit 처리하시오.
commit;