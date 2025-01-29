create TYPE films as(
    year INTEGER, 
    film TEXT,
    votes INTEGER,
    rating REAL,
    filmid TEXT)

create TYPE quality_class as ENUM(
    'star',
    'good',
    'average',
    'bad')

create table actors (
    actor TEXT,
    actorid TEXT,
    year INTEGER,
    films films[],
    quality_class quality_class,
    is_active BOOLEAN,
    PRIMARY KEY (actor, actorid, year)

);