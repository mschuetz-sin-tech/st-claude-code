# Avoiding Infinite Loops in Effects

## Problem

When using `effect()` with async operations (HTTP calls) or signal writes, the effect can re-trigger itself in an infinite loop.

## Cause

`effect()` tracks ALL signals read inside it. If your effect calls a method that writes to signals (like `loading.set(true)`), and those signals are read somewhere in the effect's execution path, it triggers re-execution.

## Bad Example

```typescript
effect(() => {
  if (this.isOpen()) {
    this.loadData();  // Sets signals internally → re-triggers effect
  }
});

private loadData(): void {
  this.loading.set(true);  // This write triggers the effect again!
  this.http.get('/api/data').subscribe({
    next: (data) => {
      this.data.set(data);      // Another write → another trigger
      this.loading.set(false);
    }
  });
}
```

## Solution

Use `untracked()` to prevent signal reads/writes from being tracked, and a guard flag to ensure one-time execution:

```typescript
import { effect, untracked } from '@angular/core';

private hasLoadedData = false;

constructor() {
  effect(() => {
    const isOpen = this.isOpen();  // This IS tracked (intentionally)

    if (isOpen && !this.hasLoadedData) {
      this.hasLoadedData = true;
      untracked(() => {
        this.loadData();           // Signal writes won't re-trigger
        this.initializeEntries();
      });
    } else if (!isOpen) {
      this.hasLoadedData = false;  // Reset for next open
    }
  });
}
```

## Key Points

| Concept | Description |
|---------|-------------|
| `untracked()` | Wraps code so signal reads/writes inside are not tracked by the effect |
| Guard flag | Simple boolean to prevent multiple executions per open/close cycle |
| Reset on close | Set flag back to `false` when condition changes, allowing reload next time |

## When to Use

- Dialog components that load data on open
- Components that fetch data based on input changes
- Any effect that triggers HTTP requests or writes multiple signals
