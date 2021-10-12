use world;

-- 1. 도시명 kabul이 속한 국가의 이름은?
select t2.code, t2.name
from city t1 join country t2
on t1.countrycode=t2.code
where t1.name like "kabul";

-- 2. 국가의 공식 언어 사용율이 100%인 국가의 정보를 출력하시오. 국가 이름으로 오름차순 정렬한다.(8건)
select t1.name, t2.language, t2.percentage
from country t1 right outer join countrylanguage t2
on t1.code=t2.countrycode
where t2.isofficial=true and t2.percentage = 100
order by name asc;

-- 3. 도시명 amsterdam에서 사용되는 주요 언어와 amsterdam이 속한 국가는?
select t1.name, l.language, t2.name
from city t1 join country t2
on t1.countrycode = t2.code
join countrylanguage l
on t2.code = l.countrycode
where t1.name like "amsterdam" and l.isofficial=true;

-- 4. 국가명이 united로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 출력하지 않는다. (3건)
select c1.name, c1.capital, c2.name, c2.population
from country c1, city c2
where c1.capital = c2.id
and
c1.name like "united%"
and
c1.capital is not null;

-- 5. 국가명이 united로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 수도 없음이라고 출력한다. (4건)
select distinct(c1.name), c1.capital, if(c1.capital is not null, c2.name, "수도없음") 수도, if(c1.capital is not null, c2.population, "수도없음") 수도인구
from country c1, city c2
where (c1.capital = c2.id or c1.capital is null ) and c1.name like "united%";

-- 6. 국가 코드 che의 공식 언어 중 가장 사용률이 높은 언어보다 사용율이 높은 공식언어를 사용하는 국가는 몇 곳인가? (110)
select count(distinct(countrycode)) 국가수
from countrylanguage
where isofficial = true and
percentage > all (
				select percentage
                from countrylanguage
                where isofficial = true
                and countrycode = "che");
									
-- 7. 국가명 south korea의 공식 언어는?
select language
from countrylanguage
where isofficial = true
and
countrycode = ( select code
				from country
                where name like "south korea"
                );
                
-- 8. 국가 이름이 bo로 시작하는 국가에 속한 도시의 개수를 출력하시오. (3건)
select c1.name, c1.code, (select count(*) from city c2 where c2.countrycode=c1.code)
from country c1
where c1.name like "bo%" and c1.capital is not null;

-- 9. 국가 이름이 bo로 시작하는 국가에 속한 도시의 개수를 출력하시오. 도시가 없을 경우는 단독 이라고 표시한다.(4건)
select c1.name, c1.code, if((select count(*) from city c2 where c2.countrycode=c1.code)=0, '단독', (select count(*) from city c2 where c2.countrycode=c1.code)) 도시개수
from country c1
where c1.name like "bo%";

-- 10. 인구가 가장 많은 도시는 어디인가?
select countrycode, name, population
from city
order by population desc
limit 1;

-- 11. 가장 인구가 적은 도시의 이름, 인구수, 국가를 출력하시오.
select c1.name, c1.code, c2.name, c2.population
from country c1, city c2
where c2.countrycode = c1.code
order by c2.population
limit 1;

-- 12. KOR의 seoul보다 인구가 많은 도시들을 출력하시오.
select countrycode, name, population
from city
where population > (select population from city where name like "seoul");

-- 13. San Miguel 이라는 도시에 사는 사람들이 사용하는 공식 언어는?
select distinct(l.countrycode), l.language
from countrylanguage l join city c
on l.countrycode=c.countrycode
where l.isofficial=true and l.countrycode in (
										select countrycode
										from city
										where name like "San Miguel"
                                        )
order by countrycode;

-- 14. 국가 코드와 해당 국가의 최대 인구수를 출력하시오. 국가 코드로 정렬한다.(232건)
select c1.countrycode, c1.population as "max_pop"
from city c1
where c1.population >= all(
							select population
							from city
							where countrycode = c1.countrycode
                            )
order by countrycode;

-- 15. 국가별로 가장 인구가 많은 도시의 정보를 출력하시오. 국가 코드로 정렬한다.(232건)
select countrycode, name, max(population)
from city
group by countrycode;

-- 16. 국가 이름과 함께 국가별로 가장 인구가 많은 도시의 정보를 출력하시오.(239건)
select c1.code, c1.name, c2.name, max(c2.population)
from country c1, city c2
where c1.code = c2.countrycode
group by c2.countrycode

union

select code, name, capital, population
from country
where capital is null;