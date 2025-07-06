-- cretae backup 
create table Laptop_backup LIKE leptop.laptopdata;
-- insert data in backup table 
insert into laptop_backup
select * from leptop.laptopdata;
-- which place in 0 that replace to null
UPDATE leptop.laptopdata
SET Inches = NULL
WHERE Inches = 0;
UPDATE leptop.laptopdata
SET Price = NULL
WHERE Price = 0;
-- blanck are to replace to null
UPDATE leptop.laptopdata
SET 
  Company = NULLIF(Company, ''),
  TypeName = NULLIF(TypeName, ''),
  ScreenResolution = NULLIF(ScreenResolution, ''),
  Cpu = NULLIF(Cpu, ''),
  Ram = NULLIF(Ram, ''),
  Memory = NULLIF(Memory, ''),
  Gpu = NULLIF(Gpu, ''),
  OpSys = NULLIF(OpSys, ''),
  Weight = NULLIF(Weight, '');

select * from leptop.laptopdata;

-- delete all null row and value 
Delete from leptop.laptopdata
where row_index in (
select row_index from leptop.laptopdata
where Company is null and TypeName is null and Inches is null and 
ScreenResolution is null and Cpu is null and Ram is null and 
Memory is null and Gpu is null and OpSys is null and Weight is null
and Price is null);

-- count row after delteing 
select Count(*) from leptop.laptopdata;

-- search dublicate value 
select Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight,min(row_index) 
from leptop.laptopdata
group by Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight
having count(*)>1;

-- delete dublicate row
delete from leptop.laptopdata
where row_index not in (
select min(row_index) 
from leptop.laptopdata
group by Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight);

select * from leptop.laptopdata;

-- Cleaning part 
select distinct Company from leptop.laptopdata;
select distinct Typename from leptop.laptopdata;
alter table leptop.laptopdata modify column Inches decimal(10,1);
select distinct Inches from leptop.laptopdata;
DELETE FROM leptop.laptopdata
WHERE Inches IS NULL;
select distinct Inches from leptop.laptopdata;
select distinct Ram from leptop.laptopdata;
alter table leptop.laptopdata modify column Ram integer;
select replace(Ram, 'GB','') from leptop.laptopdata;
update leptop.laptopdata l1
set Ram = (select replace(Ram, 'GB','') from
				leptop.laptopdata l2 where l2.row_index=l1.row_index);
                
select * from leptop.laptopdata;
select distinct Weight from leptop.laptopdata;

update leptop.laptopdata l1
set Weight = (select replace(Weight, 'kg','') from
				leptop.laptopdata l2 where l2.row_index=l1.row_index);
select * from leptop.laptopdata;

update leptop.laptopdata l1
set Price = (select round(Price)
				from leptop.laptopdata l2 where l2.row_index=l1.row_index);
                
select * from leptop.laptopdata;
alter table leptop.laptopdata modify column Price integer;

select * from leptop.laptopdata;

select distinct Opsys from leptop.laptopdata;

-- divide Os system like 
-- Mac , Window, Linux, No os, Chome and android to say other 
-- replace that
select Opsys,
Case 
	when OpSys Like '%mac%' then 'Mac'
    when OpSys Like '%windows%' then 'Windows'
    when OpSys Like '%linux%' then 'Linux'
    when OpSys Like 'No OS' then 'N/A'
    else 'Other' 
end As 'OS_brand'
from leptop.laptopdata;
update leptop.laptopdata
set OpSys =
Case 
	when OpSys Like '%mac%' then 'Mac'
    when OpSys Like '%windows%' then 'Windows'
    when OpSys Like '%linux%' then 'Linux'
    when OpSys Like 'No OS' then 'N/A'
    else 'Other' 
end;

select * from leptop.laptopdata;

select distinct Gpu from leptop.laptopdata;

-- add two new colume for Gpu divide in 2 part so
alter table leptop.laptopdata 
add column Gpu_brand varchar(255) after Gpu,
add column Gpu_name varchar(255) after Gpu_brand;

select * from leptop.laptopdata;

update leptop.laptopdata l1
set Gpu_brand = (select substring_index(Gpu,' ',1) 
	from leptop.laptopdata l2
    where l2.row_index=l1.row_index);
select * from leptop.laptopdata;

select replace(Gpu,Gpu_brand,'') from leptop.laptopdata;

update leptop.laptopdata l1
set Gpu_name = (select replace(Gpu,Gpu_brand,'') 
	from leptop.laptopdata l2
    where l2.row_index=l1.row_index);
    select * from leptop.laptopdata;
    
-- now delete gpu column 
alter table leptop.laptopdata drop column Gpu;

select * from leptop.laptopdata ;

-- cpu in three part in divided 
-- 1 is cpu_brand 2 is cpu_name 3 is cpu_speed

alter table leptop.laptopdata add column cpu_brand varchar(255) after Cpu;
alter table leptop.laptopdata add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed decimal(10,1) after cpu_name;

select * from leptop.laptopdata;

update leptop.laptopdata l1
set cpu_brand = (
	select substring_index(Cpu,' ',1) 
	from leptop.laptopdata l2 where 
    l2.row_index=l1.row_index);
    
select * from leptop.laptopdata;

update leptop.laptopdata l1
set cpu_speed = (select substring_index(Cpu,' ',-1) 
	from leptop.laptopdata l2
    where l2.row_index=l1.row_index);
    
select * from leptop.laptopdata;

update leptop.laptopdata l1
set cpu_name =(
	select replace(replace(Cpu,cpu_brand,''),cpu_speed,'') 
	from leptop.laptopdata l2
    where l2.row_index=l1.row_index);
select * from leptop.laptopdata;

update leptop.laptopdata l1
	set cpu_name=(select replace(cpu_name,'GHz','') 
	from leptop.laptopdata l2
    where l2.row_index=l1.row_index);

select * from leptop.laptopdata;
-- drop the Cpu colume bec 3 part in divide that so 
alter table leptop.laptopdata drop column Cpu;

select * from leptop.laptopdata;

ALTER TABLE leptop.laptopdata
CHANGE cpu_speed cpu_speedGHz decimal(10,2);  

select * from leptop.laptopdata;

-- Screen resolution in two part divided
-- first is display name and second is pixcel 

alter table leptop.laptopdata add column Screen_Pixcel varchar(255) after ScreenResolution;

update leptop.laptopdata l1
set Screen_Pixcel = (select substring_index(ScreenResolution,' ',-1) 
					from leptop.laptopdata l2
                    where l2.row_index=l1.row_index);
                    
select * from leptop.laptopdata;
alter table leptop.laptopdata add column Screen_name varchar(255) after Screen_Pixcel;

update leptop.laptopdata l1
set Screen_name=REPLACE(ScreenResolution, Screen_Pixcel, '');

select * from leptop.laptopdata;

alter table leptop.laptopdata drop column ScreenResolution;

UPDATE leptop.laptopdata
SET Screen_name = 'N/A'
WHERE Screen_name = '';

select * from leptop.laptopdata;

ALTER TABLE leptop.laptopdata
MODIFY COLUMN Screen_name VARCHAR(100) AFTER Inches;
select * from leptop.laptopdata;
