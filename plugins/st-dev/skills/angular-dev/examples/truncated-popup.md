# Truncated Text with Centered Popup

Show truncated text in table cells with full content popup centered on screen.

## Component

```typescript
import { Component, HostListener, signal } from '@angular/core';

@Component({...})
export class DataTableComponent {
  // Popup state: just the text (no position needed for centered popup)
  selectedPopup = signal<string | null>(null);

  showPopup(event: MouseEvent, text: string | undefined): void {
    if (!text || text === '-') return;
    event.stopPropagation();
    this.selectedPopup.set(text);
  }

  // Close popup on any click outside
  @HostListener('document:click')
  onDocumentClick(): void {
    this.selectedPopup.set(null);
  }
}
```

## Template

```html
<table class="app-table">
  <tbody>
    @for (item of data(); track item.id) {
      <tr>
        <td>{{ item.name }}</td>
        <!-- Clickable cell with truncation -->
        <td class="comment-cell"
            (click)="showPopup($event, item.comment)">
          {{ item.comment || '-' }}
        </td>
      </tr>
    }
  </tbody>
</table>

<!-- Popup rendered outside table, centered on screen -->
@if (selectedPopup()) {
  <div class="popup">
    {{ selectedPopup() }}
  </div>
}
```

## Styles

```scss
// Truncated cell
td {
  max-width: 150px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

// Clickable cell indicator
.comment-cell {
  cursor: pointer;

  &:hover {
    background-color: rgba(0, 0, 0, 0.05);
  }
}

// Centered popup
.popup {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: white;
  border: 1px solid #ccc;
  border-radius: 8px;
  padding: 16px;
  min-width: 300px;
  max-width: 500px;
  max-height: 400px;
  overflow-y: auto;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
  z-index: 1000;
  white-space: pre-wrap;
  word-wrap: break-word;
  font-size: 0.9rem;
  line-height: 1.5;
}
```

## Key Rules

1. **`position: fixed` with centering** - `top: 50%; left: 50%; transform: translate(-50%, -50%)`
2. **No position tracking needed** - Signal only stores text, not coordinates
3. **`event.stopPropagation()`** - Prevents immediate close from document click
4. **`@HostListener('document:click')`** - Closes popup on any outside click
5. **`z-index: 1000`** - Ensures popup is above other content
6. **Guard against empty** - Check `if (!text || text === '-')` before showing

## Why Centered?

- **Predictable** - User always knows where popup will appear
- **No edge clipping** - Popup never gets cut off at screen edges
- **Simpler code** - No need to track/store mouse coordinates
- **Better for long content** - More space available in center of screen
