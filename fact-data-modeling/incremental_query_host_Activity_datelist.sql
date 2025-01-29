










------------ Incremental Query---------------

--insert into hosts_cumulated
with last_day as(
    select * from hosts_cumulated
    where date = CURRENT_DATE - INTERVAL '1 day'
    -- This cte looks at the snapshot of data as of the last day the query was run
)

, historical as(
    select * from hosts_cumulated
    where date < CURRENT_DATE
    -- historical data for union
)

, this_day as(
    select host,
    date(event_time) as host_activity_datelist

    from events
    where date(event_time) = CURRENT_DATE
    group by 1,2
    order by 1,2
    -- This cte is looking at new data that is coming in

)

, new_host as(
    select  
        t.host,
        ARRAY[t.host_activity_datelist] as host_activity_datelist,
        CURRENT_DATE as date
    from this_day t 
    left join last_day l
    on t.host = l.host
    where l.host is NULL
    --If the user doesn't already exist in the table, a new row is created
)

, existing_host as(
        select  
        COALESCE(t.host,l.host) as host,
        CASE WHEN l.host_activity_datelist is null then ARRAY[t.host_activity_datelist]
         WHEN t.host_activity_datelist is null then l.host_activity_datelist
         ELSE ARRAY[t.host_activity_datelist]||l.host_activity_datelist
         END as host_activity_datelist,
        CURRENT_DATE as date

    from this_day t 
    left join last_day l
    on t.host = l.host
    where l.host is not NULL
    -- If the user already existis in the table - We append the dates to the host_activity_datelist
)

select * from
(
    select * from historical

    union ALL

    select * from new_host

    union ALL

    select * from existing_host




)a 
where date = CURRENT_DATE

-- In this query we built an incremental version where the hos_Activity_datelist is updated
-- with new day every day.
