# Maven Tech Quarterly Sales Analysis

## Overview
MavenTech is a company that specializes in selling computer hardware to large businesses based in different countries.

Aim: The aim of this analysis is to show the quarterly sales performance of Maven Tech. By analyzing various aspects of the sales data to identify trends, make data driven recommendation, and gain a deeper understanding of the company.

### Tools
- SQL - For data cleaning and uncovering of insights.
- Power BI - For Visualization.
- Power BI - For data Modelling.

### Tasks performed through the entire workflow.
- Data cleaning and inspection.
- Building Relational model.
- Writing SQL syntax for uncovering insights.
- Designing an interactive Dashboard.

### Exploratory Data Analysis 
1. To see how Opportunities move through the pipeline stages.
   ``` sql
   SELECT deal_stage,
   COUNT(opportunity_id) AS Opportunity_count
    FROM sales_pipeline
    GROUP BY deal_stage
    ORDER BY Opportunity_count DESC;
```
