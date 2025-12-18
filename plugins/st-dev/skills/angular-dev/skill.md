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
  // Signal-based inputs
  data = input<DataType[]>([]);

  // Signal-based outputs
  dataChange = output<DataType>();

  // Internal state with signals
  loading = signal(false);

  // Computed values
  filteredData = computed(() => this.data().filter(d => d.active));

  // Linked signals (derived state that can be overwritten)
  selectedItem = linkedSignal(() => this.data()[0]);

  // Services via inject()
  private readonly service = inject(ExampleService);

  constructor() {
    // Effects for side effects (logging, localStorage, etc.)
    effect(() => {
      console.log('Data changed:', this.data());
    });
  }
}
```

## Template Syntax

- Use `@if` / `@else` instead of `*ngIf`
- Use `@for` with `track` instead of `*ngFor`
- Use `@switch` / `@case` instead of `ngSwitch`

```html
@if (loading()) {
  <mat-spinner></mat-spinner>
} @else {
  @for (item of items(); track item.id) {
    <div>{{ item.name }}</div>
  }
}
```

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
- Use `trackBy` / `track` in loops
- Lazy load routes where appropriate
- Use OnPush change detection where possible

## Common Commands

```bash
# Install dependencies
npm install

# Development server
npm start

# Build for production
npm run build

# Run tests
npm run test
```
