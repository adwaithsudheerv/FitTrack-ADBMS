import sqlite3

conn = sqlite3.connect('FitTrack_ADBMS_Project/05_Web_Application/fittrack.db')
c = conn.cursor()
tables = [r[0] for r in c.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'").fetchall()]
print(f"Total tables: {len(tables)}")
for t in sorted(tables):
    count = c.execute(f"SELECT COUNT(*) FROM {t}").fetchone()[0]
    print(f"  - {t:<26} : {count} rows")
conn.close()
