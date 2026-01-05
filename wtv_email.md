

---

**Subject:** WTV Web Service Framework Progress & Request for Database Table Guidance

Hi ,

I wanted to give you a quick update on the Weekly Time View (WTV) web service framework and request your help with the database layer.

**Progress So Far:**

We've built out a working POC that includes:
- Spring Boot backend with REST APIs for the group weekly summary view and individual employee timesheet drill-down
- React frontend with PrimeReact components matching the UI mockups
- Full Docker containerization for easy deployment
- Sample data demonstrating the complete flow

The framework is functional end-to-end with synthetic data, so we're now ready to connect to the actual database tables.

**Request:**

Could you point us to the tables (and any necessary joins) that would populate the following fields?

*Main Group View:*
- Assignment #, Tour of Duty Hours, Adjusted Tour, Hours Worked, Case Direct Time, Code Direct Time, Overhead Time, Report Days, Tour of Duty Type, Last Date EOD

*Employee Detail View:*
- Daily Summary (Tour, Holiday, Credit Hours Used, Worked by day)
- Case Time (TIN, Taxpayer Name, hours by day)
- Non-Case Time (Time Code, hours by day)

Even just the table names and key join columns would be enough to get us started.

I'll share the screenshots and Justinmind link separately so you can see exactly what we're building.

Thanks!

---

