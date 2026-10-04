## Backend tests (Spring Boot)

- **Integration tests are non-transactional: use `@SpringBootTest`, never `@DataJpaTest`,** for
  any test that writes and then reads back. `@DataJpaTest` wraps each test method in one rollback
  transaction with a single shared persistence context, so a `save` followed by a `findById` can
  return the cached in-memory instance without ever proving a round trip through the database —
  masking mapping bugs and inviting workarounds like a manual `EntityManager.clear()`.
  `@SpringBootTest` applies no test-managed transaction: each repository call opens and commits its
  own transaction against a fresh persistence context, so writes really commit and flush timing,
  versioning and native-query visibility match production.
- **Reset state in `@BeforeEach`.** Because the data now persists between tests, each test cleans
  up through a shared fixture helper — repository `deleteAll()` in foreign-key-safe order.
- **Test queries at the repository level.** Prove query behaviour — correctness, sorting,
  filtering, and above all native or database-specific SQL — by calling the repository directly
  against a real database in a full `@SpringBootTest` context, with the migrations building the
  schema. Reserve the HTTP tests for the web contract: status codes, validation, response envelope
  shape, mapping and dispatch. Re-asserting query correctness through the controller buys no extra
  confidence and costs a slower, vaguer failure.
- **Seed test data through repositories and entities, not SQL.** Arrange state by saving entities;
  never with `JdbcTemplate` or raw `INSERT`s, which bypass the mapping the test is meant to
  exercise. Put reusable seeding in shared fixture helpers instead of duplicating setup per file.
  Where a state is only reachable through a domain method — a backdated timestamp the method takes
  as a parameter, say — drive it through that method rather than crafting the row by hand.
- **Run integration tests against a real database with Testcontainers**, pinned to the same engine
  and major version as production, so engine-specific behaviour is actually under test. Docker has
  to be running.
- **Group related tests with `@Nested`** where it clarifies structure — one nested class per query
  or per concern, or a group for validation errors. Leave a flat handful of unrelated tests flat.
- **Enforce coverage with JaCoCo's `jacocoTestCoverageVerification` attached to `check`**, so
  `./gradlew build` runs it and no separate command is needed.
