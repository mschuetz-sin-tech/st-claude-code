# Angular Development Skill

You are an expert in Angular development with the sin-tech technology stack.

## Technology Stack

- **Angular 21** - Latest Angular with standalone components and stable Signals
- **TypeScript 5.8+** - Strict type checking enabled
- **Angular Material** - UI components
- **RxJS 7.8** - Reactive programming
- **Signals** - Angular's stable reactivity system (signal, computed, effect, linkedSignal)

## Code Conventions

### Naming
- Use descriptive variable names
- Components: `*Component` suffix with kebab-case selector
- Services: `*Service` suffix
- Models/Interfaces: PascalCase, no suffix needed

### Comments
- Write all comments in English
- Only add comments where logic is not self-evident

### Components
- Always use standalone components (no NgModules)
- Use `input()` and `output()` signals instead of `@Input()` / `@Output()`
- Use `signal()` and `computed()` for reactive state
- Keep components focused - extract logic to services

## Component Pattern

```typescript
@Component({
  selector: 'app-example',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './example.component.html',
  styleUrls: ['./example.component.scss']
})
export class ExampleComponent {
  data = input<DataType[]>([]);           // Signal-based input
  dataChange = output<DataType>();         // Signal-based output
  loading = signal(false);                 // Internal state
  filteredData = computed(() =>            // Computed value
    this.data().filter(d => d.active)
  );
  private readonly service = inject(ExampleService);
}
```

## Template Syntax

Use new control flow syntax:
- `@if` / `@else` instead of `*ngIf`
- `@for` with `track` instead of `*ngFor`
- `@switch` / `@case` instead of `ngSwitch`

```html
@if (loading()) {
  <mat-spinner></mat-spinner>
} @else {
  @for (item of items(); track item.id) {
    <div>{{ item.name }}</div>
  }
}
```

## UI/UX Patterns

Detailed examples are in separate files to keep this skill lean. Read the relevant example when needed:

| Pattern | When to Use | Example File |
|---------|-------------|--------------|
| **Full-Height Layout** | Page fills viewport, only content scrolls | `examples/full-height-layout.md` |
| **Sticky Table Headers** | Table with fixed header that doesn't jump | `examples/sticky-table.md` |
| **Infinite Scroll** | Auto-load more data on scroll | `examples/infinite-scroll.md` |
| **Truncated Popup** | Show full text on click for truncated cells | `examples/truncated-popup.md` |

### Quick Reference

- **Flexbox chain**: Every container needs `min-height: 0`
- **Sticky headers**: Use `border-collapse: separate`, not `collapse`
- **Row backgrounds**: Apply to `td`, not `tr` (with separate)
- **Router-outlet**: Style with `router-outlet + *` selector
- **Host element**: Always style `:host` for flex participation

## Best Practices

### HTTP
- Use HttpClient with typed responses
- Handle errors with catchError or error callback
- Use proxy configuration for development

### Forms
- Prefer reactive forms for complex forms
- Use template-driven forms for simple cases
- Always validate user input

### Performance
- Use `track` in `@for` loops
- Lazy load routes where appropriate
- Use OnPush change detection where possible

## Common Commands

```bash
npm install      # Install dependencies
npm start        # Development server
npm run build    # Build for production
npm run test     # Run tests
```
