# Sticky Table Headers (Without Jumping)

Create tables with sticky headers that don't jump when scrolling.

## Critical: Use `border-collapse: separate`

`border-collapse: collapse` causes header jumping issues with sticky positioning.

## Complete Table Styles

```scss
.table-wrapper {
  flex: 1;
  min-height: 0;
  overflow: auto;
  position: relative;
}

.app-table {
  width: max-content;
  min-width: 100%;
  border-collapse: separate;  // Critical! collapse causes jumping
  border-spacing: 0;
  border: none;

  thead {
    position: sticky;
    top: 0;
    z-index: 10;
  }

  thead th {
    background: #f5f5f5;  // Solid background to cover scrolled rows
    border-bottom: 2px solid #ddd;
    border-top: 1px solid #ddd;
    border-left: 1px solid #ddd;
    padding: 8px 6px;
    font-size: 0.8rem;
    white-space: normal;
    word-wrap: break-word;
    vertical-align: top;

    &:last-child {
      border-right: 1px solid #ddd;
    }
  }

  tbody td {
    background: white;  // Required for border-collapse: separate
    border-bottom: 1px solid #e0e0e0;
    border-left: 1px solid #e0e0e0;
    height: 32px;
    padding: 4px 6px;
    font-size: 0.8rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;

    &:last-child {
      border-right: 1px solid #e0e0e0;
    }
  }

  // Row colors must be applied to td, not tr!
  tbody tr.error td {
    background-color: #f8d7da;
  }
  tbody tr.error:hover td {
    background-color: #f1b0b7;
  }

  tbody tr.warning td {
    background-color: #fff3cd;
  }
  tbody tr.warning:hover td {
    background-color: #ffe69c;
  }

  tbody tr.info td {
    background-color: #cce5ff;
  }
  tbody tr.info:hover td {
    background-color: #b8daff;
  }

  tbody tr.valid td {
    background-color: #d4edda;
  }
  tbody tr.valid:hover td {
    background-color: #c3e6cb;
  }
}
```

## Key Rules

1. **`border-collapse: separate`** - Required for stable sticky behavior
2. **`border-spacing: 0`** - Removes gaps between cells
3. **Solid background on `th`** - Covers scrolled content behind header
4. **Background on `td`, not `tr`** - Row backgrounds don't work reliably with separate
5. **Explicit borders on cells** - Since borders aren't shared with separate
