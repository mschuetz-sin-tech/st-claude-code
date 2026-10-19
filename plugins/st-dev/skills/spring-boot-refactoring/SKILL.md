---
description: This skill should be used when refactoring existing Spring Boot / Java backend code for structure and simplicity - collapsing duplicated builders, replacing repeated parameter lists with a context object, flattening service call graphs, or merging pass-through classes. Trigger phrases include "refactor", "simplify the code", "reduce duplication", "too many parameters", "context POJO", "delegate pattern", "merge these classes", "check the code for refactorings", "clean up this service".
---

# Spring Boot Refactoring Skill

Structural refactoring of existing Java/Spring Boot code. The goal is code that is simple to
read, with access paths that run top-down instead of every class reaching into every other.

**This skill is for changing structure without changing behavior.** Behavior changes belong in a
ticket, not in a refactoring commit.

## The non-negotiable rule: a test must cover the line first

Refactor only what a test already pins down. For anything else, write the test first or leave the
code alone.

**Before you touch anything, establish the baseline — do not skip this.** Run the project's own
test command; check the README or CI config for the module, profile, and integration-test flags
this repository actually uses instead of assuming.

Record how many tests pass **and which ones already fail**. A suite with a pre-existing red test
is normal on a feature branch; what matters is that the set of failures does not grow.

### When a test fails after your change, prove whose fault it is

Do not start debugging your own diff on the assumption it caused the failure. Stash your work,
re-run the same single test against the clean baseline, then unstash.

Same failure on the baseline → pre-existing, not yours. Say so explicitly in your report and move
on. Different → it is yours; fix it or revert.

Watch the test-filter flags: a `-Dtest=` / `-Dit.test=` pattern that matches nothing can either
fail the build with *"No tests matching pattern"* or report success — both mean **nothing ran and
nothing was verified**. Always confirm a real `Tests run: N` line before believing a green build.

## Refactorings that pay off, in order of value

### 1. Field-by-field copies of the same object → `toBuilder()` + a named copy method

The highest-value fix in a codebase with wide rows/DTOs. Several call sites each hand-copying
almost all fields of a type is one place per site to forget a field when a new one is added. Put a
named copy method on the type itself so the type owns what a copy means.

- `@Builder(toBuilder = true)` — `toBuilder` is **not** on by default.
- **The aliasing trap — this is a real bug, not a style point.** `toBuilder()` copies references.
  If a field holds a mutable object, the copy and the original **share** it, and writing the copy's
  state corrupts the object it came from. The old `builder()` code got a fresh instance from
  `@Builder.Default` and was accidentally safe. Always re-initialize mutable fields explicitly in
  the copy method.
- **Preserve per-site deviations deliberately.** Before substituting, diff what each site actually
  set. One may omit fields so they start at their default; `toBuilder()` would carry them over and
  silently change behavior. Reset them inside the copy method rather than relying on each caller to
  overwrite them afterwards.

### 2. The same mapping from an entity → a static factory on the target type

When two or more classes map the same source entity onto the same set of target fields, move that
mapping to one static factory on the target type.

Return the **builder**, not the finished object — that is what makes it usable: each caller
continues with its own remaining fields. Fold in the constants that every call site sets anyway.

### 3. Repeated `start-stamp / do work / book counters` → one `timed(...)` helper

Many steps each stamping a start instant into one reassigned local variable and booking the
duration afterwards is one chance per step to measure from the wrong start. Replace it with a
single helper on the collector that takes the step, the work as a `Supplier`, and how to count the
result.

- Book the duration in a `finally` block — a step that failed still took the time it took.
- Let the caller say *which* counter a number means (inserted vs. updated) — that is the step's
  business, not the helper's.
- Add an `int` overload (`IntSupplier`) so the common case stays free of boxing noise at the call
  site.

### 4. Repeated adjacent parameters → a record, when they never vary independently

The "context POJO", correctly scoped. Check first whether the parameters really travel together:

- Two ids passed side by side at many sites, never one without the other → make it a record. Two
  bare `Long`s also mean the compiler **cannot** catch a transposition; a type can.
- A value that legitimately differs per call → leave it a parameter. Folding a varying value into a
  context object just hides it.

Do not build one god-context holding everything a run touches. A context object earns its place by
removing a pair that is always identical, not by shortening signatures.

**Size the sweep honestly.** Count the call sites in main *and* test code before starting
(`grep -rc`). A rename spanning hundreds of sites is a single mechanical commit or nothing — half a
migration is worse than none. If you cannot finish it, say so and leave it out rather than
converting the easy half.

### 5. Pass-through classes → merge, *unless* the seam is documented

A class whose only method forwards to one collaborator and adds a log line is usually noise.

**But check what the indirection records before deleting it.** A thin guard with its own test
asserting a specific precondition is documentation of a past production bug. Collapsing it deletes
that. Two further checks:

- How many tests mock the collaborator? If removing it rewrites a dozen test files to save one
  production line, the ratio is wrong.
- Does the name mark a decision point (a guard, a gate, a stage boundary)? Those are worth a class.

Thin **delegators that compose a sequence** of calls are the target structure, not a smell — leave
them.

## Naming during a refactor

- Rename along the whole call chain when behavior moves, not just the leaf. Stale names are worse
  than no names.
- When a method's result becomes the thing it returns rather than the thing it mutates, rename it
  to describe what it now produces.
- Comment *why*, not *what*. A comment explaining that the duration is booked in a `finally` block
  because a failed step still consumed time survives the next reader; `// set the duration` does
  not.

## Verification checklist

1. Compile after every few edits, not once at the end.
2. Full unit suite green; compare the count against the baseline.
3. Integration tests for the touched paths, with a real `Tests run:` line confirmed.
4. Any new failure stash-tested against the baseline before you blame your diff.
5. `git diff --cached --stat` — a structural refactor should come out net negative. Growth means
   abstraction got added without duplication being removed.
