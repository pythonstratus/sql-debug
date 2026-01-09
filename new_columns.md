Here's the ALTER TABLE command for Oracle:

```sql
-- Add WEEK_DATA column to ENTMONTH table
ALTER TABLE ENTMONTH ADD (
    WEEK_DATA VARCHAR2(1000)
);
```

Or if you want to add it with a comment for documentation:

```sql
-- Add WEEK_DATA column to ENTMONTH table
ALTER TABLE ENTMONTH ADD (
    WEEK_DATA VARCHAR2(1000)
);

COMMENT ON COLUMN ENTMONTH.WEEK_DATA IS 'JSON storage for week-level data: cycle, startDate, endDate, workdays, holidays, hours per week';
```

**If you also need the other new columns** (`ACTIVE`, `HOLIDAYS`, `HOURS`) that the POC uses:

```sql
-- Add all new CTRS Calendar columns to ENTMONTH
ALTER TABLE ENTMONTH ADD (
    ACTIVE CHAR(1) DEFAULT 'Y',
    HOLIDAYS NUMBER(2) DEFAULT 0,
    HOURS NUMBER(3),
    WEEK_DATA VARCHAR2(1000)
);
```

**Note:** If 1000 characters feels tight for 5 weeks of JSON data, you could use `VARCHAR2(4000)` instead - that's Oracle's max for VARCHAR2 in standard mode.
