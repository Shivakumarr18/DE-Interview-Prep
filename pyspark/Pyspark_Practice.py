print("Spark Version:", spark.version)

from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

data = [
    (1, "Shiva", "Engineering", 50000, "Hyderabad", "2022-03-15"),
    (2, "Ramya", "Engineering", 65000, "Hyderabad", "2021-07-20"),
    (3, "Arjun", "Sales", 45000, "Bangalore", "2023-01-10"),
    (4, "Priya", "Sales", 55000, "Bangalore", "2020-11-05"),
    (5, "Kiran", "HR", 40000, "Chennai", "2023-06-01"),
    (6, "Meera", "HR", 48000, "Chennai", "2022-09-18"),
    (7, "Vikram", "Engineering", 72000, "Hyderabad", "2019-04-25"),
    (8, "Anjali", "Sales", None, "Bangalore", "2023-08-30"),
    (9, "Rohan", "Engineering", 58000, None, "2022-12-12"),
    (10, "Divya", "HR", 42000, "Chennai", "2024-01-15")
]

columns = ["id", "name", "department", "salary", "city", "hire_date"]
df = spark.createDataFrame(data, columns)

# Problem 1: Create the DataFrame above. Then display the schema and the first 5 rows. Also show the total row count.
# Displaying schema and first 5 rows
df.printSchema()
df.show(5)

# Row count
print(f"Total Rows: {df.count()}")
# Problem 2: Select only name, department, and salary columns. Show the result. Then do the same selection using two different
#  syntaxes (e.g., df.select() vs df["col"] vs col()).
# Syntax 1: String-based
df.select("name", "department", "salary").show()

# Syntax 2: Attribute-based (Not recommended for columns with spaces)
df.select(df.name, df.department, df.salary).show()

# Syntax 3: col() function (Standard for 15 LPA Engineering)
from pyspark.sql.functions import col
df.select(col("name"), col("department"), col("salary")).show()

# Problem 3: Filter employees who earn more than 50000 AND work in Engineering. Show the result.
df.filter((col("salary") > 50000) & (col("department") == "Engineering")).show()

# Problem 4: Add a new column called bonus that is 10% of salary. Handle NULL salaries — if salary is NULL, 
# bonus should also be NULL (not 0).
# 10% of salary. Spark handles NULLs automatically (NULL * 0.1 = NULL)
df.withColumn("bonus", col("salary") * 0.1).show()

# Problem 5: Rename hire_date to joining_date and id to employee_id. Cast salary to DoubleType. Show the updated schema.
df_updated = df.withColumnRenamed("hire_date", "joining_date") \
               .withColumnRenamed("id", "employee_id") \
               .withColumn("salary", col("salary").cast("double"))

df_updated.printSchema()

# Problem 6: Find all rows where city is NULL OR salary is NULL. Then separately, drop all rows that have any NULL value and 
# count how many rows remain.
# 1. Finding rows with NULLs
df.filter(col("city").isNull() | col("salary").isNull()).show()

# 2. Dropping rows with ANY NULL
df_clean = df.na.drop()
print(f"Rows remaining after drop: {df_clean.count()}")
# Problem 7: Sort the DataFrame by department ascending, then by salary descending within each department. Show the result.
df.orderBy(col("department").asc(), col("salary").desc()).show()

# Problem 8: Add a new column salary_category with these rules:
# salary < 45000 → "Low"
# salary between 45000 and 60000 → "Mid"
# salary > 60000 → "High"
# salary is NULL → "Unknown"
# Use when() and otherwise().
df.withColumn("salary_category", 
    when(col("salary") < 45000, "Low")
    .when(col("salary").between(45000, 60000), "Mid")
    .when(col("salary") > 60000, "High")
    .otherwise("Unknown")
).show()

# Problem 9: Get distinct departments and distinct cities (two separate outputs). Then get distinct combinations of
#  (department, city).
# Separate
df.select("department").distinct().show()
df.select("city").distinct().show()

# Combinations
df.select("department", "city").distinct().show()

# Problem 10: For each department, compute:
# total employees
# average salary (ignoring NULLs)
# max salary
# min salary
# Use groupBy and aggregation functions. Round average salary to 2 decimals.
from pyspark.sql import functions as F

df.groupBy("department").agg(
    F.count("id").alias("total_employees"),
    F.round(F.avg("salary"), 2).alias("avg_salary"),
    F.max("salary").alias("max_salary"),
    F.min("salary").alias("min_salary")
).show()