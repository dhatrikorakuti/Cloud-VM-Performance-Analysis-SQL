CREATE TABLE vm_cloud_data (
    vm_id VARCHAR(50),
    timestamp TIMESTAMP,
    cpu_usage DECIMAL(6,2),
    memory_usage DECIMAL(6,2),
    network_traffic DECIMAL(10,2),
    power_consumption DECIMAL(10,2),
    num_executed_instructions DOUBLE PRECISION,
    execution_time DECIMAL(10,2),
    energy_efficiency DECIMAL(6,2),
    task_type VARCHAR(50),
    task_priority VARCHAR(20),
    task_status VARCHAR(20)
);

--importing data

COPY vm_cloud_data
FROM 'C:/vmCloud_data.csv'
DELIMITER ','
CSV HEADER;

---TO check if all records imported
SELECT COUNT(*) AS total_records
FROM vm_cloud_data;

---To view data limit 10
SELECT *
FROM vm_cloud_data
LIMIT 10;

----datatype of col
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'vm_cloud_data';

--checking null values?
SELECT
    COUNT(*) FILTER (WHERE cpu_usage IS NULL) AS cpu_nulls,
    COUNT(*) FILTER (WHERE memory_usage IS NULL) AS memory_nulls,
    COUNT(*) FILTER (WHERE power_consumption IS NULL) AS power_nulls,
    COUNT(*) FILTER (WHERE execution_time IS NULL) AS execution_time_nulls,
    COUNT(*) FILTER (WHERE energy_efficiency IS NULL) AS efficiency_nulls
FROM vm_cloud_data;

SELECT
COUNT(*) FILTER (WHERE timestamp IS NULL) AS timestamp_nulls,
COUNT(*) FILTER (WHERE network_traffic IS NULL) AS network_traffic_nulls,
COUNT(*) FILTER (WHERE num_executed_instructions IS NULL) AS instruction_nulls
FROM vm_cloud_data_clean
--For timestamps using an average or random replacement
--is generally not appropriate 
--because it changes the time information in a way that isn't meaningful.
UPDATE vm_cloud_data_clean
SET network_traffic = (
    SELECT AVG(network_traffic)
    FROM vm_cloud_data_clean
)
WHERE network_traffic IS NULL;

UPDATE vm_cloud_data_clean
SET num_executed_instructions = (
    SELECT AVG(num_executed_instructions)
    FROM vm_cloud_data_clean
)
WHERE num_executed_instructions IS NULL;

SELECT
COUNT(*) FILTER (WHERE network_traffic IS NULL) AS network_nulls,
COUNT(*) FILTER (WHERE num_executed_instructions IS NULL) AS instruction_nulls
FROM vm_cloud_data_clean;
--here null values 
SELECT COUNT(*) AS total_rows
FROM vm_cloud_data;

--to find percentage of null values in each col
SELECT
ROUND(COUNT(*) FILTER (WHERE cpu_usage IS NULL) * 100.0 / COUNT(*),2) AS cpu_missing,
ROUND(COUNT(*) FILTER (WHERE memory_usage IS NULL) * 100.0 / COUNT(*),2) AS memory_missing,
ROUND(COUNT(*) FILTER (WHERE power_consumption IS NULL) * 100.0 / COUNT(*),2) AS power_missing,
ROUND(COUNT(*) FILTER (WHERE execution_time IS NULL) * 100.0 / COUNT(*),2) AS execution_missing,
ROUND(COUNT(*) FILTER (WHERE energy_efficiency IS NULL) * 100.0 / COUNT(*),2) AS efficiency_missing
FROM vm_cloud_data;CREATE TABLE vm_cloud_data (
    vm_id VARCHAR(50),
    timestamp TIMESTAMP,
    cpu_usage DECIMAL(6,2),
    memory_usage DECIMAL(6,2),
    network_traffic DECIMAL(10,2),
    power_consumption DECIMAL(10,2),
    num_executed_instructions DOUBLE PRECISION,
    execution_time DECIMAL(10,2),
    energy_efficiency DECIMAL(6,2),
    task_type VARCHAR(50),
    task_priority VARCHAR(20),
    task_status VARCHAR(20)
);

