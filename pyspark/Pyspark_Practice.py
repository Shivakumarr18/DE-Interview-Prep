import os

os.environ["JAVA_HOME"] = r"C:\Program Files\Eclipse Adoptium\jdk-17.0.16.8-hotspot"
os.environ["HADOOP_HOME"] = r"C:\hadoop"
os.environ["PYSPARK_PYTHON"] = r"C:\Users\shivn\DE-Interview-Prep\.venv\Scripts\python.exe"
os.environ["PYSPARK_DRIVER_PYTHON"] = r"C:\Users\shivn\DE-Interview-Prep\.venv\Scripts\python.exe"

if "SPARK_HOME" in os.environ:
    del os.environ["SPARK_HOME"]

from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("BTS Flight Delay - Q1 2024") \
    .master("local[*]") \
    .getOrCreate()

# Load all 3 months
jan = spark.read.csv("data/raw/January_2024.csv", header=True, inferSchema=True)
feb = spark.read.csv("data/raw/February_2024.csv", header=True, inferSchema=True)
mar = spark.read.csv("data/raw/March_2024.csv", header=True, inferSchema=True)

# Merge rows (union)
df = jan.union(feb).union(mar)

print(f"January rows:  {jan.count():,}")
print(f"February rows: {feb.count():,}")
print(f"March rows:    {mar.count():,}")
print(f"Total Q1 2024: {df.count():,}")
print(f"Total columns: {len(df.columns)}")

spark.stop()