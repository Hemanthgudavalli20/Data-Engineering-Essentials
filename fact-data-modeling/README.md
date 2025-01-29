# Data Engineering Essentials - Fact Data Modeling 

This repository contains SQL queries and scripts for performing fact data modeling. The objective is to process and transform raw event and device data into structured, cumulative, and incremental models for analysis and reporting.

## Table of Contents
- [Overview](#overview)
- [Queries](#queries)

## Overview

This repository contains a set of SQL queries that perform the following tasks:
- Deduplicate `game_details` table.
- Create and update the `user_devices_cumulated` table.
- Generate the `device_activity_datelist` and `datelist_int` columns.
- Create and incrementally update the `hosts_cumulated` and `host_activity_reduced` tables.

These transformations help convert raw event data into summarized and compact models for further analysis.

## Queries

The following SQL queries are included in this repository:

### 1. Create `user_devices_cumulated` Table
**Purpose**: Create the `user_devices_cumulated` table, which tracks user activity by browser type over time. The `device_activity_datelist` field is stored as an array of dates.  

### 2. Generate `device_activity_datelist`
**Purpose**: Create a cumulative `device_activity_datelist` by joining the deduplicated event data.  

### 3. Generate `datelist_int`
**Purpose**: Convert the `device_activity_datelist` column into a compact `datelist_int` column using **bitwise** **encoding** for each day in the month.  

### 4. Create `hosts_cumulated` Table
**Purpose**: Create the `hosts_cumulated` table to log host activity by date. The `host_activity_datelist` tracks when each host experiences any activity.  

### 5. Incrementally Update `host_activity_datelist`
**Purpose**: This query updates the `host_activity_datelist` based on new user interaction data.  

### 6. Create `host_activity_reduced` Table
**Purpose**: Create a reduced fact table (`host_activity_reduced`) to store aggregated data for each host, such as the number of hits and unique visitors.  

### 7. Incremental Update for `host_activity_reduced`
**Purpose**: Incrementally update the `host_activity_reduced` table, tracking daily updates for hits and unique visitors.  