--importing data

COPY vm_cloud_data
FROM 'C:/vmCloud_data.csv'
DELIMITER ','
CSV HEADER;

---TO check if all records imported
SELECT COUNT(*) AS total_records
FROM vm_cloud_data;

---To view data limit 10
SELECT *
FROM vm_cloud_data
LIMIT 10;

----datatype of col
SELECT column_name,data_type
FROM information_schema.columns
WHERE table_name = 'vm_cloud_data';

--checking null values?
SELECT
    COUNT(*) FILTER (WHERE cpu_usage IS NULL) AS cpu_nulls,
    COUNT(*) FILTER (WHERE memory_usage IS NULL) AS memory_nulls,
    COUNT(*) FILTER (WHERE power_consumption IS NULL) AS power_nulls,
    COUNT(*) FILTER (WHERE execution_time IS NULL) AS execution_time_nulls,
    COUNT(*) FILTER (WHERE energy_efficiency IS NULL) AS efficiency_nulls
FROM vm_cloud_data;

--Total dataset 
SELECT COUNT(*) AS total_rows
FROM vm_cloud_data;

--to find percentage of null values in each col
SELECT
ROUND(COUNT(*) FILTER (WHERE cpu_usage IS NULL) * 100.0 / COUNT(*),2) AS cpu_missing,
ROUND(COUNT(*) FILTER (WHERE memory_usage IS NULL) * 100.0 / COUNT(*),2) AS memory_missing,
ROUND(COUNT(*) FILTER (WHERE power_consumption IS NULL) * 100.0 / COUNT(*),2) AS power_missing,
ROUND(COUNT(*) FILTER (WHERE execution_time IS NULL) * 100.0 / COUNT(*),2) AS execution_missing,
ROUND(COUNT(*) FILTER (WHERE energy_efficiency IS NULL) * 100.0 / COUNT(*),2) AS efficiency_missing
FROM vm_cloud_data;

--check rows where all rows are null
SELECT COUNT(*)
FROM vm_cloud_data
WHERE cpu_usage IS NULL
AND memory_usage IS NULL
AND power_consumption IS NULL
AND execution_time IS NULL
AND energy_efficiency IS NULL;

--checking rows with atleast one null 
SELECT COUNT(*)
FROM vm_cloud_data
WHERE cpu_usage IS NULL
OR memory_usage IS NULL
OR power_consumption IS NULL
OR execution_time IS NULL
OR energy_efficiency IS NULL;

--How much of the dataset contains missing values?
SELECT COUNT(*)
FROM vm_cloud_data
WHERE cpu_usage IS NULL
   OR memory_usage IS NULL
   OR power_consumption IS NULL
   OR execution_time IS NULL
   OR energy_efficiency IS NULL;

 --In percentage % 
 SELECT
    COUNT(*) AS rows_with_missing_values,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM vm_cloud_data),
        2
    ) AS missing_percentage
FROM vm_cloud_data
WHERE cpu_usage IS NULL
   OR memory_usage IS NULL
   OR power_consumption IS NULL
   OR execution_time IS NULL
   OR energy_efficiency IS NULL;

--now we need to replace null values 
--lets make a copy and modify our data 

CREATE TABLE vm_cloud_data_clean AS
SELECT *
FROM vm_cloud_data;

--To find mean of data 
SELECT
ROUND(AVG(cpu_usage),2) AS mean_cpu
FROM vm_cloud_data_clean;

--To find median of data 
SELECT
percentile_cont(0.5)
WITHIN GROUP (ORDER BY cpu_usage)
AS median_cpu
FROM vm_cloud_data_clean
WHERE cpu_usage IS NOT NULL;

--There is 0.04 difference in mean and med 
--mean is preferrerd
UPDATE vm_cloud_data_clean
SET
    cpu_usage = COALESCE(cpu_usage,
        (SELECT AVG(cpu_usage) FROM vm_cloud_data_clean)),
    memory_usage = COALESCE(memory_usage,
        (SELECT AVG(memory_usage) FROM vm_cloud_data_clean)),
    power_consumption = COALESCE(power_consumption,
        (SELECT AVG(power_consumption) FROM vm_cloud_data_clean)),
    execution_time = COALESCE(execution_time,
        (SELECT AVG(execution_time) FROM vm_cloud_data_clean)),
    energy_efficiency = COALESCE(energy_efficiency,
        (SELECT AVG(energy_efficiency) FROM vm_cloud_data_clean));

