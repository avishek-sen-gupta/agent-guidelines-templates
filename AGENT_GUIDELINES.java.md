# Java-Specific Agent Guidelines

## Project Context

- Primary language: Java.
- Always run the formatter (e.g., `google-java-format` or IDE-configured formatter) before committing. When test counts are mentioned, verify that count hasn't regressed.

## Build

- Use Gradle or Maven as the build tool. Prefer Gradle with Kotlin DSL (`build.gradle.kts`) for new projects.
- Before committing anything, run `./gradlew spotlessApply` (or equivalent formatter task) on every Java file touched in the change.
- Before committing anything, run `./gradlew build` to ensure compilation and all checks pass.

## Testing Patterns

- Use JUnit 5 for all tests. Do not use JUnit 4 unless maintaining legacy code.
- Use constructor injection or test-specific factory methods to supply test doubles. Do not use `@MockBean`, `Mockito.mock()` inline, or reflection-based injection. Wire mock implementations through the same dependency injection path as production code.
- Use `@TempDir` for filesystem tests.
- Prefer AssertJ over Hamcrest or raw JUnit assertions for readability.

## Programming Patterns

- Always use fully qualified imports. Do not use wildcard imports (`import java.util.*`).
- Method parameters must never be null. Use empty collections (`List.of()`, `Map.of()`, `Set.of()`) as defaults where applicable. Use method overloads or builder patterns instead of nullable parameters.
- If a method has a non-void return type, never return null. Use `Optional<T>` for genuinely optional results, or the null object pattern for domain types.
- Do not use `Optional` as a field type or method parameter — only as a return type.
- Favour one top-level class per file.
- Favour records for immutable data carriers. Use records instead of POJOs or Lombok `@Data`/`@Value` where the class is purely structural.
- Use sealed interfaces and records for algebraic data types / discriminated unions.
- Prefer `Stream` pipelines over imperative `for` loops for collection transformations. Do not use `forEach` with side effects as a substitute for a `for` loop — if you need side effects, use a `for` loop explicitly.
- Mark classes and methods `final` by default. Only open them for extension when there is a concrete need.
- Use `var` for local variables when the type is obvious from the right-hand side.
- Prefer `List.of()`, `Map.of()`, `Set.of()` for creating immutable collections. Do not use `Arrays.asList()` or `new ArrayList<>(...)` unless mutability is required.
- Do not use static methods. EVER. Use injected collaborators or instance methods.
- Do not use static utility classes. Encapsulate behaviour in objects.
- Use enums instead of string constants for fixed sets of values.
- If enums map to behaviour, resolve them into strategy/policy objects as early as possible and inject those objects as dependencies, not the enums.

## Dependencies

- Java 21+
- Gradle (Kotlin DSL) or Maven for build management
- JUnit 5 for testing
- AssertJ for assertions
- SLF4J + Logback for logging

## Notes

- Use `./gradlew` (or `./mvnw`) wrapper scripts for all build commands — do not assume a global installation.
- Favour `slf4j` logging over `System.out.println`. Never commit print statements.
