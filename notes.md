Here are detailed descriptions for each JIRA ticket:

---

## ✅ Fully Implemented Stories

### EN-1088: Filter WTV
**Description:**
Implement a search filter for Assignment Numbers on the Weekly Time View main screen.

**Acceptance Criteria:**
- Text input field allows users to search by Assignment Number
- Filter applies with debounced input (300ms delay) to prevent excessive API calls
- Partial matching supported (e.g., "2101" matches "21012901", "21012902", etc.)
- Filter clears when input is emptied
- Results update automatically without requiring a button click

**Technical Implementation:**
- Frontend: PrimeReact InputText component with onChange handler
- Backend: `GET /api/wtv/summaries?payPeriodId={id}&assignmentNumber={filter}`
- Repository: JPQL LIKE query for partial matching

---

### EN-1089: Select Report Month
**Description:**
Implement a dropdown selector for choosing the reporting month on the Weekly Time View.

**Acceptance Criteria:**
- Dropdown displays available reporting months in "Month Year" format (e.g., "March 2024")
- Months ordered in reverse chronological order (most recent first)
- Selecting a month loads the associated weeks into the Week dropdown
- Default selection is the most recent reporting month

**Technical Implementation:**
- Frontend: PrimeReact Dropdown component
- Backend: `GET /api/wtv/reporting-months` returns grouped pay periods by month/year
- Response includes nested weeks for each month

---

### EN-1090: Week Selection
**Description:**
Implement a dropdown selector for choosing the specific week within a reporting month.

**Acceptance Criteria:**
- Dropdown displays weeks in "PP{number} Week {number} ({startDate} - {endDate})" format
- Week options update when reporting month changes
- Selecting a week loads the corresponding weekly time summaries
- Default selection is the first week of the selected month

**Technical Implementation:**
- Frontend: PrimeReact Dropdown populated from selected month's weeks array
- Backend: Week data included in reporting months response
- Pay period ID used for subsequent data queries

---

### EN-1091: Previous + Next Buttons
**Description:**
Implement navigation buttons to move between consecutive weeks.

**Acceptance Criteria:**
- "Previous Week" button navigates to the prior pay period week
- "Next Week" button navigates to the following pay period week
- Buttons are disabled when at the first/last available week
- Navigation updates both the week dropdown selection and displayed data
- Week range label updates to reflect current selection

**Technical Implementation:**
- Frontend: PrimeReact Button components with navigation logic
- Backend: `GET /api/wtv/pay-periods/{id}/previous` and `/next` endpoints
- Returns null when no previous/next period exists

---

### EN-1092: Table Showing Group Assignments
**Description:**
Implement the main data table displaying weekly time summaries for all assignments in the selected pay period.

**Acceptance Criteria:**
- Table displays columns: Assignment #, Tour of Duty Hours, Adjusted Tour, Hours Worked, Case Direct Time, Code Direct Time, Overhead Time, Report Days, Tour of Duty Type, Last Date EOD
- Data loads automatically when pay period is selected
- Table supports sorting by column headers
- Numeric values formatted to 2 decimal places
- Alternating row striping for readability
- Assignment # column is clickable for drill-down

**Technical Implementation:**
- Frontend: PrimeReact DataTable with Column components
- Backend: `GET /api/wtv/summaries?payPeriodId={id}`
- DTO: WeeklyTimeSummaryDTO with all required fields

---

### EN-1093: Click Through to Detailed Timesheet View
**Description:**
Enable drill-down navigation from the group view to individual employee timesheet details.

**Acceptance Criteria:**
- Clicking an Assignment # in the main table navigates to the detail view
- Detail view receives assignment number and pay period ID as parameters
- Back navigation returns to the group view with previous state preserved
- URL is bookmarkable (e.g., `/employee/21012901/4`)

**Technical Implementation:**
- Frontend: React Router with useNavigate and useParams hooks
- Route: `/employee/:assignmentNumber/:payPeriodId`
- Assignment # column rendered as clickable link

---

### EN-1094: Export Weekly Hours
**Description:**
Implement CSV export functionality for the group-level weekly time summaries.

