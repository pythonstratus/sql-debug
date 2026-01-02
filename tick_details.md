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



Here's the algorithm we used in the Java implementation:

---

## Algorithm: Parallel Query Execution by Grade Partitioning

### Overview

We partition the workload by **grade value** and execute queries in parallel using a thread pool, then aggregate the results.

### Algorithm Steps

```
1. INITIALIZE
   - Create thread pool (4 threads)
   - Create HikariCP connection pool (10 connections)
   - Load grade values to process [4, 5, 7, 11, 12, 13]

2. PARALLEL EXECUTION
   For each grade IN grades (executed concurrently):
      a. Acquire connection from pool
      b. Execute SQL query with WHERE grade = ?
      c. Map ResultSet rows to CaseRelatedData objects
      d. Return results for that grade
      e. Release connection back to pool

3. AGGREGATION
   - Wait for all threads to complete
   - Combine results from all grades into single list

4. CLEANUP
   - Shutdown thread pool
   - Close connection pool
```

### Key Design Patterns Used

| Pattern | Purpose |
|---------|---------|
| **Thread Pool (ExecutorService)** | Limits concurrent threads, reuses threads |
| **Connection Pool (HikariCP)** | Reuses DB connections, avoids connection overhead |
| **Future/Callable** | Async execution with result retrieval |
| **Data Transfer Object (DTO)** | CaseRelatedData maps 97 columns to Java object |
| **Row Mapper** | ResultSetMapper handles type conversion safely |

### Data Flow

```
┌─────────────────┐
│   App.main()    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│   LimitedQueryExecutor          │
│   executeParallel()             │
└────────┬────────────────────────┘
         │
         ▼
┌────────────────────────────────────────────────────┐
│              ExecutorService (4 threads)           │
├────────────┬────────────┬────────────┬─────────────┤
│  Grade 4   │  Grade 5   │  Grade 7   │  Grade 11   │  ... 
│  Thread-1  │  Thread-2  │  Thread-3  │  Thread-4   │
└─────┬──────┴─────┬──────┴─────┬──────┴──────┬──────┘
      │            │            │             │
      ▼            ▼            ▼             ▼
┌─────────────────────────────────────────────────────┐
│           HikariCP Connection Pool                  │
│           (10 Oracle connections)                   │
└─────────────────────────┬───────────────────────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │  Oracle Database │
                 └─────────────────┘
```

### Why This Approach?

1. **Parallelism** - 6 grades run concurrently instead of sequentially
2. **Resource Control** - Thread pool prevents overwhelming the database
3. **Connection Reuse** - HikariCP eliminates connection setup overhead
4. **Isolation** - Each grade query is independent, no shared state
5. **Fault Tolerance** - One grade failing doesn't stop others

---

Want me to add more detail on any specific part?
