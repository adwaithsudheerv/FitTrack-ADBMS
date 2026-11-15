"""
FitTrack: Smart Gym Management System
TASK 11: XML Operations - XPath, XQuery-like Extractions & Schema Operations
"""

import xml.etree.ElementTree as ET
import os

XML_PATH = os.path.join(os.path.dirname(__file__), "member_order.xml")

def run_xml_tasks():
    print("=" * 70)
    print("TASK 11: XML DATABASE & DOCUMENT OPERATIONS")
    print("=" * 70)

    # 1. Parse XML Document
    tree = ET.parse(XML_PATH)
    root = tree.getroot()
    print(f"Loaded XML Root: <{root.tag}> | Order ID: {root.get('orderId')} | Status: {root.get('status')}\n")

    # 2. XPath Query 1: Extract Member Details
    member_elem = root.find("Member")
    name = member_elem.find("FullName").text
    email = member_elem.find("Email").text
    phone = member_elem.find("Phone").text
    branch = member_elem.find("HomeBranch").text
    branch_id = member_elem.find("HomeBranch").get("branchId")

    print("[XPath Query 1: Extract Member Profile]")
    print(f"  - Member: {name} (ID: {member_elem.get('id')})")
    print(f"  - Contact: {email} | {phone}")
    print(f"  - Enrolled Branch: {branch} (Branch ID: {branch_id})\n")

    # 3. XPath Query 2: Extract Subscription Details
    sub_elem = root.find("SubscriptionDetails")
    plan_name = sub_elem.find("PlanName").text
    category = sub_elem.find("Category").text
    duration = sub_elem.find("DurationMonths").text
    print("[XPath Query 2: Extract Subscription Plan]")
    print(f"  - Plan: {plan_name} [{category}]")
    print(f"  - Validity: {duration} Months ({sub_elem.find('StartDate').text} to {sub_elem.find('EndDate').text})\n")

    # 4. XPath Query 3: Query Items using XPath Predicates (Items where UnitPrice > 5000)
    print("[XPath Query 3: High-Value Items (Price >= INR 5,000)]")
    items = root.findall(".//Item")
    for item in items:
        item_name = item.find("ItemName").text
        price = float(item.find("UnitPrice").text)
        qty = int(item.find("Quantity").text)
        if price >= 5000:
            print(f"  * Item #{item.get('itemId')}: {item_name} - Qty: {qty} @ INR {price:,.2f}")

    # 5. XQuery equivalent: Extract and format full Pricing Summary & Payment
    pricing = root.find("PricingSummary")
    subtotal = pricing.find("Subtotal").text
    discount_elem = pricing.find("DiscountApplied")
    discount = discount_elem.text if discount_elem is not None else "0.00"
    coupon = discount_elem.get("coupon") if discount_elem is not None else "N/A"
    tax = pricing.find("TaxRate").text
    final_total = pricing.find("FinalTotal").text

    payment = root.find("PaymentTransaction")
    print(f"\n[XQuery Extraction: Financial Settlement]")
    print(f"  - Subtotal:       INR {float(subtotal):,.2f}")
    print(f"  - Coupon ({coupon}): - INR {float(discount):,.2f}")
    print(f"  - Tax (18% GST):   INR {float(tax):,.2f}")
    print(f"  - Net Total:      INR {float(final_total):,.2f}")
    print(f"  - Payment Txn:    {payment.find('TxnId').text} via {payment.get('mode')} [{payment.get('status')}]\n")

    # 6. XML Modification Demonstration (In-Memory update)
    print("[XML Modification: Applying 5% Loyalty Surcharge Rebate]")
    final_elem = pricing.find("FinalTotal")
    old_val = float(final_elem.text)
    new_val = round(old_val * 0.95, 2)
    final_elem.text = str(new_val)
    print(f"  - Updated FinalTotal from INR {old_val} to INR {new_val}")
    print("=" * 70)

if __name__ == "__main__":
    run_xml_tasks()
