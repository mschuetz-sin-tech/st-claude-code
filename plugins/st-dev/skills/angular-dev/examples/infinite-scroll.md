# Infinite Scroll Pattern

Replace pagination with automatic loading when scrolling near the bottom.

## Table Component (Child)

```typescript
@Component({...})
export class DataTableComponent {
  // Inputs
  data = input<Item[]>([]);
  loading = input(false);
  hasMoreData = input(true);
  totalElements = input(0);

  // Output to trigger loading
  loadMore = output<void>();

  onTableScroll(event: Event): void {
    // Don't load if already loading or no more data
    if (this.loading() || !this.hasMoreData()) return;

    const element = event.target as HTMLElement;
    const threshold = 100;  // pixels from bottom

    if (element.scrollTop + element.clientHeight >= element.scrollHeight - threshold) {
      this.loadMore.emit();
    }
  }
}
```

```html
<div class="table-wrapper" (scroll)="onTableScroll($event)">
  <table class="app-table">
    <!-- table content -->
  </table>
</div>

@if (loading()) {
  <div class="loading-indicator">Loading more...</div>
}

<div class="table-info">
  Showing {{ data().length }} of {{ totalElements() }} entries
</div>
```

## Page Component (Parent)

```typescript
@Component({...})
export class DataPageComponent implements OnInit {
  items: Item[] = [];
  loading = false;
  currentPage = 0;
  pageSize = 100;  // Load 100 at a time
  totalElements = 0;
  hasMoreData = true;

  private readonly service = inject(DataService);

  ngOnInit(): void {
    this.loadInitialData();
  }

  loadInitialData(): void {
    // Reset state for fresh load (e.g., filter change)
    this.currentPage = 0;
    this.items = [];
    this.hasMoreData = true;
    this.loadNextPage();
  }

  loadNextPage(): void {
    if (this.loading || !this.hasMoreData) return;

    this.loading = true;

    this.service.getItems({
      page: this.currentPage,
      size: this.pageSize
    }).subscribe({
      next: (response) => {
        // APPEND to existing items, don't replace!
        this.items = [...this.items, ...response.content];
        this.totalElements = response.page.totalElements;
        this.hasMoreData = this.items.length < this.totalElements;
        this.currentPage++;
        this.loading = false;
      },
      error: () => {
        this.loading = false;
      }
    });
  }

  onLoadMore(): void {
    this.loadNextPage();
  }
}
```

```html
<app-data-table
  [data]="items"
  [loading]="loading"
  [hasMoreData]="hasMoreData"
  [totalElements]="totalElements"
  (loadMore)="onLoadMore()">
</app-data-table>
```

## Key Rules

1. **Append, don't replace** - `[...existing, ...new]` preserves scroll position
2. **Track loading state** - Prevent duplicate requests while loading
3. **Track hasMoreData** - Stop requesting when all data loaded
4. **Threshold of ~100px** - Start loading before reaching absolute bottom
5. **Reset on filter change** - Clear items and reset page when filters change
