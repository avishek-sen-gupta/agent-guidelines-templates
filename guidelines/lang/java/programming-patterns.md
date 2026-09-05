## Programming Patterns — Java

Bindings for `programming-patterns.md`.

- **No wildcard imports** — `import java.util.List`, never `import java.util.*`.
- **Records for immutable data carriers**, in place of POJOs or Lombok `@Data`/`@Value`. Sealed interfaces plus records for discriminated unions.
- **`final` by default** on classes and methods; open for extension only on concrete need.
- **Empty defaults are `List.of()`, `Map.of()`, `Set.of()`.** Where a parameter would otherwise be nullable, add an overload or a builder instead.
- **`Optional<T>` for genuinely optional results**, or the null object pattern for domain types. `Optional` is a return type only — never a field or parameter.
- **`List.of()` / `Map.of()` / `Set.of()` for immutable collections**; `Arrays.asList()` and `new ArrayList<>(...)` only where mutability is required.
- **`Stream` pipelines over imperative loops.** Do not use `forEach` with side effects as a substitute for a `for` loop — if you need side effects, write the loop.
- **`var` for locals** where the type is obvious from the right-hand side.
- **SLF4J for logging.** Never `System.out.println`.
