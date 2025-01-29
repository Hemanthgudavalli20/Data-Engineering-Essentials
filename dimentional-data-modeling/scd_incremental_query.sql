create type scd_type as (
    quality_class quality_class,
    is_active BOOLEAN,
    start_date INTEGER,
    end_date INTEGER
)

with last_year_scd AS(
SELECT * FROM actors_history_scd
WHERE start_date = 1981
AND end_date = 1981)

, historical_scd AS (
    select 
        actor,
        actorid,
        quality_class,
        is_active,
        start_date,
        end_date
    FROM actors_history_scd
    WHERE end_date <1981
)

, this_year_data as (
    SELECT * from actors
    WHERE year = 1982
)

, unchanged_records as (
    SELECT
        ty.actor,
        ty.actorid,
        ty.quality_class,
        ty.is_active,
        ly.start_date,
        ty.year as end_date
    FROM this_year_data ty JOIN
        last_year_scd ly 
    ON ly.actorid = ty.actorid
    WHERE ty.quality_class = ly.quality_class
    AND ty.is_active = ly.is_active
)

, changed_records as (
    SELECT
        ty.actor,
        ty.actorid,
        unnest(ARRAY[ROW(
            ly.quality_class,
            ly.is_active,
            ly.start_date,
            ly.end_date
        )::scd_type,
        ROW(
            ty.quality_class,
            ty.is_active,
            ty.year,
            ty.year
        )::scd_type
        ]) as record 
    FROM this_year_data ty 
    LEFT JOIN last_year_scd ly 
    ON ly.actorid = ty.actorid
    WHERE (ly.is_active <> ty.is_active OR ly.quality_class
    <> ty.quality_class)

)

, unnested_changed_records as (
    SELECT actor,
            actorid,
            (record::scd_type).quality_class,
            (record::scd_type).is_active,
            (record::scd_type).start_date,
            (record::scd_type).end_date
            FROM changed_records
)

, new_records AS (
    SELECT 
        ty.actor,
        ty.actorid,
        ty.quality_class,
        ty.is_active,
        ty.year as start_date,
        ty.year as end_date
    FROM this_year_data ty 
    LEFT JOIN last_year_scd ly 
        on ty.actorid = ly.actorid
    WHERE ly.actorid is NULL
)

SELECT * from (
    SELECT *
    FROM historical_scd
    
    UNION ALL

    SELECT *
    FROM unchanged_records
    
    UNION ALL

    SELECT *
    FROM unnested_changed_records
    
    UNION ALL

    SELECT *
    FROM new_Records
    
    
) a