--verifying 
SELECT
COUNT(*) FILTER (WHERE cpu_usage IS NULL) AS cpu_nulls,
COUNT(*) FILTER (WHERE memory_usage IS NULL) AS memory_nulls,
COUNT(*) FILTER (WHERE power_consumption IS NULL) AS power_nulls,
COUNT(*) FILTER (WHERE execution_time IS NULL) AS execution_nulls,
COUNT(*) FILTER (WHERE energy_efficiency IS NULL) AS efficiency_nulls
FROM vm_cloud_data_clean;

--cleaning in cateogory columns
UPDATE vm_cloud_data_clean
SET
    task_type = COALESCE(task_type, 'Unknown'),
    task_priority = COALESCE(task_priority, 'Unknown'),
    task_status = COALESCE(task_status, 'Unknown');
--we know tht task_type,task_priority,task_status are categorical 
--so need to change 
SELECT
    COUNT(*) FILTER (WHERE task_type IS NULL) AS task_type_nulls,
    COUNT(*) FILTER (WHERE task_priority IS NULL) AS task_priority_nulls,
    COUNT(*) FILTER (WHERE task_status IS NULL) AS task_status_nulls
FROM vm_cloud_data_clean;
--lower case for all col
UPDATE vm_cloud_data_clean
SET task_type = LOWER(task_type);

--Counting null values in vm_id col
SELECT COUNT(*) AS null_vm_ids
FROM vm_cloud_data_clean
WHERE vm_id IS NULL;

--To delete vm_id
DELETE FROM vm_cloud_data_clean
WHERE vm_id IS NULL;
--To verify
SELECT COUNT(*)
FROM vm_cloud_data_clean
WHERE vm_id IS NULL;
--if the VM's identity is missing, you cannot invent a VM ID. 
--That would create fake machines and make your analysis unreliable.
--So for identifier columns like vm_id, the appropriate action is to remove those incomplete records.

-- checking for duplicates?
SELECT
    vm_id,
    timestamp,
    cpu_usage,
    memory_usage,
    network_traffic,
    power_consumption,
    num_executed_instructions,
    execution_time,
    energy_efficiency,
    task_type,
    task_priority,
    task_status,
    COUNT(*) AS occurrences
FROM vm_cloud_data_clean
GROUP BY
    vm_id,
    timestamp,
    cpu_usage,
    memory_usage,
    network_traffic,
    power_consumption,
    num_executed_instructions,
    execution_time,
    energy_efficiency,
    task_type,
    task_priority,
    task_status
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

--This means no duplicates

--Now data is suitable for further analysis

--EDA
--To check min and max values 
SELECT
    MIN(cpu_usage) AS min_cpu,
    MAX(cpu_usage) AS max_cpu,
    MIN(memory_usage) AS min_memory,
    MAX(memory_usage) AS max_memory,
    MIN(power_consumption) AS min_power,
    MAX(power_consumption) AS max_power,
    MIN(execution_time) AS min_execution,
    MAX(execution_time) AS max_execution,
    MIN(energy_efficiency) AS min_efficiency,
    MAX(energy_efficiency) AS max_efficiency
FROM vm_cloud_data_clean;

--Values are not in range 

--"Our goal to check cpu performance and how we can improve"

--What is the average CPU usage across all virtual machines?
SELECT ROUND(AVG(cpu_usage), 2) AS average_cpu_usage
FROM vm_cloud_data_clean;

--Its 50.01%

--What is the average memory usage across all virtual machines?
SELECT ROUND(AVG(memory_usage),2) AS average_memory_usage
FROM vm_cloud_data_clean;

--Its 49.98%

--What is the average power consumption?
SELECT ROUND(AVG(power_consumption),2) AS average_power_consumption
FROM vm_cloud_data_clean;

