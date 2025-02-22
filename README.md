# Advanced-Data-Cleaning-Analysis-With-SQL-in-Laptop-Dataset

Overview

This project involves analyzing a dataset of laptops to extract meaningful insights about laptop specifications, pricing trends, and feature distributions. The dataset includes various attributes such as company, CPU and GPU specifications, RAM, storage, screen resolution, touchscreen capability, weight, and price.

Dataset Schema

The dataset consists of the following columns:

Company (text) - Brand of the laptop

TypeName (text) - Category/type of the laptop

Inches (double) - Screen size in inches

resolution_width (int) - Width of the screen resolution

resolution_height (int) - Height of the screen resolution

touchscreen (int) - Indicates if the laptop has a touchscreen (1 for Yes, 0 for No)

cpu_brand (varchar) - Brand of the CPU

cpu_name (varchar) - Model name of the CPU

cpu_speed (decimal) - Speed of the CPU in GHz

Ram (int) - RAM size in GB

memory_type (varchar) - Type of storage (SSD, HDD, Hybrid, Flash Storage)

primary_storage (int) - Primary storage capacity in GB

secondary_storage (int) - Secondary storage capacity in GB (if available)

gpu_brand (varchar) - Brand of the GPU

gpu_name (varchar) - Model name of the GPU

OpSys (text) - Operating system of the laptop

Weight (decimal) - Weight of the laptop in kg

Price (double) - Price of the laptop in USD

Data Cleaning and Transformation

Backup Creation

A backup of the laptop table was created to preserve raw data.

Data Type Adjustments

Ram and Weight were converted to integer and decimal types respectively after removing units (GB, kg).

Feature Extraction

cpu_brand, cpu_name, and cpu_speed were extracted from Cpu column and the original column was dropped.

gpu_brand and gpu_name were extracted from Gpu column and the original column was dropped.

resolution_width, resolution_height, and touchscreen were extracted from ScreenResolution and the original column was dropped.

memory_type, primary_storage, and secondary_storage were extracted from Memory column and the original column was dropped.

Storage Standardization

All storage values were converted to GB for consistency.

Business Questions and Insights

1. Top 5 Most Expensive Laptop Brands

Query identifies brands with the highest average prices.

2. Laptop Price Variation by Screen Size and Resolution

Analyzes how screen dimensions impact pricing.

3. Price Comparison of Touchscreen vs. Non-Touchscreen Laptops

Determines if touchscreens increase the cost.

4. Impact of RAM Size on Laptop Pricing

Examines correlation between RAM and price.

5. Best Price-to-Performance CPU Models

Identifies CPU models with the best price-to-performance ratio.

6. Correlation Between CPU Speed and Laptop Price

Checks if higher CPU speeds correspond to higher prices.

7. Most Common CPU-GPU Combinations in High-End Laptops

Finds the dominant CPU-GPU configurations in premium laptops.

8. Most Common Storage Configurations

Evaluates the distribution of SSDs, HDDs, and hybrid storage types.

9. Popular Features in Top-Selling Laptops

Highlights the most common specifications in best-selling models.



Set up the database and import the dataset.

Run SQL scripts for data cleaning and analysis.

Author

Utsab Sarkar