**Acceptance Criteria:**
- "Export CSV" button downloads current filtered data
- CSV includes header row with column names
- CSV includes metadata (pay period, week range)
- Filename format: `weekly_time_summary_{payPeriod}_{date}.csv`
- Export respects current filter (assignment number search)

**Technical Implementation:**
- Frontend: Button triggers download via API
- Backend: `GET /api/wtv/export/group?payPeriodId={id}&assignmentNumber={filter}`
- Response: text/csv with Content-Disposition header

---

### EN-1095: Employee Detail Page (Top Table)
**Description:**
Implement the Daily Summary table on the employee detail view showing daily hours breakdown.

**Acceptance Criteria:**
- Table displays rows: Tour, Holiday, Credit Hours Used, Worked
- Columns: Row label + Sunday through Saturday (with M/d date format)
- Final column shows weekly Total
- Zero values displayed as empty cells for readability
- Totals row highlighted with bold formatting

**Technical Implementation:**
- Frontend: PrimeReact DataTable with dynamic day columns
- Backend: Daily entries included in employee timesheet response
- Date headers generated from pay period start/end dates

---

### EN-1096: Employee Detail Page (Middle Table)
**Description:**
Implement the Case Time table showing hours worked on each case/TIN.

**Acceptance Criteria:**
- Table displays columns: TIN, Taxpayer Name, Sunday-Saturday hours, Total
- One row per case worked during the week
- Totals row at bottom sums all case hours by day
- TIN formatted consistently (XXX-XX-XXXX or XX-XXXXXXX)
- Sorted by TIN

**Technical Implementation:**
- Frontend: PrimeReact DataTable with computed totals row
- Backend: Case time entries included in employee timesheet response
- Repository: Ordered by case_tin

---

### EN-1097: Employee Detail Page (Bottom Table)
**Description:**
Implement the Non-Case Time table showing hours by time code.

**Acceptance Criteria:**
- Table displays columns: Time Code, Sunday-Saturday hours, Total
- One row per time code used during the week
- Totals row at bottom sums all non-case hours by day
- Time code descriptions displayed (e.g., "ABCD - ADP SUPPORT")
- Sorted by time code

**Technical Implementation:**
- Frontend: PrimeReact DataTable with computed totals row
- Backend: Non-case time entries with time code details
- Repository: JOIN FETCH on TimeCode entity

---

### EN-1098: Buttons On Employee Detail Page
**Description:**
Implement navigation and action buttons on the employee detail view.

**Acceptance Criteria:**
- "Back to Group View" link/button returns to main table
- "Export Individual CSV" button exports current employee's timesheet
- Buttons positioned consistently with UI mockups
- Back navigation preserves previous month/week selection

**Technical Implementation:**
- Frontend: React Router navigation, PrimeReact Button
- Back link uses navigate(-1) or explicit route
- Export button triggers individual CSV download

---

### EN-1099: Export Individual Timesheet
**Description:**
Implement CSV export functionality for individual employee timesheets.

**Acceptance Criteria:**
- Export includes employee name, assignment number, week range
- Export includes all three tables (Daily Summary, Case Time, Non-Case Time)
- Sections clearly labeled in CSV
- Filename format: `timesheet_{assignmentNumber}_{date}.csv`

**Technical Implementation:**
- Frontend: Button triggers download via API
- Backend: `GET /api/wtv/export/individual?assignmentNumber={num}&payPeriodId={id}`
- Response: text/csv with structured sections

---

### EN-1102: WTV Endpoint for Assignment Number
**Description:**
Implement REST API endpoint for retrieving assignment information.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/assignments/{assignmentNumber}`
- Returns assignment details (number, employee name, SEID, org, area, pod)
- Returns 404 if assignment not found
- Supports partial matching via query parameter

**Technical Implementation:**
- Controller: WtvController with @GetMapping
- Service: AssignmentService lookup
- Repository: JpaRepository with custom query methods

---

### EN-1103: WTV Reporting Month Endpoint
**Description:**
Implement REST API endpoint for retrieving available reporting months.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/reporting-months`
- Returns list of months with nested weeks
- Ordered by most recent first
- Each week includes: id, payPeriodNumber, weekNumber, startDate, endDate, weekRange label
- Response cached for performance

