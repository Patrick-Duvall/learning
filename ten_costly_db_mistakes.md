# Ten costly mistakes and how to fix them
By andrew Atkinson
https://www.youtube.com/watch?v=pbztEjDyp8s

Associated costs: Dev time, bigger servers, cus
tomer churn

## Forming challenges

### Mistake #10—Infrequent Releases

- Using Gitflow¹ or similar legacy software delivery processes
- Not using Feature Flags to decoupling releases and feature visibility
- Not tracking or improving DevOps metrics
- Performing DDL(Data Definition Language) (`create index`, `alter table`, etc.) *exclusively* as Rails Migrations in releases

#### Fixes

- Use Trunk-based development (TBD) and feature flags. 2024 Rails Survey: 20% (500+) "multiple/month", 2% (50+) "multiple/quarter"
- Track DevOps metrics. DORA, SPACE, Accelerate, 2-Minute DORA Quick Check
- Raise test suite coverage (Simplecov), increase speed & reliability
- Supplement DDL releases using ⚓ Anchor Migrations, safety-linted SQL, non-blocking, idempotent, maintain consistency with Active Record Migrations

Increased costs: Incident response, cycle time

### Mistake #9—DB Inexperience

- Not hiring DB specialists or DBAs
- Not using SQL in application code or business intelligence
- Not reading and interpreting query execution plans
- Not using *cardinality*, *selectivity*, or execution plan BUFFERS info in designs
Cardinality: measurement of unique values, boolean flag=> low, uuid=> high
Selectivity: Percent of rows returned for a query condition. `where country = US` Low if 90% in US, high if 1% in Us.
- Adding indexes haphazardly (over-indexing)
- Choosing schema designs with poor performance

#### Fixes

- Hire experience: DB specialists, DBAs, and consultants
- Grow experience: books, courses, conferences, communities
- Create a production clone instance for experimentation. Use it in your workflow.
- Use concepts of *pages*, buffers, latency, *selectivity*, *cardinality*, *correlation*, and *locality* to improve your designs
Pages: fundamental storage unit in DB i.e. 16KB in MYSQL
Databases read/write entire pages at once, not individual rows
Correlation: Measure of how well physical storage location matches index
High correlation (+1.0): Data stored in same order as index = fast sequential reads, low correlation, data scattered, slower
- Avoid performance-unfriendly designs like random UUID primary keys

Increased costs: Server costs, Developer time

### Mistake #8—Speculative DB Design

- Avoiding beneficial database constraints *today* due to speculation about *tomorrow*
- Doubting ability to evolve the schema design in the future
- *Not* using third normal form normalization (3NF) by default
- Avoiding *all* forms of denormalization, even for use cases like multi-tenancy
Multi-tenancy: an architecture where a single application instance serves multiple customers

Adding site_id to many records for query performance is denormalization

DBforms
1nf
Each cell contains a single value (no lists, arrays, or comma-separated values)
Each row is unique
Example: Don't store "apple,orange,banana" in one cell

2NF => 1NF AND
Every non-key column depends on the ENTIRE primary key
Only matters if you have composite primary keys (multiple columns)
Example: If key is (order_id, product_id), don't store product_name since it only depends on product_id

3NF = 2NF AND
No transitive dependencies
Simple rule: Non-key columns depend ONLY on the primary key, NOT on other non-key columns
Example: Don't store customer_name in orders table - it depends on customer_id, not order_id

#### Fixes

- Use all available constraints for data consistency, integrity, quality (CORE: constraint-driven)
- Create matching DB constraints for code validation. Match PK/FK types. Use database_consistency gem.
- Normalize by default. Eliminate duplication. Design for today, but anticipate growth in data and query volume.
- Use denormalization sometimes, for example tenant identifier columns

