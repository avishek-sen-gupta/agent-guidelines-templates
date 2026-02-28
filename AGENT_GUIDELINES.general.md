# General Claude Code Instructions

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

## Build

- When asked to commit and push, always push to 'main' branch, unless otherwise instructed.
- Before committing anything, update the README based on the diffs.
- Before committing anything, run all tests, fixing them if necessary. If test assertions are being removed, ask me to review them.

## Testing Patterns

- Do not patch or monkey-patch. Use proper dependency injection, and then inject mock objects.
- When fixing tests, do not blindly change test assertions to make the test pass. Only modify assertions once you are sure that the actual code output is actually valid according to the context.
- Always start from writing unit tests for the smallest feasible units of code. True unit tests (which do not exercise true I/O) should be in a `unit` directory under the test directory. Tests which exercise I/O (call LLMs, touch databases) should be in the `integration` directory under the test directory.
- Make sure you are not creating any special implementation behaviour just to get the tests to pass. It's far better to document hard-to-implement behaviour than to try to fix the test for the test's sake. Alternatively, pause and ask me for guidance.

## Programming Patterns

- Use proper dependency injection for interfaces to external systems. Do not hardcode importing the concrete modules in these cases. This applies especially to I/O or nondeterministic modules (eg: clock libraries, GUID libraries, etc.).
- Minimise and/or avoid mutation.
- STOP USING FOR LOOPS WITH MUTATIONS IN THEM. JUST STOP.
- Write your code aggressively in the Functional Programming style, but balance it with readability. Avoid for loops where the language's idiomatic functional constructs (map, filter, reduce, comprehensions, streams, etc.) can be used.
- Minimise magic strings and numbers by refactoring them into constants.
- Don't expose raw global variables in files indiscriminately; wrap them as constants in classes, modules, or equivalent encapsulation.
- When writing `if` conditions, prefer early return. Use `if` conditions for checking and acting on exceptional cases. Minimise or eliminate triggering happy path in `if` conditions.
- Parameters in functions, if they must have default values, must have those values as empty structures corresponding to the non-empty types (empty dictionaries, lists, arrays, etc.). Do not use null/nil/None as a default.
- If a function has a non-null return type, never return null/nil/None.
- If a function returns a non-null type in its signature, but cannot return an object of that type because of some condition, use null object pattern. Do not return null/nil/None.
- Prefer small, composable functions. Do not write massive functions.
- Do not use static methods. EVER.
- Add copious helpful logs to track progress of tasks, especially long-running ones, or ones which involve loops.
- Use a ports-and-adapter type architecture in your design decisions. Adhere to the tenet of "Functional Core, Imperative Shell".
- Favour fully qualified module/package names over relative imports.
- Favour one class per file.
- If enums map to actual objects with behaviour (if they represent configurable functionalities, for example), resolve them into the actual executable objects as early on in the call chain as possible, and inject those objects as dependencies, not the enums.
- For variables which can only take a fixed set of values (a set of strings, for example), use enums instead of strings.

## Code Review Patterns

- Use the `Programming Patterns` section to ensure compliance of code.

## Notes

- If Talisman detects a potential secret, stop what you are doing, prompt me for what needs to be done, and only then should you update the `.talismanrc` file.
- Potential secrets in files trigger Talisman pre-commit hook - add to `.talismanrc` if needed. Don't overwrite existing `.talismanrc` entries, add at the end.