--What is the average execution time?
SELECT ROUND(AVG(execution_time),2) AS average_execution_time
FROM vm_cloud_data_clean;

--What is the average energy efficiency?
SELECT ROUND(AVG(energy_efficiency),2) AS average_energy_efficiency
FROM vm_cloud_data_clean;

--What is avg cpu_usage,memory_usage,power_consumption,execution_time,energy_efficiency?
SELECT
    ROUND(AVG(cpu_usage),2) AS avg_cpu,
    ROUND(AVG(memory_usage),2) AS avg_memory,
    ROUND(AVG(power_consumption),2) AS avg_power,
    ROUND(AVG(execution_time),2) AS avg_execution_time,
    ROUND(AVG(energy_efficiency),2) AS avg_efficiency
FROM vm_cloud_data_clean;

--The cloud infrastructure appears to have balanced resource utilization. 
--On average, CPU and memory are utilized at approximately 50%, 
--indicating moderate workload distribution across virtual machines.

-- Business Question:
--Which task types consume the highest CPU resources?
SELECT task_type,ROUND(AVG(cpu_usage),2) AS avg_cpu_usage
FROM vm_cloud_data_clean
GROUP BY task_type
ORDER BY avg_cpu_usage DESC;

 
---- Business Insight:
--Network tasks recorded the highest average CPU usage (50.04%). 
--However, the difference compared to IO (50.01%) and Compute (49.99%) is very small. 
--This indicates that CPU resources are distributed almost evenly across all task types, 
--suggesting balanced workload management in the cloud environment.

-- Business Question:
-- Which task type consumes the highest average memory?

SELECT
    task_type,
    ROUND(AVG(memory_usage),2) AS avg_memory_usage
FROM vm_cloud_data_clean
GROUP BY task_type
ORDER BY avg_memory_usage DESC;
 
---- Business Insight:
-- IO tasks recorded the highest average memory usage (50.03%).
-- However, the variation among task types is minimal,
-- indicating balanced memory utilization across workloads.

--Buisness Question:
--Which task type consumes the highest power?

SELECT
    task_type,
    ROUND(AVG(power_consumption),2) AS avg_power_consumption
FROM vm_cloud_data_clean
GROUP BY task_type
ORDER BY avg_power_consumption DESC;

-- Business Insight:
-- Network tasks recorded the highest average power consumption (250.23).
-- However, the variation across task types is minimal,
-- indicating balanced power utilization in the cloud environment.

--Buisness Question:
--Which task type has the highest average execution time?
SELECT
    task_type,
    ROUND(AVG(execution_time),2) AS avg_execution_time
FROM vm_cloud_data_clean
GROUP BY task_type
ORDER BY avg_execution_time DESC;

-- Business Insight:
-- IO tasks recorded the highest average execution time (50.00).
-- The differences across task types are negligible,
-- indicating consistent task processing performance 

--Buisness Question
--Which task type has the highest average energy efficiency?
SELECT
    task_type,
    ROUND(AVG(energy_efficiency),2) AS avg_energy_efficiency
FROM vm_cloud_data_clean
GROUP BY task_type
ORDER BY avg_energy_efficiency DESC;

-- Business Insight:
-- All task types have nearly identical average energy efficiency (0.50).
-- This indicates consistent energy utilization across different workloads.

--Buisness Question: 
--Which task priority consumes the highest CPU resources?
SELECT
    task_priority,
    ROUND(AVG(cpu_usage),2) AS avg_cpu_usage
FROM vm_cloud_data_clean
GROUP BY task_priority
ORDER BY avg_cpu_usage DESC;

-- Answer:
-- Low-priority tasks have the highest average CPU usage (50.08%).

-- Business Insight:
-- CPU utilization is evenly distributed across all priority levels,
-- indicating balanced resource allocation.

--Buisness Question 
--Which task priority consumes the highest average memory?
SELECT
    task_priority,
    ROUND(AVG(memory_usage),2) AS avg_memory_usage
FROM vm_cloud_data_clean
GROUP BY task_priority
ORDER BY avg_memory_usage DESC;

