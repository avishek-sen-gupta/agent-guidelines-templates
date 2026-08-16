# Java-Specific Agent Guidelines

The Java layer. Everything language-agnostic lives in the topic files
(`guardrails.md`, `workflow.md`, `testing.md`, and the rest) — this file holds only
what changes because the language is Java.

## Typing

- **Build with `-Xlint:all -Werror`.** Compile with zero warnings; ErrorProne and NullAway must pass clean.
- **`Object` is banned as a declared type** — no `Object` parameters, fields or return types, and no `Map<String, Object>`. Where a type is hard to express use an interface, a bounded type parameter, or a sealed interface with records for the variants; where it is genuinely unknown at a boundary, bind it into a record there.
- **No raw types**: `List<Node>` not `List`, `Map<String, Integer>` not `Map` — `Set`, `Optional`, `Stream` and `Iterable` alike.
- **No JSON-blob types.** `JsonNode` and `Map<String, Object>` are `Object` with extra steps.
- **Declare `implements`** on the interface a class satisfies rather than relying on it being passed where the interface is expected. The error then lands on the broken class, and implementations stay navigable from the interface.

## Text as a boundary

JSON exists only as text in files and on the wire. On entering the program it becomes a record via `ObjectMapper.readValue`.

- Model and API output meets `readValue` first, into a concrete record.
- Serialise with `writeValueAsString` in the adapter, at the last possible moment.
- Anything read from a JSON file becomes a record immediately. Never walk a `JsonNode`.

## Build

- Gradle or Maven; prefer Gradle with Kotlin DSL (`build.gradle.kts`) for new projects.
- Always use the `./gradlew` / `./mvnw` wrapper — do not assume a global installation.
- Before committing, run `./gradlew spotlessApply` on every file touched, then `./gradlew build`.

## Testing

- JUnit 5. Do not use JUnit 4 unless maintaining legacy code.
- AssertJ over Hamcrest or raw JUnit assertions.
- `@TempDir` for filesystem tests.
- Constructor injection or test-specific factories for test doubles. No `@MockBean`, no inline `Mockito.mock()`, no reflection-based injection — wire fakes through the same DI path as production code.
- Unit tests in `.../unit/`, integration tests in `.../integration/`.

## Programming patterns

- Fully qualified imports. No wildcard imports (`import java.util.*`).
- Records for immutable data carriers, in place of POJOs or Lombok `@Data`/`@Value`. Sealed interfaces plus records for discriminated unions.
- `final` by default on classes and methods; open for extension only on concrete need.
- Parameters are never null — use `List.of()`, `Map.of()`, `Set.of()` as defaults, and overloads or builders instead of nullable parameters.
- Never return null from a non-void method. Use `Optional<T>` for genuinely optional results, or the null object pattern for domain types. `Optional` is a return type only — never a field or parameter.
- `List.of()` / `Map.of()` / `Set.of()` for immutable collections; `Arrays.asList()` and `new ArrayList<>(...)` only where mutability is required. Never accept a mutable collection you do not intend to mutate.
- `Stream` pipelines over imperative loops. Do not use `forEach` with side effects as a substitute for a `for` loop — if you need side effects, write the loop.
- `var` for locals where the type is obvious from the right-hand side.
- Enums instead of string constants. Where an enum maps to behaviour, resolve it into a strategy object early and inject that object.
- No static methods, and no static utility classes.
- SLF4J for logging. Never `System.out.println`, and never commit print statements.

## Dependencies

- Java 21+
- Gradle (Kotlin DSL) or Maven
- JUnit 5, AssertJ
- Jackson (`ObjectMapper`) for boundary parsing into records
- ErrorProne + NullAway
- SLF4J + Logback
