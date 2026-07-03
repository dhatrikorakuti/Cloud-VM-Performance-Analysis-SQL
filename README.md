# Cloud Virtual Machine Performance Analysis using SQL

Project Overview

This project analyzes the performance of virtual machines in a cloud computing environment using PostgreSQL. The objective was to clean the data, analyze resource utilization, answer business questions, and generate actionable insights to support efficient cloud resource management.

Objectives

- Clean and preprocess the dataset.
- Handle missing values and validate data quality.
- Analyze CPU, memory, power consumption, execution time, and energy efficiency.
- Compare resource utilization across different task types, priorities, and statuses.
- Generate business insights and recommendations.

Dataset Information

Domain: Cloud Computing

Dataset Size: Approximately 2 Million Records

Database: PostgreSQL

Features

- VM ID
- CPU Usage
- Memory Usage
- Power Consumption
- Execution Time
- Energy Efficiency
- Network Traffic
- Number of Executed Instructions
- Task Type
- Task Priority
- Task Status
- Timestamp

Tools & Technologies

- PostgreSQL
- SQL
- GitHub

Project Workflow

1. Imported the dataset into PostgreSQL.
2. Performed data cleaning.
3. Handled missing values.
4. Checked for duplicate records.
5. Validated data quality.
6. Conducted Exploratory Data Analysis (EDA).
7. Solved 22 business questions.
8. Generated business insights and recommendations.

Business Questions Answered

- Which task types consume the highest CPU resources?
- How does memory usage vary across task types?
- Which task priorities consume the most resources?
- What is the distribution of task statuses?
- Which virtual machines have the highest CPU utilization?
- How are virtual machines distributed based on CPU utilization?
- How are virtual machines distributed based on memory utilization?
- How are virtual machines distributed based on power consumption?
- How are virtual machines distributed based on execution time?
- How are virtual machines distributed based on energy efficiency?

A total of 22 SQL business questions were analyzed.

Key Findings

- Missing values were successfully handled before analysis.
- No duplicate records were found.
- Around 46% of virtual machines operate with moderate resource utilization.
- Approximately 27% of virtual machines fall into the high utilization category for CPU, memory, power consumption, execution time, and energy efficiency.
- Resource utilization across task types and priorities remained relatively balanced.
- Some virtual machines reached 100% CPU utilization, indicating potential resource-intensive workloads.

Business Recommendations

- Monitor virtual machines with consistently high CPU and memory utilization.
- Improve data quality by reducing missing values during data collection.
- Optimize high power-consuming virtual machines to reduce operational costs.
- Investigate low energy-efficiency virtual machines to improve resource allocation.

## Repository Structure

```
Cloud-VM-Performance-Analysis-SQL/

│── Cloud_VM_Performance_Analysis.sql
│── Cloud_VM_Performance_Report.pdf
│── README.md
│
├── Dataset/
│     └── vm_cloud_data.csv
│
└── Images/
      ├── view.png
      ├── missing_values.png
      ├── avg.png
      ├── tasks.png
      ├── vm_distributed.png
      └── energy_eff_vm.png
```

Author

Dhatri Priya.k