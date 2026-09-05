## Guardrails — Java

Bindings for `guardrails.md`. Nothing here restates a rule; each item names the
concrete Java thing the neutral rule refers to.

### Fully typed, no escape hatches

- **Compile with `-Xlint:all -Werror`.** Zero warnings. ErrorProne and NullAway must pass clean.
- **`Object` is banned as a declared type** — no `Object` parameters, fields or return types, and no `Map<String, Object>`. Where a type is hard to express use an interface, a bounded type parameter, or a sealed interface with records for the variants; where it is genuinely unknown at a boundary, bind it into a record there.
- **No raw types**: `List<Node>` not `List`, `Map<String, Integer>` not `Map` — `Set`, `Optional`, `Stream` and `Iterable` alike.
- **No JSON-blob types.** `JsonNode` and `Map<String, Object>` are `Object` with extra steps.

### State types for the checker

- **Declare `implements`** on the interface a class satisfies rather than relying on it being passed where the interface is expected. The error then lands on the broken class, and implementations stay navigable from the interface.

### Text is a boundary

JSON exists only as text in files and on the wire. On entering the program it becomes a record via `ObjectMapper.readValue`.

- Model and API output meets `readValue` first, into a concrete record.
- Serialise with `writeValueAsString` in the adapter, at the last possible moment.
- Anything read from a JSON file becomes a record immediately. Never walk a `JsonNode`.
