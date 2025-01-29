


--INSERT INTO host_activity_reduced
WITH daily_aggregate AS(
    select host,
        date(event_time) as date,
        count(1) as num_site_hits,
        count(DISTINCT user_id) as nums_unique_users
        from events
        where date(event_time) = date('2023-01-03')
        and user_id is not null
        group by 1,2
        -- In this cte we aggregate the counts per day. Each day will be represented by a number in our hit_arrays and unique_visitors
)

, yesterday as(
    select * from host_activity_reduced
    where month = DATE('2023-01-01')
    -- We look at existing data in the table
)



select 
    COALESCE(y.month, DATE_TRUNC('month',da.date)) as month,
    COALESCE(da.host,y.host) as host,

    CASE WHEN y.hit_array is NOT NULL THEN
        y.hit_array || ARRAY[COALESCE(da.num_site_hits,0)]
        WHEN y.hit_array is NULL THEN
        ARRAY_FILL(0,ARRAY[COALESCE(date - date(DATE_TRUNC('month',date)),0)]) || 
        ARRAY[COALESCE(da.num_site_hits,0)]
        end as hit_array,

    CASE WHEN y.unique_visitors is NOT NULL THEN
        y.unique_visitors || ARRAY[COALESCE(da.nums_unique_users,0)]
        WHEN y.unique_visitors is NULL THEN
        ARRAY_FILL(0,ARRAY[COALESCE(date - date(DATE_TRUNC('month',date)),0)]) || 
        ARRAY[COALESCE(da.nums_unique_users,0)]
        end as unique_visitors

    from daily_aggregate da full outer JOIN
        yesterday y 
            on da.host = y.host

ON conflict(month, host) -- Specifies the columns (month and host) that are used to identify conflicts (e.g., a duplicate row based on these columns in the table).
DO 
UPDATE SET hit_array = EXCLUDED.hit_array,
unique_visitors = EXCLUDED.unique_visitors

