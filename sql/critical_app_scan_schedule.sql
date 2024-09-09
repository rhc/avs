DELETE FROM public.cmdb_scan_schedule;

-- SA (South Africa) Inserts
INSERT INTO cmdb_scan_schedule (business_unit, is_ar, start_day, start_hour, end_day, end_hour, engine_pool)
VALUES 
    ('PPB', FALSE, 'Sunday', 6, 'Monday', 6, 'Core scanner'),
    ('CIB', FALSE, 'Saturday', 6, 'Saturday', 20, 'Core Scanner'),
    ('CF', FALSE, 'Saturday', 6, 'Saturday', 20, 'Discovery scanners'),
    ('IAM', FALSE, 'Friday', 20, 'Saturday', 6, 'Deep dive'),
    ('BCB', FALSE, 'Saturday', 6, 'Saturday', 20, 'Deep dive'),
    ('TGF', FALSE, 'Sunday', 8, 'Sunday', 20, 'Deep dive');

-- AR (Africa Region) Inserts
INSERT INTO cmdb_scan_schedule (business_unit, is_ar, start_day, start_hour, end_day, end_hour, engine_pool)
VALUES 
    ('PPB', TRUE, 'Sunday', 2, 'Monday', 6, 'Core scanner pool'),
    ('CIB', TRUE, 'Saturday', 14, 'Sunday', 2, 'Core Scanner pool'),
    ('CF', TRUE, 'Friday', 20, 'Saturday', 2, 'Core Scanner pool'),
    ('IAM', TRUE, 'Saturday', 2, 'Saturday', 6, 'Core Scanner pool'),
    ('BCB', TRUE, 'Saturday', 6, 'Saturday', 10, 'Core Scanner pool'),
    ('TGF', TRUE, 'Saturday', 10, 'Saturday', 14, 'Core Scanner pool');


select * from cmdb_scan_schedule;