-- Answer:
-- Medium-priority tasks have the highest average memory usage (50.03%).

-- Business Insight:
-- Memory utilization is evenly distributed across all task priorities,
-- indicating balanced memory allocation.

--Buisness question:
--Which task priority consumes the highest average power?
SELECT
    task_priority,
    ROUND(AVG(power_consumption),2) AS avg_power_consumption
FROM vm_cloud_data_clean
GROUP BY task_priority
ORDER BY avg_power_consumption DESC;

-- Answer:
-- High-priority tasks have the highest average power consumption (250.19).

-- Business Insight:
-- Power consumption is nearly identical across all task priorities,
-- suggesting efficient and balanced energy usage.

--Buisness question:
--Which task priority has the highest average execution time?
SELECT
    task_priority,
    ROUND(AVG(execution_time),2) AS avg_execution_time
FROM vm_cloud_data_clean
GROUP BY task_priority
ORDER BY avg_execution_time DESC;

-- Answer:
-- Low-priority tasks have the highest average execution time (49.99).

-- Business Insight:
-- Execution times are nearly identical across all task priorities,
-- indicating consistent task processing performance.

--Buisness question:
--Which task priority has the highest average energy efficiency?
SELECT
    task_priority,
    ROUND(AVG(energy_efficiency),2) AS avg_energy_efficiency
FROM vm_cloud_data_clean
GROUP BY task_priority
ORDER BY avg_energy_efficiency DESC;

-- Answer:
-- All task priorities have the same average energy efficiency (0.50).

-- Business Insight:
-- Energy efficiency is consistent across all task priorities,
-- indicating uniform energy utilization.

--Buisness question:
--How are tasks distributed across different statuses?
SELECT
    task_status,
    COUNT(*) AS total_tasks,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vm_cloud_data_clean),2) AS percentage
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY total_tasks DESC;

-- Answer:
-- Waiting tasks account for the largest share (30.02%),
-- followed closely by Running (30.01%) and Completed (29.96%).
-- Around 10.02% of tasks have an Unknown status.

-- Business Insight:
-- Task statuses are evenly distributed, indicating balanced workload processing.
-- However, the Unknown category highlights a data quality issue that should be investigated.

--Buisness question:
--Which task status consumes the highest average CPU resources?
SELECT
    task_status,
    ROUND(AVG(cpu_usage),2) AS avg_cpu_usage
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY avg_cpu_usage DESC;

-- Answer:
-- Running tasks have the highest average CPU usage (50.06%).

-- Business Insight:
-- Running tasks consume slightly more CPU than other task statuses,
-- but the difference is minimal, indicating balanced CPU utilization.

--Buisness question:
--Which task status consumes the highest average memory?
SELECT
    task_status,
    ROUND(AVG(memory_usage),2) AS avg_memory_usage
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY avg_memory_usage DESC;

-- Answer:
-- Completed tasks have the highest average memory usage (50.01%).

-- Business Insight:
-- Memory utilization is nearly identical across all task statuses,
-- indicating balanced memory allocation.

--Buisness question
--Which task status consumes the highest average power?
SELECT
    task_status,
    ROUND(AVG(power_consumption),2) AS avg_power_consumption
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY avg_power_consumption DESC;

-- Answer:
-- Running tasks have the highest average power consumption (250.32).

-- Business Insight:
-- Running tasks consume slightly more power than other task statuses,
-- but the variation is minimal, indicating stable power utilization.

--Buisness Queston
--Which task status has the highest average execution time?
SELECT
    task_status,
    ROUND(AVG(execution_time),2) AS avg_execution_time
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY avg_execution_time DESC;

-- Answer:
-- Running tasks have the highest average execution time (50.02).

-- Business Insight:
-- Running tasks show the highest execution time,
-- but the difference across task statuses is minimal,
-- indicating consistent task execution performance.

--Buisness question 
--Which task status has the highest average energy efficiency?
SELECT
    task_status,
    ROUND(AVG(energy_efficiency),2) AS avg_energy_efficiency
FROM vm_cloud_data_clean
GROUP BY task_status
ORDER BY avg_energy_efficiency DESC;

