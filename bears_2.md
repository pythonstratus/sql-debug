## BEARS Entitlement Meeting Summary

### Key Takeaways

---

### 1. Entitlement Structure (Simpler Than Expected)

The meeting clarified that **BEARS entitlements are NOT based on ELEVEL**. Instead:

| Entitlement | Environment | Who Gets It |
|-------------|-------------|-------------|
| `ENTITY_DEV` | Development | ALE Developers |
| `ENTITY_TEST` | Test | ALE Developers + CCD Staff |
| `ENTITY_PREPROD` | Pre-Production | Some ALE Developers + All Business Staff |
| `ENTITY_PROD` | Production | Standard Users |
| `ENTITY_PROD_NATIONAL` | Production | National Users (ELEVEL 0) |

**Key Insight:** BEARS just lets users "in the door" — the **application handles data visibility** based on ELEVEL, which is calculated from ICS data (not BEARS).

---

### 2. How It Relates to What We Built

| What We Built | How It Fits |
|---------------|-------------|
| **ELEVEL Calculation** | ✅ Correct approach - ELEVEL comes from ICS data (ICSACC + Title → ENTTITLES → ELEVEL), NOT from BEARS |
| **RBAC Service** | ✅ This is the "application handles data visibility" layer they described |
| **Menu Permissions** | ✅ Application-level control based on ELEVEL |
| **Staff Detection** | ✅ Application-level (ROID prefix 859062) |
| **Multiple Assignments** | ✅ Application-level switching |

**Quote from meeting:** *"E level changes are application-based decisions, not BEARS or entitlement-based. E levels can change daily, so BEARS provisioning cannot be based on E level."*

This validates our approach — the RBAC service we built is exactly what's needed.

---

### 3. Authentication Flow

```
User Request
    ↓
BEARS Entitlement Check (Do they have ENTITY_PROD?)
    ↓
ADFS Authentication (via Active Directory)
    ↓
Application receives SEID from ADFS token
    ↓
RBAC Service determines ELEVEL from ENTEMP (ICS data)
    ↓
Application filters data based on ELEVEL
```

---

### 4. New Requirements Identified

#### A. Inactivity Tracking (120-Day Rule)

