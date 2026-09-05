## Project Context — Java defaults

Suggested values for the fill-in fields in `project-context.md`. Replace anything
your project does differently.

- **Language:** Java 21+
- **Package manager:** Gradle (Kotlin DSL) or Maven
- **Test framework:** JUnit 5 with AssertJ
- **Formatter:** Spotless with google-java-format

### External Dependencies

- Jackson (`ObjectMapper`) for boundary parsing into records
- ErrorProne + NullAway for null and correctness checks
- SLF4J + Logback for logging