-- Answer:
-- All task statuses have the same average energy efficiency (0.50).

-- Business Insight:
-- Energy efficiency is consistent across all task statuses,
-- indicating stable energy utilization throughout the task lifecycle.

--Buisness question:
--How are virtual machines distributed based on CPU utilization?


SELECT
CASE
    WHEN cpu_usage < 30 THEN 'Low'
    WHEN cpu_usage < 70 THEN 'Medium'
    ELSE 'High'
END AS cpu_category,
COUNT(*) AS total_vms,
ROUND(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM vm_cloud_data_clean),
2) AS percentage
FROM vm_cloud_data_clean
GROUP BY cpu_category
ORDER BY total_vms DESC;
-- Answer:
-- 45.89% of virtual machines have medium CPU utilization.
-- 27.05% operate under high CPU utilization.

-- Business Insight:
-- Most VMs operate under moderate CPU load, while over one-quarter
-- experience high CPU utilization and should be monitored for
-- potential performance bottlenecks.

--Buisness question:
--How are virtual machines distributed based on memory utilization?
SELECT
CASE
    WHEN memory_usage < 30 THEN 'Low'
    WHEN memory_usage < 70 THEN 'Medium'
    ELSE 'High'
END AS memory_category,
COUNT(*) AS total_vms,
ROUND(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM vm_cloud_data_clean),
2) AS percentage
FROM vm_cloud_data_clean
GROUP BY memory_category
ORDER BY total_vms DESC;

-- Answer:
-- 46.02% of virtual machines have medium power consumption.
-- 26.98% operate under high power consumption.

-- Business Insight:
-- Most VMs consume a moderate amount of power, while nearly one-quarter
-- have high power consumption and should be monitored for energy optimization.

--Buisness question 
--How are virtual machines distributed based on Power Consumption?
SELECT
CASE
    WHEN power_consumption < 150 THEN 'Low'
    WHEN power_consumption < 350 THEN 'Medium'
    ELSE 'High'
END AS power_category,
COUNT(*) AS total_vms,
ROUND(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM vm_cloud_data_clean),
2) AS percentage
FROM vm_cloud_data_clean
GROUP BY power_category
ORDER BY total_vms DESC;

-- Answer:
-- 45.98% of virtual machines have medium power consumption.
-- 27.03% operate under high power consumption.

-- Business Insight:
-- Most VMs consume a moderate amount of power, while over one-quarter
-- operate at high power consumption and should be monitored to improve
-- energy efficiency and reduce operational costs.

--Buisness question:
--How are virtual machines distributed based on execution time?
SELECT
CASE
    WHEN execution_time < 30 THEN 'Low'
    WHEN execution_time < 70 THEN 'Medium'
    ELSE 'High'
END AS execution_category,
COUNT(*) AS total_vms,
ROUND(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM vm_cloud_data_clean),
2) AS percentage
FROM vm_cloud_data_clean
GROUP BY execution_category
ORDER BY total_vms DESC;

-- Answer:
-- 46.01% of virtual machines have medium execution time.
-- 26.98% operate with high execution time.

-- Business Insight:
-- Most VMs complete tasks within a moderate execution time,
-- while nearly one-quarter have high execution times and
-- should be monitored for performance optimization.

--Buisness question
--How are virtual machines distributed based on energy efficiency?
SELECT
CASE
    WHEN energy_efficiency < 0.3 THEN 'Low'
    WHEN energy_efficiency < 0.7 THEN 'Medium'
    ELSE 'High'
END AS efficiency_category,
COUNT(*) AS total_vms,
ROUND(
    COUNT(*) * 100.0 /
    (SELECT COUNT(*) FROM vm_cloud_data_clean),
2) AS percentage
FROM vm_cloud_data_clean
GROUP BY efficiency_category
ORDER BY total_vms DESC;

-- Answer:
-- 45.95% of virtual machines have medium energy efficiency.
-- 27.52% have high energy efficiency, while 26.53% have low energy efficiency.

-- Business Insight:
-- Most VMs maintain moderate energy efficiency, but over one-quarter
-- have low efficiency and should be reviewed for optimization
