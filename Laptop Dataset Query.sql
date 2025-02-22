CREATE DATABASE laptop_db;
USE laptop_db;

-- create a backup of the data

CREATE TABLE laptop_backup AS
SELECT * FROM laptop;


--- Clean the data

/* as the data type of both the ‘Ram’ and ‘Weight’ columns is currently text, it hinders proper analysis. 
To address this, we will initially eliminate the ‘GB’ suffix from the ‘Ram’ column and the ‘kg’ suffix from the ‘Weight’ column. 
Subsequently, we will proceed to modify the data type of both ‘Ram’ and ‘Weight’ to integer and decimal, respectively.*/


UPDATE laptop
SET Ram = REPLACE(Ram,'GB',''),
    Weight = REPLACE(Weight, 'kg', '');
    
ALTER TABLE laptop
MODIFY COLUMN Ram INTEGER;

ALTER TABLE laptop 
MODIFY Weight DECIMAL(10,2);

-- create new columns gpu_brand, gpu_name
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

-- update gpu_brand and gpu_name
UPDATE laptop
SET gpu_brand = SUBSTRING_INDEX(Gpu,' ',1),
    gpu_name =  REPLACE(Gpu,gpu_brand,'');
    
-- now drop Gpu column
ALTER TABLE laptop DROP COLUMN Gpu;

-- create new columns cpu_brand, cpu_name, cpu_speed
ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,2) AFTER cpu_name;

-- first we will update the cpu_brand and cpu_speed
UPDATE laptop
SET cpu_brand = SUBSTRING_INDEX(Cpu, " ", 1),
    cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(Cpu, " " , -1), "GHz", "") AS DECIMAL(10,2));
    
-- after that we will update cpu_name
UPDATE laptop
SET cpu_name = REPLACE(REPLACE(Cpu, cpu_brand, ""), SUBSTRING_INDEX(Cpu, " " , -1), "");

-- now drop Cpu column
ALTER TABLE laptop DROP COLUMN Cpu;

select ScreenResolution
from laptop;

-- create new columns resolution_width, resolution_height, touchscreen
ALTER TABLE laptop
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width,
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

-- update resolution_width, resolution_height, touchscreen
UPDATE laptop
SET resolution_width = substring_index(substring_index(ScreenResolution, " ", -1),"x", 1),
    resolution_height = substring_index(substring_index(ScreenResolution, " ", -1),"x", -1),
    touchscreen = ScreenResolution LIKE '%Touchscreen%';

-- now drop ScreenResolution
ALTER TABLE laptop DROP COLUMN ScreenResolution;


-- create columns, memory_type, primary_storage, secondary_storage
ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

-- update memory_type
UPDATE laptop
SET memory_type = CASE
   WHEN Memory LIKE '%+%' THEN 'Hybrid'
   WHEN Memory LIKE '%SSD%' THEN 'SSD'
   WHEN Memory LIKE '%HDD%' THEN 'HDD'
   WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
   WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
   ELSE NULL
END;

-- update primary_storage and secondary_storage
UPDATE laptop
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',1),'[0-9]+'),
secondary_storage =
CASE 
 WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') 
    ELSE 0 
END;

-- In numerous rows, the storage capacity was initially provided in terabytes (TB). 
-- To ensure uniformity, I have converted these values to gigabytes (GB).  
UPDATE laptop
SET primary_storage = 
CASE 
   WHEN primary_storage <= 2 THEN primary_storage*1024 
   ELSE primary_storage 
END,
secondary_storage = 
CASE 
   WHEN secondary_storage <= 2 THEN secondary_storage*1024 
   ELSE secondary_storage 
END;

-- now drop Memory column
ALTER TABLE laptop DROP Memory;


-- 1. What are the top 5 most expensive laptop brands?

SELECT Company, ROUND(AVG(Price),0) AS AvgPrice
FROM laptop
GROUP BY Company
ORDER BY AvgPrice DESC
LIMIT 5;


-- 2. How does laptop price vary by screen size (Inches) and resolution?

SELECT Inches, resolution_width * resolution_height AS Resolution, ROUND(AVG(Price),0) AS AvgPrice
FROM laptop
GROUP BY Inches, Resolution
ORDER BY Inches;

-- 3.  Are touchscreen laptops more expensive on average than non-touchscreen laptops?

SELECT touchscreen, ROUND(AVG(Price),0) AS AvgPrice
FROM laptop
GROUP BY touchscreen;

-- 4. How does RAM size impact the price of a laptop?

SELECT Ram, ROUND(AVG(Price),0) AS AvgPrice
FROM laptop
GROUP BY Ram
ORDER BY Ram;

-- 5. Which CPU brand and model provide the best price-to-performance ratio?

SELECT cpu_brand, cpu_name, ROUND(AVG(Price / cpu_speed),0) AS Price_Per_Performance
FROM laptop
GROUP BY cpu_brand, cpu_name
ORDER BY Price_Per_Performance DESC
LIMIT 5;

-- 6. What is the correlation between CPU speed and laptop price?

SELECT cpu_speed, ROUND(AVG(Price),0) AS AvgPrice
FROM laptop
GROUP BY cpu_speed
ORDER BY 2 DESC;

-- 7. Which combination of CPU and GPU is most common in high-end laptops?

WITH PricePercentile AS (
    SELECT Price,
           NTILE(4) OVER (ORDER BY Price) AS quartile
    FROM laptop
),
HighEndLaptops AS (
    SELECT *
    FROM laptop
    WHERE Price > (
        SELECT MAX(Price)
        FROM PricePercentile
        WHERE quartile = 3
    )
)
SELECT cpu_brand, cpu_name, gpu_brand, gpu_name, COUNT(*) AS LaptopCount
FROM HighEndLaptops
GROUP BY cpu_brand, cpu_name, gpu_brand, gpu_name
ORDER BY LaptopCount DESC
LIMIT 5;


-- 8. What are the most common storage configurations (e.g., SSD vs. HDD vs. Hybrid)?

SELECT memory_type, COUNT(*) AS LaptopCount
FROM laptop
GROUP BY memory_type
ORDER BY LaptopCount DESC;



-- 9. What features are most popular among the top-selling laptops?

WITH TopSellingLaptops AS (
    SELECT * 
    FROM laptop
    ORDER BY Price DESC
    LIMIT 10
)
SELECT cpu_brand, gpu_brand, Ram, memory_type, COUNT(*) AS FeatureCount
FROM TopSellingLaptops
GROUP BY cpu_brand, gpu_brand, Ram, memory_type
ORDER BY FeatureCount DESC;


