## Superstore

This project provides overview of sales and profit for a Superstore US orders, icluding ovierview of product's subcategories and customers growth.

File [SuperstoreData](SuperstoreData.csv) contains the original raw data downloaded from one of the [Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final).


### My data processing pipeline is as following:

1. Downloaded SuperstoreData.csv with raw data.
2. Analyzed CSV file and noticed a few formatting issues. Decided to cleanup the file in SQL statements, to have all steps easily replicable. Performed actions:
    - table creation (with column names corresponding to column headers in downloaded CSV file),
    - data import from CSV file to table,
    - data transformation to cleanup data:
      - date format unification (orderdate and shipdate columns),
      - date type conversion (orderdate and shipdate columns),
      - unncessary columns drop (created during date format unification and conversion),
      - columns rename (to keep short and intuitive naming convention).
3. Data analysis:
    - using window functions, case statements or matematical operations between existing columns.
4. Loaded data into CSV file to proceed with visualizations in Tableau Public.


_You can run below files on PostgreSQL:_


[ETL Pipeline](ETL.sql)

[Data Analysis queries](Data_Analysis.sql)


### Data Visualisation in Tableau Public:

1. [Superstore - Sales and Profit summary](https://public.tableau.com/views/Superstore-SalesandProfitsummary/Superstore-SalesandProfitsummary?:language=en-US&:display_count=n&:origin=viz_share_link&:device=desktop)

![image](https://github.com/iwarych/Superstore/assets/59580976/80f37e0d-16b7-4d86-8f1d-a66cb06f8fc7)


In this dashboard you can find overview of the profit and sales - for all regions together and for each region separately.

There is also sale and profit month over month (MoM) percentage change.

Top left hand side panel provides trend of a new customers placing orders, regular customers with at least one order monthly as well as Year and Region filters that are applicable to all charts.

2. [Superstore - Profit Gain and Loss](https://public.tableau.com/views/Superstore-ProfitGainandLoss/ProductCategory?:language=en-US&:display_count=n&:origin=viz_share_link&:device=desktop)

![image](https://github.com/iwarych/Superstore/assets/59580976/f13f88f0-56fe-4637-b8e4-3c6f540dd3c1)


This dashboard provides overview of profit and sales for product's subcategories.

Heatmatp placed in the top of the dashbaord provides % of all orders for each subcategory in particular region with negative profit. As you can see Tables have more thant 50% of ordes with negative profit in each region.

Next you can find matrix of profit and sales. Marks represent subcategory and region.

On the left side you can find profit trand by subcategory (line represents all regions). Colorcoding depends on the sales value.