**Technical Implementation:**
- Controller: WtvController
- Service: Groups pay periods by month/year
- Caching: @Cacheable("reportingMonths")

---

### EN-1104: WTV Group-Level Endpoint
**Description:**
Implement REST API endpoint for retrieving group weekly time summaries.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/summaries?payPeriodId={id}&assignmentNumber={filter}`
- Returns list of WeeklyTimeSummaryDTO
- Optional assignmentNumber filter for partial matching
- Includes all fields needed for main table display
- Ordered by assignment number

**Technical Implementation:**
- Controller: WtvController with @RequestParam
- Service: WtvService with conditional filtering
- Repository: JPQL with JOIN FETCH for eager loading

---

### EN-1105: WTV Employee-Level Timesheet Endpoint
**Description:**
Implement REST API endpoint for retrieving individual employee timesheet details.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/employees/{assignmentNumber}/timesheet?payPeriodId={id}`
- Returns EmployeeTimesheetDTO with all three table datasets
- Includes daily entries, case time entries, non-case time entries
- Returns 404 if no data found for assignment/period combination
- Day headers dynamically generated from pay period dates

**Technical Implementation:**
- Controller: WtvController with @PathVariable and @RequestParam
- Service: Aggregates data from multiple repositories
- DTO: Nested structure with lists for each table type

---

