create table host_activity_reduced (
    month DATE,
    host TEXT,
    hit_array REAL[],
    unique_visitors REAL[],
    PRIMARY KEY( month, host)
)
-- we want to look at the host metrics
-- hit_array will contain an array of integers representing the website visits every day
-- unique_visitors will contain array of integers represesnting the number of unique visitors each day
-- the combination of day and host will be our primary key as we will be aggregating the other metrics per day per host