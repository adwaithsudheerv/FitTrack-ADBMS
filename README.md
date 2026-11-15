# FitTrack Pro — Enterprise Smart Gym Management System
### Advanced Database Management Systems (ADBMS) Course Platform

An enterprise-grade, full-stack fitness and gym management platform developed for the ADBMS Course Lab Project (3-member team topic: **FitTrack: Smart Gym Management System**).

The project comprehensively satisfies all **9 Course Deliverables** and **12 Syllabus Tasks**, featuring a black & crimson red luxury glassmorphic interface, zero emojis, full relational normalization (3NF/BCNF), automated multi-table transactions, PL/SQL stored procedures, Object-Relational extensions, JSON/XML semi-structured querying, and 100% automated test verification.

---

## 🚀 Live Demo & Repository
- **GitHub Repository**: [https://github.com/adwaithsudheerv/FitTrack-ADBMS](https://github.com/adwaithsudheerv/FitTrack-ADBMS)
- **Primary Tech Stack**: Python 3.13, FastAPI, SQLite / Oracle SQL / PostgreSQL DDL, Chart.js, HTML5/CSS3 Glassmorphism

---

## 📋 Course Deliverables & Syllabus Task Registry

All project files are indexed directly in the database table `new_fittrack_adbms_support_file` and accessible in the live application console:

| Deliverable No. | Lab Deliverable Title | Task / Module Mapping | Source File Path |
|:---:|:---|:---|:---|
| **1** | Problem definition and project objectives | Problem Statement & Team Roles | `01_Design_and_Schema/01_Problem_Statement_and_Objectives.md` |
| **2** | ER diagram and relational schema | 24-Table DDL & Constraints | `02_Database_Scripts/schema_ddl.sql` |
| **2** | ER diagram and relational schema | Mermaid ER & Normalization Proof | `01_Design_and_Schema/02_ER_Diagram_and_Relational_Schema.md` |
| **3** | SQL query implementation document | 10 Seed Records per Table | `02_Database_Scripts/mock_data_dml.sql` |
| **3** | SQL query implementation document | Tasks 1–5: Queries, Joins, CTEs, Views | `02_Database_Scripts/tasks_01_to_05_queries.sql` |
| **4** | PL/SQL programs & stored procedures | Task 6: Procedures & Functions | `03_PLSQL_and_Advanced_DB/task_06_plsql_procedures_functions.sql` |
| **4** | PL/SQL programs & stored procedures | Task 7: User/System Exception Handling | `03_PLSQL_and_Advanced_DB/task_07_exception_handling.sql` |
| **4** | PL/SQL programs & stored procedures | Tasks 8–9: ORDBMS Types & Inheritance | `03_PLSQL_and_Advanced_DB/task_08_object_relational.sql` |
| **5** | JSON and XML implementation scripts | Tasks 10–12: JSON Path, XML, XSD, DTD | `04_JSON_and_XML/task_10_json_operations.sql` |
| **6** | Python application source code | FastAPI Full-Stack Engine | `05_Web_Application/app.py` & `main.py` |
| **7** | Test cases and test results | 25 Test Matrix (100% Pass Runner) | `06_Test_Cases_and_Results/test_cases.md` & `run_tests.py` |
| **8** | Screenshots of application modules | UI Evaluation Screenshots Guide | `07_Documentation_and_Report/Module_Walkthrough_and_Screenshots_Guide.md` |
| **9** | Complete project report | Comprehensive Master Report | `07_Documentation_and_Report/FitTrack_ADBMS_Final_Project_Report.md` |

---

## 🛠️ Application Modules & Features
1. **Executive Analytics Dashboard**: Gross revenue tracking, active subscriptions count, trainer utilization metrics, and multi-location performance.
2. **Member Onboarding & Directory**: Auto-calculating BMI engine, contact validation, medical records in JSON format.
3. **Membership Packages & Atomic Checkout**: Dynamic plan selection with 18% GST calculation, coupon discounts, and instant invoice emission.
4. **Class Reservations**: Real-time capacity validation preventing double-booking and automated seat decrementing/restoration.
5. **Trainer Management & Reviews**: Trainer ratings, hourly rates, and feedback auditing.
6. **Branch Equipment Inventory**: Operational condition tracking and maintenance workflow.
7. **Billing & Invoices**: Official GST invoice generator and dispute/refund management.
8. **ADBMS Task Evaluator Console**: Live SQL execution terminal with preloaded queries for all 12 course tasks and 1-click CSV export.

---

## ⚡ Local Setup

```powershell
# Clone the repository
git clone https://github.com/adwaithsudheerv/FitTrack-ADBMS.git
cd FitTrack-ADBMS

# Install dependencies
pip install -r requirements.txt

# Run the platform
python main.py
```
Open **`http://localhost:8000`** in any web browser.

---

## 🌐 Deploy to Render

1. Log in to [dashboard.render.com](https://dashboard.render.com).
2. Click **New +** → **Web Service**.
3. Select **Public Git Repository** and enter:
   ```
   https://github.com/adwaithsudheerv/FitTrack-ADBMS
   ```
4. Configure service parameters:
   - **Runtime**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `python main.py`
5. Click **Create Web Service**. Render will deploy the application on a public URL.

---

## 🧪 Test Execution
Run the automated test suite verifying all schema constraints, transactions, and advanced queries:
```powershell
python FitTrack_ADBMS_Project/06_Test_Cases_and_Results/run_tests.py
```
*Result: 16/16 Passed (100% Success Rate).*
