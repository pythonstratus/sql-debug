Yes, that's a great debugging approach! The fact that you're getting errors with just `SELECT ROID, SEID, TIN FROM main_data` tells us the problem is **inside the CTEs or JOINs**, not in the final SELECT columns.

**ORA-12801** is a parallel query error that wraps another error (ORA-01722 in your case). The root cause is still the invalid number conversion.

**The problem must be in one of these places:**

1. **filtered_timetin CTE** (lines 3-9)
2. **entmod_eligible CTE** (lines 12-20)
3. **The JOIN conditions or WHERE clause** (lines 191-230)
4. **The columns being selected in main_data** that are evaluated even if not in final SELECT

**Let's isolate it step by step. Try these queries one at a time:**

**Test 1 - Just filtered_timetin:**
```sql
SELECT * FROM (
    SELECT tt.*
    FROM TIMETIN tt
    WHERE tt.RPTDT > TO_DATE('01/01/1900', 'mm/dd/yyyy')
      AND case_org(tt.roid) = 'CF'
) WHERE ROWNUM <= 10;
```

**Test 2 - Just the base joins (no calculated columns):**
```sql
SELECT a.TINSID, tt.ROID, b.TINSID
FROM ENT a
INNER JOIN TIMETIN tt ON a.TINSID = tt.TIMESID
INNER JOIN TRANTRAIL b ON a.TINSID = b.TINSID
WHERE tt.RPTDT > TO_DATE('01/01/1900', 'mm/dd/yyyy')
  AND case_org(tt.roid) = 'CF'
  AND a.grade = :grade
  AND ROWNUM <= 10;
```

**Test 3 - Add the table function:**
```sql
SELECT a.TINSID, tt.ROID, b.TINSID, c.IND_941
FROM ENT a
INNER JOIN TIMETIN tt ON a.TINSID = tt.TIMESID
INNER JOIN TRANTRAIL b ON a.TINSID = b.TINSID
CROSS APPLY TABLE(mft_ind_vals(b.tinsid, a.tinfs)) c
WHERE tt.RPTDT > TO_DATE('01/01/1900', 'mm/dd/yyyy')
  AND case_org(tt.roid) = 'CF'
  AND a.grade = :grade
  AND ROWNUM <= 10;
```

Which test fails? This will tell us exactly where the ORA-01722 is coming from.
