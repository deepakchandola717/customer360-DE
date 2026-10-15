# Customer360 — Data Engineering Assignment

## Context

An e-commerce company stores customer information across multiple systems, including website activity, CRM, orders, payments, customer support and marketing platforms.

The company wants a **Customer Data Platform (CDP)** that combines this information to provide a unified view of every customer, understand their behaviour and identify customers for targeted marketing campaigns.

Your task is to build a working backend data pipeline and analytical system using **Python/NodeJS/Java, SQL, PostgreSQL and ClickHouse**.

## What you need to build

### 1. Data ingestion

Import the provided datasets into ClickHouse.

- Ingest at least **5 million website activity records** from the main e-commerce dataset.
- Extract CRM, order and payment records from PostgreSQL.
- Process the additional JSON/CSV files containing identity mappings, support tickets, marketing activity and consent information.
- Clean and standardise the data where necessary.

The ingestion process should be automated and repeatable.

### 2. Unified customer profiles

Different sources may refer to the same customer using different identifiers.

Build a system that identifies and connects records belonging to the same customer.

Each unified customer should have a unique customer ID and a consolidated profile containing:

- Customer details and associated identifiers
- Website activity: views, cart additions and purchases
- Total paid orders and total amount spent
- First and most recent activity
- Most viewed product category
- Customer support history and open-ticket count
- Marketing engagement and latest email consent status

Avoid incorrectly combining unrelated customers. Store the identity mappings used to connect records.

### 3. Customer segmentation

Using the unified data, identify these three customer groups:

1. **Abandoned carts:** Customers who added a product to their cart in the last 7 days but did not subsequently purchase that product in the same session.
2. **High-value customers:** Customers with at least 2 successfully paid, non-refunded orders and total spending of at least $200.
3. **Inactive customers:** Customers who purchased before 16 October 2019 but had no website activity in the last 7 days.

Use **1 November 2019, 00:00 UTC** as the reference date for these calculations.

Store the resulting customer segments in ClickHouse.

### 4. Customer data and audience access

Provide SQL queries, a CLI or simple APIs that allow someone to:

- Find and view a unified customer profile.
- View customers belonging to each segment.
- Retrieve daily website activity and purchase statistics.
- Export a segment as a CSV containing customer contact details.

**Important:** Email audience exports must exclude customers who have opted out or whose permission is unknown. Avoid duplicate recipients.

A frontend/dashboard is not required.

### 5. Incremental processing and data reliability

Your pipeline should support:

- Running the same ingestion again without creating duplicate data.
- Adding new records without rebuilding everything from scratch.
- Reflecting changes to existing CRM records and customer consent.
- Basic validation and reporting of processed, rejected and duplicate records.

## Expected submission

Submit a Git repository containing:

1. All ingestion, transformation, customer unification and segmentation code.
2. ClickHouse table definitions and any supporting database scripts.
3. A `README.md` explaining how to set up and run the project.
4. Sample outputs showing unified customer profiles, segments and audience exports.
5. Basic tests or validation queries demonstrating that the results are correct.

Include the number of website events processed and a brief explanation of your data model.

## Technical requirements

- **ClickHouse:** Mandatory analytical database.
- **PostgreSQL:** Source database for CRM, orders and payments.
- **Python and SQL:** Primary implementation languages.
- **Docker Compose:** Provided for local infrastructure.
- **Minimum volume:** 5 million website activity events; processing the entire dataset is a bonus.

You will receive the datasets, database setup and supporting files. You are responsible for developing the ingestion pipelines, data transformations, identity resolution, customer profiles and segmentation logic.

**The priority is a working, accurate and reproducible data pipeline, not a polished user interface.**
