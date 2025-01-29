

with previous as (
SELECT
    actor,
    actorid,
    quality_class,
    year,
    is_active,
    LAG(quality_class,1) OVER(PARTITION BY actorid ORDER BY year)
    as previous_quality_class,
    LAG(is_active,1) OVER(PARTITION BY actorid ORDER BY year) as 
    previous_is_active

    from actors
        )


,indicators as(
    SELECT
        *,
        CASE WHEN (quality_class <> previous_quality_class
            OR previous_quality_class IS NULL ) THEN 1
            WHEN (is_active <> previous_is_active
            OR previous_is_active IS NULL) THEN 1
            
            ELSE 0 END as change
        from previous)


,accumulator as ( 
    SELECT 
        *,
        sum(change) OVER(PARTITION BY actorid order by year) 
            as change_accumulation
    from indicators)
    

, final_table as(SELECT
    actor,
    actorid,
    quality_class,
    is_active,
    change_accumulation,
    min(year) as start_date,
    max(year) as end_date
    from accumulator
    
    GROUP BY
        actor,
        actorid,
        quality_class,
        is_active,
        change_accumulation
    ORDER BY 
        2,5)

select actor, actorid, quality_class, is_active, 
start_date, end_date from final_table
    

    
	
