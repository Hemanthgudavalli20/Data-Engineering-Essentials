# Dimensional Data Modeling 

## Overview
This repository contains SQL scripts and table definitions for modeling the `actor_films` dataset using **dimensional data modeling** techniques. The project focuses on structuring the data to enable efficient querying and historical tracking.

Key features of this project:
- **DDL statements** for `actors` and `actors_history_scd` tables.
- **SCD Type 2 implementation** for tracking historical changes.
- **ETL queries** for cumulative updates, backfilling, and incremental updates.

## Dataset Schema
The `actor_films` dataset consists of the following columns:

| Column  | Description |
|---------|------------|
| `actor` | Name of the actor. |
| `actorid` | Unique identifier for the actor. |
| `film` | Name of the film. |
| `year` | Release year of the film. |
| `votes` | Number of votes received. |
| `rating` | Film rating. |
| `filmid` | Unique identifier for the film. |

Primary Key: (`actorid`, `filmid`)

## Files in This Repository
| File | Description |
|------|------------|
| `01_actors_table.sql` | DDL for the `actors` table. |
| `02_cumulative_update.sql` | **SCD Type 2** query to populate the `actors` table incrementally, one year at a time. |
| `03_actors_history_scd.sql` | DDL for the `actors_history_scd` table using Type 2 SCD modeling. |
| `04_backfill_scd.sql` | Query to backfill `actors_history_scd` with historical data. |
| `05_incremental_scd.sql` | Query for incremental updates to the `actors_history_scd` table. |

---

## 1️⃣ `actors` Table DDL
The `actors` table is designed to store an actor’s filmography and performance quality.
Key features:
- **Nested Struct**: `films` is stored as an **array of structs** containing `film`, `votes`, `rating`, and `filmid`.
- **Quality Classification**: Categorized based on an actor’s average rating in their most recent film year.
- **Activity Status**: A boolean flag (`is_active`) that indicates if an actor is still making films.


---

## 2️⃣ Cumulative Table Update (SCD Type 2)
This query **incrementally populates** the `actors` table while preserving historical changes using **Slowly Changing Dimension (SCD) Type 2** modeling.
- If an actor's `quality_class` or `is_active` status changes, a new version of the record is inserted with a new `start_date`.
- The previous version's `end_date` is updated to maintain historical accuracy.
- Ensures a **year-over-year tracking** of actors' performance trends.


---

## 3️⃣ `actors_history_scd` Table DDL
The `actors_history_scd` table tracks historical changes in actor quality classification and activity status using **Type 2 SCD modeling**.
Key features:
- **Start and End Dates**: Tracks when a record was valid.
- **Maintains History**: New records are inserted when `quality_class` or `is_active` changes.


---

## 4️⃣ Backfill Query for `actors_history_scd`
A **one-time query** to populate `actors_history_scd` with historical data in a single execution.
- Processes all available `actors` data.
- Assigns correct `start_date` and `end_date` values.


---

## 5️⃣ Incremental Update for `actors_history_scd`
This query **merges new data** from the `actors` table with historical data, ensuring proper versioning of changes:
- If `quality_class` or `is_active` changes, a new version is created with an updated `start_date`.
- The previous record’s `end_date` is updated.


---


## 📌 Key Learnings
- **Dimensional Data Modeling**: Structuring data for analytical workloads.
- **Slowly Changing Dimensions (SCD Type 2)**: Implementing historical tracking for changes in attributes over time.
- **Incremental Data Processing**: Efficient updates to maintain historical integrity.

---

### 📢 Contributions & Feedback
Feel free to fork the repo, suggest improvements, or raise issues. 🚀