| Milestone | Action |
|-----------|--------|
| **120 days inactive** | Disable account in application (user can't log in) |
| **121st day** | Show pop-up: "Account deactivated due to inactivity" |
| **240 days (quarantine)** | Remove from AD group → BEARS removes entitlement |

**Note:** Login resets the 120-day counter (calendar days, not business days).

#### B. Account Reactivation

- Business side needs a "switch" to reactivate disabled accounts
- User needs a way to contact support (in-app message, email, etc.)

#### C. BEARS Sync Service

- Need to build a service to notify BEARS team at milestones (disable, quarantine, delete)
- Goal: Sync real users with who has entitlements to reduce FISMA risk

---

### 5. What's NOT Changing

- **No passwords** in new application (ADFS handles authentication)
- **ICS still provides employee data** nightly (ENTEMP updates)
- **ELEVEL calculation** stays the same (ICS Access Level + Title)

---

## Next Steps & JIRA Tickets

### Immediate Actions (From Meeting)

| Action | Owner | Status |
|--------|-------|--------|
| Fill out BEARS entitlement spreadsheet for 5 entitlements | Team | To Do |
| Submit IR Works ticket for entitlement creation | Team | After spreadsheet |
| Research reading disabled accounts from AD | Team | To Do |

---

### Recommended JIRA Tickets

#### Epic: BEARS Integration & User Lifecycle Management

---

**Ticket 1: ENTITY-XXX**
```
Title: Create BEARS Entitlement Request Forms for 5 Environments

Description:
Complete the BEARS entitlement spreadsheet for the following entitlements:
1. ENTITY_DEV - Development server (ALE developers)
2. ENTITY_TEST - Test environment (ALE developers + CCD staff)
3. ENTITY_PREPROD - Pre-production (ALE developers + business staff)
4. ENTITY_PROD - Production (standard users)
5. ENTITY_PROD_NATIONAL - Production (national users)

Acceptance Criteria:
- [ ] Spreadsheet completed with all 5 entitlements
- [ ] Reviewed by BEARS team (Alia)
- [ ] IR Works ticket submitted
- [ ] Entitlements created by MSOT

Priority: High
Labels: bears, security, infrastructure
```

---

**Ticket 2: ENTITY-XXX**
```
Title: Implement User Inactivity Tracking Service

Description:
Build a service to track user login activity and enforce the 120-day inactivity rule.

Requirements:
- Track last login date for each user (ENTEMP.LASTLOGIN or new field)
- Calculate days since last login (calendar days)
- Reset counter on any successful login
- Flag users approaching 120 days (e.g., at 100, 110, 115 days)

Technical Notes:
- Consider scheduled job to run daily
- Store inactivity status in ENTITY_USER table

Acceptance Criteria:
- [ ] Last login date tracked for all users
- [ ] Days since login calculated correctly
- [ ] Service can identify users at risk of deactivation

Priority: Medium
Labels: security, user-management
```

---

**Ticket 3: ENTITY-XXX**
```
Title: Implement 120-Day Account Disable Functionality

Description:
Automatically disable user accounts after 120 days of inactivity.

Requirements:
- Scheduled job to check inactivity daily
- Disable accounts that hit 120 days (set ISLOCKED = 'Y' or similar)
- Do NOT remove from AD group at this stage
- Log all disable actions for audit

Acceptance Criteria:
- [ ] Accounts automatically disabled at 120 days
- [ ] Disabled users cannot access application
- [ ] Audit log captures disable events
- [ ] Does not affect BEARS entitlement

Priority: Medium
Labels: security, user-management
Blocked By: ENTITY-XXX (Inactivity Tracking)
```

---

**Ticket 4: ENTITY-XXX**
```
Title: Build Account Deactivation Notification UI

Description:
Display a message to users whose accounts have been deactivated due to inactivity.

Requirements:
- On 121st day (first login attempt after disable), show pop-up/message
- Message: "Your account has been deactivated due to inactivity"
- Provide instructions to contact support for reactivation
- Include support contact info (email, phone, or in-app request)

Acceptance Criteria:
- [ ] Deactivated users see clear notification
- [ ] Contact information displayed
- [ ] User cannot proceed until account is reactivated

Priority: Medium
Labels: ui, security, user-management
Blocked By: ENTITY-XXX (120-Day Disable)
```

---

**Ticket 5: ENTITY-XXX**
```
Title: Build Account Reactivation Admin Function

Description:
Provide CCD staff/admins with ability to reactivate disabled accounts.

Requirements:
- Admin UI or API endpoint to reactivate accounts
- Reset inactivity counter upon reactivation
- Log all reactivation actions for audit
- Require admin role (CCD staff)

Acceptance Criteria:
- [ ] Admins can reactivate disabled accounts
- [ ] Inactivity counter resets to 0
- [ ] Audit log captures reactivation events
- [ ] Only authorized admins can perform action

Priority: Medium
Labels: admin, security, user-management
```

---

**Ticket 6: ENTITY-XXX**
```
Title: Implement 240-Day Quarantine & AD Group Removal

Description:
After 240 days of inactivity (120 disabled + 120 quarantine), remove user from AD group to trigger BEARS entitlement removal.

Requirements:
- Track quarantine period (days since disable)
- At 240 days total, trigger AD group removal
- Build service to write to AD or notify BEARS team
- Coordinate with BEARS team on integration method

Technical Notes:
- Need to research: Can we write directly to AD group?
- Alternative: Send notification to BEARS team to manually remove
- Susan (BEARS) can provide guidelines on federation/integration

Acceptance Criteria:
- [ ] Users removed from AD group at 240 days
- [ ] BEARS entitlement automatically removed
- [ ] Audit log captures removal events
- [ ] Integration method confirmed with BEARS team

Priority: Low (Phase 2)
Labels: security, bears, integration
Blocked By: ENTITY-XXX (120-Day Disable), Research on AD integration
```

---

**Ticket 7: ENTITY-XXX**
```
Title: Research AD Integration for Disabled Account Sync

Description:
Research how to sync disabled accounts with Active Directory/BEARS.

Questions to Answer:
1. Can we read disabled accounts from AD?
2. Can we write to AD to remove users from group?
3. What is the federation approach Susan mentioned?
4. What tokens/parameters need to pass to BEARS (SEID, employee ID, email)?

Contacts:
- Susan (BEARS team) - federation guidelines
- Eric - AD integration

Deliverable:
- Technical recommendation document
- Integration approach decision

Priority: High
Labels: research, bears, integration
```

---

**Ticket 8: ENTITY-XXX**
```
Title: Add Warning Notifications Before Account Disable

Description:
Send alerts to users before their accounts are disabled due to inactivity (similar to ICS).

Requirements:
- Send warning at configurable intervals (e.g., 100, 110, 115 days)
- Notification method: Email and/or in-app notification
- Message should explain how to prevent disable (just log in)

Acceptance Criteria:
- [ ] Users receive warnings before 120-day disable
- [ ] Warning intervals are configurable
- [ ] Notifications sent via email or in-app

Priority: Low
Labels: notifications, user-management
```

---

**Ticket 9: ENTITY-XXX**
```
Title: Integrate RBAC Service with ADFS Authentication

Description:
Connect the RBAC service to receive user identity from ADFS token after BEARS authentication.

Requirements:
- Extract SEID from ADFS token
- Call RBAC service to get user's ELEVEL and permissions
- Handle case where user has BEARS entitlement but no ENTEMP record

Technical Notes:
- ADFS token may contain: SEID, employee ID, email address
- ECP can connect to Active Directory

Acceptance Criteria:
- [ ] SEID extracted from ADFS token
- [ ] RBAC service called on each authenticated request
- [ ] Graceful handling of missing ENTEMP records

Priority: High
Labels: authentication, integration, rbac
```

---

**Ticket 10: ENTITY-XXX**
```
Title: Deploy RBAC Service to ECP Dev Environment

Description:
Work with Chinmaya to deploy the RBAC service to ECP Dev for testing.

Requirements:
- Configure Oracle connection to ENTITYDEV schema
- Set up Swagger UI for testing
- Verify service connects to real data
- Test with multiple SEIDs at different ELEVELs

Acceptance Criteria:
- [ ] RBAC service deployed to ECP Dev
- [ ] Swagger UI accessible
- [ ] Service returns correct data from Oracle
- [ ] Demo HTML dashboard functional

Priority: High
Labels: deployment, infrastructure
Assignee: Chinmaya
```

---

**Ticket 11: ENTITY-XXX**
```
Title: Integrate RBAC Service with entity-service

Description:
Work with Bryan Abbe to integrate the RBAC service with the main entity-service application.

Requirements:
- Define integration points (REST calls vs. shared library)
- Implement authorization checks in entity-service
- Ensure menu visibility follows RBAC rules
- Ensure data access follows ELEVEL scoping

Acceptance Criteria:
- [ ] entity-service calls RBAC for authorization decisions
- [ ] Menu items filtered based on ELEVEL
- [ ] Data queries scoped by Area/POD per ELEVEL

Priority: High
Labels: integration, rbac
Blocked By: ENTITY-XXX (ECP Dev Deployment)
Assignee: Bryan Abbe
```

---

## Summary

### What We Built ✅
- RBAC Service with ELEVEL-based authorization
- This is exactly what the meeting confirmed: "application handles data visibility"

### What's New from Meeting
- Only 5 BEARS entitlements (by environment, not ELEVEL)
- 120-day inactivity tracking required
- 240-day quarantine with AD group removal
- Need to sync with BEARS for FISMA compliance

### Immediate Priorities
1. Fill out BEARS entitlement spreadsheet
2. Deploy RBAC to ECP Dev (Chinmaya)
3. Integrate with entity-service (Bryan Abbe)
4. Research AD integration for user sync
