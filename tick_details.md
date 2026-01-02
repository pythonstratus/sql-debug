Here's a JIRA ticket summary you can use:

---

## Summary

Refactor Tviewcaserelated query implementation into entity-service

## Description

We have developed and tested an optimized version of the Tviewcaserelated SQL query that resolves previous performance and error issues. This query has been validated for grades 11 and 13 and is ready to be integrated into the main entity-service.

## What Was Done

- Converted scalar subqueries to JOINs (SEID, TOUR, SELCODE)
- Replaced correlated EXISTS with LEFT JOIN for entmod eligibility check
- Added CTEs (filtered_timetin, entmod_eligible) to pre-filter data and reduce table scans
- Fixed ORA-00918 (column ambiguity) by adding explicit table aliases to all columns
- Fixed ORA-17004 (invalid column type) by handling mixed-type columns from CASE/DECODE expressions

## Testing Completed

- Grades 11 and 13 tested successfully
- Query executes without ORA errors
- Results verified against expected output

## Attachments

- Optimized SQL query (Tviewcaserelated_v2.sql)
- Java test executor code (for reference implementation)
- ResultSetMapper with safe type handling for mixed-type columns

## Acceptance Criteria

- [ ] Integrate optimized query into entity-service
- [ ] Handle ASSNQUE column as String (returns DATE or VARCHAR depending on CASE branch)
- [ ] Use safe BigDecimal conversion for columns that may return mixed types
- [ ] Test all grades (4, 5, 7, 11, 12, 13)
- [ ] Verify React UI displays results correctly

---

Want me to adjust the wording or add/remove anything?
