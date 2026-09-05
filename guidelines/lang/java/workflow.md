## Workflow — Java

Bindings for `workflow.md`.

### Build tool

Gradle with the Kotlin DSL (`build.gradle.kts`) for new projects; Maven is fine on
existing ones. Always use the wrapper — `./gradlew` or `./mvnw` — never a global
installation.

### Verification gate

Substitute for the placeholders in `workflow.md`:

```bash
./gradlew spotlessApply   # formatter
./gradlew build           # -Xlint:all -Werror, ErrorProne, NullAway
./gradlew test            # ALL tests, unit and integration
```

On Maven: `./mvnw spotless:apply`, then `./mvnw verify`.
