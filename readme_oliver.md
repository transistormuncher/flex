
## Understanding of task and approach
I received a couple of CSV and JSON files that contain data on power generating assets, their actual and forecasted power generated as well as price data. There are some common pitfalls such as
- inconsistent labelling / naming ("a1" vs "a_1")
- mix of long and wide format (cf measured power generation)
- different orders of magnitude (kw vs mw)
- different timezones (data in UTC, reports shall presumably be CET)

First, I took a first look at the data using a jupyter notebook (explore.ipynb). But it quickly became clear to me that some more complicated data transformation needs to happen, so I switched to SQL.

Second, I made the transformations necessary to answer the immediate questions (folder "SQL"). But I was not satisfied with the rigid nature of the final result. In addition it became clear that certain preprocessing transformations were necessary in multiple queries. Hence, I decided to make the data transformation process more explicit and formalised using DBT. 

## DBT approach
With dbt I can split complex data transformations into modular, reusable parts.

### Setup, data load and transformation
Use the following ``Make`` commands to dbt and run the transformations:

- build_container: build the docker containers for dbt and Postgres DB 
- load_data: load the data from CSV and JSON to the DB
- dbt: run dbt inside the container to transform the data
- data_test: run consistency checks on the final tables to avoid duplicates

### Layers
I like to structure my data transformations into the following layers:

- base: 1:1 copy of source data, just minimal renamings or type casts
- transform: heavier transformations, application of business logic
- dim: this is the presentation layer for dimensional and fact tables. These fact tables should contain all information to answer pertinent business questions.
- report: static reports that can be displayed or used in downstream applications (invoice generation e.g.)

### Reports
I created static reports to answer the immediate questions. I provide daily, weekly and monthly versions of the forecast and imbalance report to show what is possible with a correctly designed fact table. Ideally the fact table is loaded to a visualisation tool where it can be analysed interactively (or even into Excel using pivot tables for exploration). 

Due to the limited amount of data (just one day) I refrained from making any graphical reports or overviews. I hope it is clear though how the fact tables make the creation of various visualisations and reports possible.


## Potential next steps

- make loading more robust (or query CSVs directly from S3)
- test robustness of data model with more data
- add more data integrity tests
- build dynamic reports in visualisation tool (light dash, metabase, looker studio, etc)
- export / push data to gsheet if needed