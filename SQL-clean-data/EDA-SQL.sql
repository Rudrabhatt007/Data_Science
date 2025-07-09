-- 1.head-->tail-->sample
-- 2 fro numarical cols
	-- 8 number sumary [cpount,min,max,std,men,q1,q2,q3]
	-- missing value
    -- outliers
    -- horizontal/vertical histogram
-- 3. for categorical cols
	-- value count-->pi chart
	-- missing value
-- 4 numarical-numarical
	-- side by side number analys
    -- scatterplot
    -- correlation
-- 5.categrical- categorical
	-- table - stacked bar chart
-- 6.num-cate
	-- compare distribution accross categ
-- 7. missing value treatment
-- 8.feature enginnering
-- ppi
-- prncipal bracket
-- one hot encoding 
use leptop;
SELECT * FROM laptopdata;

select * from laptopdata order by 'row_index'  limit 5;
select * from laptopdata order by  'row_index' desc limit 5;
select * from laptopdata order by rand() limit 5;

select count(price) over(),
min(Price) over(),
max(Price) over(),
avg(Price) over(),
std(Price) over(),
percentile_cont(0.25) within group(order by Price) over() as 'Q1',
percentile_cont(0.5) within group(order by Price) over() as 'median',
percentile_cont(0.75) within group(order by Price) over() as 'Q3' from laptopdata order by 'row_index' limit 1;

select count(Price)
from laptopdata
where Price is null;

-- outler find
SELECT * 
FROM (
    SELECT *,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM laptopdata
) t
WHERE t.Price < t.Q1 - (1.5 * (t.Q3 - t.Q1)) 
   OR t.Price > t.Q3 + (1.5 * (t.Q3 - t.Q1));

-- histogram
select t.Bucket,repeat('*',count(*)) from(select Price,
case
	when Price between 0 and 25000 then '0-25k'
	when Price between 25000 and 50000 then '25k-50k'
	when Price between 50001 and 75000 then '50k-75k'
	when Price between 75001 and 100000 then '75k-100k'
	else '>100k'
end as 'Bucket'
from laptopdata) t
group by t.Bucket;
   
select * from laptopdata;

select Company,count(Company) from laptopdata
group by Company;

select Company,
sum(case when Touchscreen = 1 then 1 else 0 end) as 'Toucscreen_yes',
sum(case when Touchscreen = 0 then 1 else 0 end) as 'Toucscreen_no'
from laptopdata
group by Company;



   




