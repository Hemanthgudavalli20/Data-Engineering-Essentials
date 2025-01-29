

with users as(
SELECT * FROM user_devices_cumulated
where date = date('2023-01-31') 
)

, series as(
select 
    generate_series(date('2023-01-01'),date('2023-01-31'), INTERVAL '1 day')
as series

)

, place_holder_ints as(

    select 
        (CASE WHEN (device_activity_datelist @> array[date(series)])
        THEN
            cast(pow(2,31-(date-date(series)) )as bigint)
            else 0 end
            ) as placeholder_int_value
        -- A condition checking if the device_activity_datelist (array of activity dates) contains the date from series.
        --If true, a bitwise placeholder value is computed using POW(2, 31 - (date - series)), where 31 corresponds to the total number of days in the month (to align bits from left to right).
        --If false, the placeholder value is 0.

        ,* 
        FROM users cross join series)

SELECT
    user_id,
    browser_type,
    cast(cast(sum(placeholder_int_value)as bigint) as bit(32))
    -- The sum of placeholder values is calculated and cast into a 32-bit integer.
    -- The resulting integer (datelist_int) represents the user's activity dates compactly, where each bit corresponds to a specific day in the series. If the bit is 1, it means the user was active on that day; otherwise, it's 0.
    as datelist_int



from place_holder_ints 
group by user_id, browser_type 