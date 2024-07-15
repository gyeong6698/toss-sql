USE titanic;
SELECT * FROM titanic;

-- 중복값 유무 확인
SELECT
	COUNT(passengerid) N_PASS
    , COUNT(DISTINCT Passengerid) N_UNIQUE_PASS
FROM titanic
;

-- 요인별 생존 여부 집계
SELECT SUM(survived) FROM titanic; -- 0은 사망 / 1은 생존

-- 성별에 따른 승객수와 생존자 수, 비율 구하기 
SELECT 
	Sex
    , SUM(survived) 
    , COUNT(passengerid)
    , round(SUM(survived) /COUNT(passengerid), 3) AS survival_ratio
FROM 
	titanic
GROUP BY 1
;

-- 연령별로 생존자수, 탑승객수, 비율 구하기 

SELECT 
	FLOOR(AGE/10) * 10 as AGEBAND
    , COUNT(passengerid) AS Passengers
    , SUM(survived) AS Survivors
    , round(SUM(survived) /COUNT(passengerid), 3) AS survival_ratio
FROM 
	titanic
GROUP BY 1
ORDER BY 1
;
-- 연령- 성별 승객수, 생존자수 
SELECT 
	FLOOR(AGE/10) * 10 as AGEBAND
    , sex
    , COUNT(passengerid) AS Passengers
    , SUM(survived) AS Survivors
    , round(SUM(survived) /COUNT(passengerid), 3) AS survival_ratio
FROM 
	titanic
GROUP BY 1, 2
HAVING sex = 'male' -- 만약 남자만 뽑고싶다면 
ORDER BY 1, 2
;

-- 두 성별의 생존율 차이 
-- HELP : 인라인뷰에 조인문 만들기 

SELECT 
	A.AGEBAND
    , A.ratio AS M_RATIO
    , B.ratio AS F_RATIO
    , ROUND(B.ratio - A.ratio, 2) AS DIFF
FROM (
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'male'
	 ORDER BY 1, 2
) A
LEFT JOIN 
(
	SELECT 
		FLOOR(AGE/10) * 10 AGEBAND 
		, sex
		, COUNT(passengerid) AS 승객수
		, SUM(survived) AS 생존자수
		, ROUND(SUM(survived) / COUNT(passengerid), 3) AS ratio
	 FROM titanic
	 GROUP BY 1, 2
	 HAVING sex = 'female'
	 ORDER BY 1, 2
) B
ON A.AGEBAND = B.AGEBAND
;


-- 필드명 embarked
-- 승선 항구별 승객 수
SELECT 
	Embarked
	,COUNT(passengerid) 
FROM 
	titanic
GROUP BY 1
;

-- 승선 항구별, 성별 승객 수
SELECT 
	sex
	,Embarked
	,COUNT(passengerid) 
FROM 
	titanic
GROUP BY 1, 2
ORDER BY 1, 2
;

-- 승선 항구별, 성별 승객 비중(%) -> 인라인 뷰 테이블 결합 

SELECT 
	A.embarked
    , A.sex
    , A.승객수
    , B.승객수
    , ROUND(A.승객수 / B.승객수, 2) AS ratio
FROM (
	SELECT 
		sex
		,Embarked
		,COUNT(passengerid)
	FROM 
		titanic
	GROUP BY 1, 2
    ORDER BY 1, 2
) A
LEFT JOIN(
    SELECT 
		Embarked
		,COUNT(passengerid) 승객수
	FROM 
		titanic
	GROUP BY 1
) B
    ON A.embarked = B.embarked
;


SELECT 
	A.embarked
    , A.sex
    , A.승객수
    , B.승객수
    , ROUND(A.승객수 / B.승객수, 2) AS ratio
FROM (
	SELECT 
		embarked
		, sex
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1, 2
	ORDER BY 1, 2
) A 
LEFT JOIN (
	SELECT 
		embarked
		, COUNT(passengerid) 승객수
	FROM titanic
	GROUP BY 1
	ORDER BY 1
) B
ON A.embarked = B.embarked
;
