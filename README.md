# 🚚 SwiftChain Logistics — Supply Chain Delivery Intelligence System

## 📌 Project Overview
SwiftChain Logistics Inc. is a US-based third-party logistics company 
managing 436K shipments across 200 routes, 10 warehouses, and 5 carrier 
partners. Their on-time delivery rate had dropped to 48.87% — far below 
the industry benchmark of 85%. This project identifies the root causes 
of delivery delays and provides actionable recommendations through 
Python EDA, SQL analysis, and a Power BI dashboard.

---

## 🔗 Live Dashboard
👉 [View Power BI Dashboard](https://app.powerbi.com/links/xdgzc432vK?ctid=035ddef6-2433-48b6-8526-70ca8181f76d&pbi_source=linkShare)

---

## 🛠️ Tools Used
| Tool | Purpose |
|------|---------|
| Python (Pandas, Matplotlib, Seaborn) | Data cleaning and EDA |
| MySQL | KPI queries and SQL analysis |
| Power BI | Interactive 3-page dashboard |
| DAX | Custom measures and KPIs |
| Git & GitHub | Version control |

---

## 📊 Dashboard Pages
### Page 1 — Executive Summary
- On-Time Delivery Rate, Total Orders, Shipping Cost, Avg Delay Days
- Monthly delay trends showing Nov-Dec spike
- Carrier performance comparison
- Bottom routes and product categories

### Page 2 — Carrier and Routes
- Top 5 worst and best performing routes
- Carrier on-time rate comparison
- Avg delay days by carrier
- Ship mode performance

### Page 3 — Warehouse and Root Cause
- Worst and best performing warehouses
- $1.7bn order value at risk
- Weather and traffic impact on delays
- Detailed warehouse performance table

---

## 🔍 Key Findings
- ❌ On-time rate is **48.87%** vs **85%** industry benchmark
- 🚛 **DHL** is the worst carrier at only **36.94%** on-time rate
- 🏭 **WH-002, WH-008, WH-005** are responsible for majority of severe delays
- 💰 **$1.7 billion** order value is at risk due to delays
- 📅 **November and December** have 60% higher delay rates than rest of year
- 🌧️ **Storm weather** adds average 5 extra delay days
- 💊 **Pharmaceuticals and Electronics** have the highest delay rates
- 🛣️ **RT-0109** is the worst performing route at 32.51% on-time rate

---

## 💡 Recommendations
- **DHL contract review** — renegotiate SLA or replace with better carrier
- **WH-002, WH-005, WH-008 process overhaul** — investigate staffing and processes
- **Q4 capacity planning** — increase resources in November and December
- **Weather-based routing** — avoid storm-prone routes during bad weather
- **Priority handling** — SLA upgrades for Pharmaceuticals and Electronics
- **Route optimization** — retire or redesign the 20 worst performing routes

---

## 📁 Project Structure

SwiftChain-Supply-Chain-Analysis/
│
├── data/
│   └── Cleaned_data_supply_chain.csv
│
├── python/
│   └── swiftchain_eda.ipynb
│
├── sql/
│   └── swiftchain_sql_analysis.sql
│
├── powerbi/
│   └── supplychain.pbix
│
├── screenshots/
│   ├── page1_summary.png
│   ├── page2_carrier_routes.png
│   └── page3_warehouse.png
│
└── README.md


---

## 📸 Dashboard Screenshots
### Page 1 — Executive Summary
![Page 1](screenshots/page1_summary.png)

### Page 2 — Carrier and Routes
![Page 2](screenshots/page2_carrier_routes.png)

### Page 3 — Warehouse and Root Cause
![Page 3](screenshots/page3_warehouse.png)

---

## 👤 Author
**Chandu**
- GitHub: [@Chandu951513](https://github.com/Chandu951513)

---

## 📃 License
This project is for portfolio and educational purposes only.
SwiftChain Logistics Inc. is a fictional company created for this analysis.