### EN-1106: WTV Group Timesheet Export Endpoint
**Description:**
Implement REST API endpoint for exporting group weekly summaries to CSV.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/export/group?payPeriodId={id}&assignmentNumber={filter}`
- Returns CSV file with Content-Type: text/csv
- Includes metadata header (pay period, week range)
- Respects assignment number filter if provided
- Triggers browser download

**Technical Implementation:**
- Controller: Returns ResponseEntity with CSV content
- Service: Builds CSV string from summary data
- Headers: Content-Disposition: attachment; filename="..."

---

### EN-1107: WTV Export Individual Timesheet Endpoint
**Description:**
Implement REST API endpoint for exporting individual employee timesheet to CSV.

**Acceptance Criteria:**
- Endpoint: `GET /api/wtv/export/individual?assignmentNumber={num}&payPeriodId={id}`
- Returns CSV with all three timesheet sections
- Sections labeled: "Daily Summary", "Case Time", "Non-Case Time"
- Includes employee info header
- Returns 404 if no data found

**Technical Implementation:**
- Controller: Returns ResponseEntity with CSV content
- Service: Builds structured CSV with section headers
- Reuses getEmployeeTimesheet for data retrieval

---

### EN-329: Weekly Time Verification - UI
**Description:**
Implement the complete user interface for the Weekly Time Verification feature.

**Acceptance Criteria:**
- Main group view matches UI mockups (filters, table, navigation)
- Employee detail view matches UI mockups (three tables, header info)
- Responsive layout adapts to screen size
- Loading indicators during data fetch
- Error handling with user-friendly messages
- Consistent styling with ENTITY-UI-DEV patterns

**Technical Implementation:**
- Framework: React 18 with React Router 6
- Components: PrimeReact (DataTable, Dropdown, Button, Card, InputText)
- Styling: Custom CSS matching existing ENTITY patterns
- State Management: React hooks (useState, useEffect, useCallback)

---

## ⚠️ Simplified/Stubbed for POC

### EN-1100: Accessibility in WTV
**Description:**
Implement basic accessibility features for the Weekly Time View.

**POC Implementation:**
- Semantic HTML elements (header, main, nav, table)
- ARIA labels on interactive elements
- Keyboard navigation support via PrimeReact defaults
- Form labels associated with inputs

**Future Enhancements:**
- Full screen reader testing
- Focus management on navigation
- Skip links
- High contrast mode support

---

### EN-1101: WTV 508 Compliance
**Description:**
Ensure Weekly Time View meets Section 508 accessibility standards.

**POC Implementation:**
- Basic WCAG 2.1 Level A compliance
- Color contrast meets minimum ratios
- Text resizing supported
- No content conveyed by color alone

**Future Enhancements:**
- Full 508 audit with compliance documentation
- Remediation of any identified issues
- VPAT documentation

---

### EN-1108: Error Logging for ALL Endpoints
**Description:**
Implement comprehensive error logging across all WTV endpoints.

**POC Implementation:**
- @Slf4j annotation on all service and controller classes
- Basic log.debug for method entry/parameters
- log.warn for expected errors (not found)
- log.error for unexpected exceptions
- GlobalExceptionHandler logs all exceptions

**Future Enhancements:**
- Structured logging (JSON format)
- Correlation IDs for request tracing
- Integration with centralized logging (ELK/Splunk)
- Log level configuration per environment

---

### EN-1109: User Authentication
**Description:**
Implement user authentication for the Weekly Time View.

**POC Implementation:**
- No authentication (open access for demo purposes)
- CORS configured to allow all origins
- Prepared for future security integration

**Future Enhancements:**
- Integration with agency SSO/SAML
- JWT token validation
- Role-based access control
- Session management

---

### EN-1110: Logging Access + Export Actions
**Description:**
Implement audit logging for data access and export actions.

**POC Implementation:**
- Basic logging of export requests with assignment/period info
- Log entries include timestamp and action type
- Service-level logging for data retrieval

**Future Enhancements:**
- Dedicated audit log table
- User identification in audit records
- Export tracking with download counts
- Compliance reporting capabilities

---

### EN-1111: WTV Caching
**Description:**
Implement caching to improve performance of frequently accessed data.

**POC Implementation:**
- Spring @Cacheable on reporting months endpoint
- ConcurrentMapCache for simple in-memory caching
- Cache configuration in CacheConfig.java

**Future Enhancements:**
- Redis/Hazelcast for distributed caching
- Cache TTL configuration
- Cache invalidation strategies
- Cache metrics and monitoring

---

### EN-769: EA – Weekly Time Verification
**Description:**
Enterprise Architecture documentation for the Weekly Time Verification feature.

**POC Implementation:**
- Spring Boot 3.2.5 / Java 17 backend architecture
- React 18 frontend with PrimeReact components
- RESTful API design with OpenAPI/Swagger documentation
- Docker containerization for deployment
- H2 in-memory database for POC (Oracle-ready)

**Architecture Artifacts:**
- Data model with 6 core entities
- API specification (10 endpoints)
- Component diagram
- Deployment architecture (Docker Compose)

---

## 📝 POC Database Strategy Note

**Ticket Note: H2 Database Approach for POC**

**Why H2 for POC Development:**

1. **Rapid Iteration:** H2 in-memory database allows immediate testing without Oracle infrastructure dependencies, enabling faster development cycles and quicker feedback on UI/API changes.

2. **Schema Validation:** The POC schema (schema.sql) serves as a working specification for the data model. All entity relationships, column types, and constraints are validated through actual runtime execution.

3. **Realistic Data Patterns:** The synthetic data (data.sql) with 100 assignments across 24 pay periods demonstrates real-world data volumes and relationships, helping identify performance considerations early.

4. **API Contract Definition:** With working endpoints against H2, the API contracts are fully defined and tested. Frontend integration is complete and proven.

5. **Zero Infrastructure Overhead:** Developers can run the complete stack locally via Docker without VPN, database credentials, or network access to Oracle environments.

**Transition to Oracle:**

When actual Oracle tables are identified, the migration path is straightforward:

1. **Update application.yml:** Switch datasource from H2 to Oracle JDBC connection
2. **Map Entities:** Update @Table annotations to reference actual Oracle table/schema names
3. **Adjust Queries:** Modify repository queries if column names or join paths differ
4. **Remove schema.sql/data.sql:** Oracle schema already exists; no DDL needed

The JPA/Hibernate abstraction layer means service logic and API contracts remain unchanged. Only the data access layer adapts to production table structures.

**What We Need from Samuel:**
- Table names for weekly time summary data
- Table names for daily time entries
- Table names for case time and non-case time entries
- Join columns between these tables
- Any views that aggregate this data

---

Want me to adjust the level of detail or format for any of these?
