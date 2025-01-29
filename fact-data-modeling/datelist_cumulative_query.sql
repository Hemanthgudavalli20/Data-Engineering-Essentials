-- insert into events_and_devices
-- with events_and_devices_deduped as(
-- select 
-- e.user_id,
-- CAST(e.event_time as DATE) as event_time,
-- e.device_id,
-- d.browser_type,

-- row_number() OVER( partition by 
-- e.user_id,
-- CAST(e.event_time as DATE),
-- e.device_id,
-- d.browser_type ) as row_num


-- from events e
-- join devices d on e.device_id = d.device_id
-- where e.user_id is not null
-- and row_num =1
-- )

-- select * from events_and_devices_deduped where row_num =1

-- ;
-- In the above query we are combining the events and devices table to fetch browser_type and events to a single table
-- we also use row number window function to eliminate duplicates


--insert into user_devices_cumulated
with yesterday as (
    select *
        from user_devices_cumulated
    where date = date('2023-01-30')

)
, today as(
    select 
    CAST(user_id as TEXT) as user_id,
    DATE(event_time) as device_activity_datelist,
    browser_type
    from events_and_devices
    where date(event_time) = DATE('2023-01-31')
    group by 1,2,3
    -- here we are using the deduplicated and combined table 'events_and_devices' which contains devices and events data
)

select 
    COALESCE(t.user_id,y.user_id) as user_id,
    CASE when y.device_activity_datelist is null then ARRAY[t.device_activity_datelist]
        when t.device_activity_datelist is null then y.device_activity_datelist
        else ARRAY[t.device_activity_datelist] || y.device_activity_datelist
    end as device_activity_datelist,
    -- the above case statement is used to populate the device_activity_datelist
    -- the case statement handles the user bassed on if they are new or already exisitng in user_devices_cumulated

    COALESCE(t.browser_type,y.browser_type) as browser_type,
    COALESCE(date(t.device_activity_datelist),date(y.date + INTERVAL '1 day')) as day



    from today t
     full outer join yesterday y    
     on
     t.user_id = y.user_id and
     t.browser_type = y.browser_type

	