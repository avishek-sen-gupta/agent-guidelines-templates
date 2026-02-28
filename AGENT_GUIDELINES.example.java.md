# Agent Guidelines — Java Project

## Workflow Rules

- The workflow is Brainstorm -> Discuss Trade-offs of different designs -> Plan -> Write unit tests -> Implement -> Fix Tests -> Commit -> Refactor.
- When brainstorming / planning, consider the follow parameters:
  - Whether there are any open source projects which perform similar functionality, so that you don't have to write new code for the task
  - The complexity of the implementation matters. Think of a good balance between absolute correctness and "good enough". If in doubt, prompt me for guidance.
- Once a design is finalised, document salient architectural decisions as a timestamped Architectural Decision Record.
- After completing implementation tasks, always run the full test suite before committing. Do not commit code that hasn't passed all tests.
- When implementing plans that span many files, complete each logical unit fully before moving to the next. Do not start a new task until the current one is committed. If the session may end, prefer a committed partial result over an uncommitted complete attempt.

## Common Mistakes to Avoid

- When the user asks to run an operation on a specific subdirectory or module, scope the operation precisely to that directory. Do not run on the parent repo or broader scope unless explicitly asked.
- When working with LLM API calls or external APIs, start with small test inputs before processing large datasets. Large inputs can overflow context windows or crash connections.

## Interaction Style

- When a user interrupts or cancels a task, do not ask clarifying questions — immediately proceed with the redirected instruction. Treat interruptions as implicit 'stop what you're doing and do this instead'.

## Project Context

- Primary language: Java.
- Always run the formatter (e.g., `google-java-format` or IDE-configured formatter) before committing. When test counts are mentioned, verify that count hasn't regressed.

## Build

- Use Gradle or Maven as the build tool. Prefer Gradle with Kotlin DSL (`build.gradle.kts`) for new projects.
- When asked to commit and push, always push to 'main' branch, unless otherwise instructed.
- Before committing anything, update the README based on the diffs.
- Before committing anything, run `./gradlew spotlessApply` (or equivalent formatter task) on every Java file touched in the change.
- Before committing anything, run `./gradlew build` to ensure compilation and all checks pass.
- Before committing anything, run all tests, fixing them if necessary. If test assertions are being removed, ask me to review them.

## Testing Patterns

- Use JUnit 5 for all tests. Do not use JUnit 4 unless maintaining legacy code.
- Use constructor injection or test-specific factory methods to supply test doubles. Do not use `@MockBean`, `Mockito.mock()` inline, or reflection-based injection. Wire mock implementations through the same dependency injection path as production code.
- Use `@TempDir` for filesystem tests.
- Prefer AssertJ over Hamcrest or raw JUnit assertions for readability.
- When fixing tests, do not blindly change test assertions to make the test pass. Only modify assertions once you are sure that the actual code output is actually valid according to the context.
- Always start from writing unit tests for the smallest feasible units of code. True unit tests (which do not exercise true I/O) should be in a `unit` directory under the test directory. Tests which exercise I/O (call LLMs, touch databases) should be in the `integration` directory under the test directory.
- Make sure you are not creating any special implementation behaviour just to get the tests to pass. It's far better to document hard-to-implement behaviour than to try to fix the test for the test's sake. Alternatively, pause and ask me for guidance.

## Programming Patterns

- Use proper dependency injection for interfaces to external systems. Do not hardcode importing the concrete classes in these cases. This applies especially to I/O or nondeterministic modules (eg: clock libraries, UUID generators, etc.).
- Minimise and/or avoid mutation.
- STOP USING FOR LOOPS WITH MUTATIONS IN THEM. JUST STOP.
- Prefer `Stream` pipelines over imperative `for` loops for collection transformations. Do not use `forEach` with side effects as a substitute for a `for` loop — if you need side effects, use a `for` loop explicitly.
- Minimise magic strings and numbers by refactoring them into constants.
- Don't expose raw global variables in files indiscriminately; wrap them as constants in classes.
- When writing `if` conditions, prefer early return. Use `if` conditions for checking and acting on exceptional cases. Minimise or eliminate triggering happy path in `if` conditions.
- Method parameters must never be null. Use empty collections (`List.of()`, `Map.of()`, `Set.of()`) as defaults where applicable. Use method overloads or builder patterns instead of nullable parameters.
- If a method has a non-void return type, never return null. Use `Optional<T>` for genuinely optional results, or the null object pattern for domain types.
- Do not use `Optional` as a field type or method parameter — only as a return type.
- Prefer small, composable methods. Do not write massive methods.
- Do not use static methods. EVER. Use injected collaborators or instance methods.
- Do not use static utility classes. Encapsulate behaviour in objects.
- Add copious helpful logs to track progress of tasks, especially long-running ones, or ones which involve loops. Use SLF4J — never `System.out.println`.
- Use a ports-and-adapter type architecture in your design decisions. Adhere to the tenet of "Functional Core, Imperative Shell".
- Always use fully qualified imports. Do not use wildcard imports (`import java.util.*`).
- Favour one top-level class per file.
- Favour records for immutable data carriers. Use records instead of POJOs or Lombok `@Data`/`@Value` where the class is purely structural.
- Use sealed interfaces and records for algebraic data types / discriminated unions.
- Mark classes and methods `final` by default. Only open them for extension when there is a concrete need.
- Use `var` for local variables when the type is obvious from the right-hand side.
- Prefer `List.of()`, `Map.of()`, `Set.of()` for creating immutable collections. Do not use `Arrays.asList()` or `new ArrayList<>(...)` unless mutability is required.
- Use enums instead of string constants for fixed sets of values.
- If enums map to actual objects with behaviour (if they represent configurable functionalities, for example), resolve them into the actual executable objects as early on in the call chain as possible, and inject those objects as dependencies, not the enums.

## Code Review Patterns

- Use the `Programming Patterns` section to ensure compliance of code.

## Dependencies

- Java 21+
- Gradle (Kotlin DSL) or Maven for build management
- JUnit 5 for testing
- AssertJ for assertions
- SLF4J + Logback for logging

## Notes

- Use `./gradlew` (or `./mvnw`) wrapper scripts for all build commands — do not assume a global installation.
- Favour SLF4J logging over `System.out.println`. Never commit print statements.
- If Talisman detects a potential secret, stop what you are doing, prompt me for what needs to be done, and only then should you update the `.talismanrc` file.
- Potential secrets in files trigger Talisman pre-commit hook - add to `.talismanrc` if needed. Don't overwrite existing `.talismanrc` entries, add at the end.
