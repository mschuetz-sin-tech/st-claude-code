# Full-Height Page Layout (No Page Scroll)

Create a page that fills the viewport with only internal component scrolling.

## App Shell Setup (`app.component.scss`)

```scss
.app-content {
  display: flex;
  flex-direction: column;
  height: 100%;
  min-height: 0;  // Critical for nested flexbox!
  overflow: hidden;
}

.main-content {
  flex: 1;
  padding: 16px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  min-height: 0;

  // Router-outlet is empty, component is inserted as sibling
  router-outlet {
    display: none;
  }

  // Only the routed component gets flex: 1
  router-outlet + * {
    flex: 1;
    min-height: 0;
    overflow: hidden;
  }
}
```

## Page Component (`:host` is critical!)

```scss
:host {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.page-container {
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.header-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 8px 0;
  flex-shrink: 0;  // Don't shrink header
}

.content-area {
  flex: 1;
  min-height: 0;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}
```

## Key Rules

1. **Every flex container needs `min-height: 0`** - allows children to shrink below content size
2. **Use `:host` styling** - Angular components create wrapper elements that need flex properties
3. **`router-outlet` handling** - Hide the empty element, style only the inserted component
4. **`flex-shrink: 0`** on fixed elements - prevents headers/footers from shrinking
5. **`overflow: hidden`** on containers - prevents content from breaking out
