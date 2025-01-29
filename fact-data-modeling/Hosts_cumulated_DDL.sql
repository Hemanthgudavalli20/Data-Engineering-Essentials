CREATE TABLE hosts_cumulated (
    host TEXT,
    host_activity_datelist DATE[],
    date DATE,
    PRIMARY KEY(host, date)

    -- creating host_activity_datelist as an array of dates as we want to append dates of host activity.
    -- Primary key -> This way we will have a row for each host for each day
)
