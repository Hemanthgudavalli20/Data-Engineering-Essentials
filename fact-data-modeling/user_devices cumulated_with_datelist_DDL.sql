CREATE TABLE user_devices_cumulated (
    user_id TEXT,
    device_activity_datelist DATE[],
    browser_type TEXT,
    date DATE,
    PRIMARY KEY(user_id, browser_type, date)
)
-- creating a table with given requirements. 
-- user_id is text as we will group by
-- date will be current date and date type
--here, daveice_activity_datelist is an array of dates as we want the dates to be in a single row.
-- Primary key will be a combination of user_id, browser_type, and date