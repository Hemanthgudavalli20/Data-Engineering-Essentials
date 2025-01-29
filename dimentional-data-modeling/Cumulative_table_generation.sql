insert into actors
with last_year as (
        select * from actors
            where year = 1981
) ,
    this_year as (
        select 
        actor, actorid, year,
        array_agg(ARRAY[ROW(
                year,
                film ,
                votes ,
                rating ,
                filmid 
            )::films]) AS films,
        
        CASE 
            WHEN AVG(rating)  > 8 THEN 'star' 
            WHEN AVG(rating)  > 7  THEN 'good'
            WHEN AVG(rating)  > 6  THEN 'average'
            ELSE 'bad'
        END::quality_class AS quality_class
        from actor_films
            where year = 1982
            group by actor,actorid,year
    ) 


select 
    COALESCE (t.actor,l.actor) as actor,
    COALESCE (t.actorid,l.actorid) as actorid,
    COALESCE (t.year,l.year+1) as year,
    CASE WHEN l.films is null 
        THEN
            t.films
        WHEN l.films is not NULL THEN 
            l.films || t.films
        ELSE 
            l.films END AS films,

    CASE WHEN t.quality_class is not NULL THEN
    t.quality_class
    ELSE l.quality_class END AS quality_class,

    CASE WHEN t.year is not NULL THEN TRUE
        ELSE FALSE
    END as is_active


from this_year t full outer join 
    last_year l on
         t.actorid = l.actorid

;

