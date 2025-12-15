# Quick Reference - Expression Evaluator REPL

## Starting the REPL

```bash
racket run-repl.rkt
```

Or:
```bash
racket
> (require "expression-evaluator.rkt")
> (repl)
```

---

## Special Commands

| Command | Description |
|---------|-------------|
| `(quit)` | Exit the REPL |
| `(env)` | Display current environment |

---

## Expression Syntax

### Numbers
```racket
'(num 5)
'(num 42)
```

### Arithmetic
```racket
'(add (num 5) (num 3))          ; Addition: 5 + 3
'(sub (num 10) (num 4))         ; Subtraction: 10 - 4
'(mult (num 3) (num 7))         ; Multiplication: 3 * 7
'(div (num 20) (num 4))         ; Division: 20 / 4
```

### Variable Definition
```racket
'(define x (num 10))            ; Define x = 10
'(define y)                     ; Define y (undefined)
```

### Variable Assignment
```racket
'(assign y (num 20))            ; Assign 20 to undefined y
```

### Variable Reference
```racket
'(id x)                         ; Get value of x
'(add (id x) (num 5))          ; Use x in expression
```

### Variable Removal
```racket
'(remove x)                     ; Remove x from environment
```

---

## Example Session

```racket
> '(define x (num 10))
Success: Defined x = 10

> '(define y (add (id x) (num 5)))
Success: Defined y = 15

> '(mult (id x) (id y))
Success: 150

> (env)
Current environment:
  x = 10
  y = 15

> '(define z)
Success: Defined z (undefined)

> '(assign z (div (id y) (num 3)))
Success: Assigned z = 5

> '(sub (id y) (id z))
Success: 10

> '(remove x)
Success: Removed x

> '(id x)
Error: Identifier not defined: x

> (quit)
Goodbye!
```

---

## Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `Identifier not defined: x` | Using undefined variable | Define it first |
| `Identifier x already defined` | Redefining existing variable | Remove it first |
| `Division by zero` | Dividing by 0 | Check denominator |
| `Identifier x is undefined` | Using unassigned variable | Assign a value first |
| `Cannot assign to undefined identifier` | Assigning to non-existent var | Define it first |
| `Identifier x already has a value` | Reassigning immutable var | Data is immutable |

---

## Identifier Rules

✓ **Valid:**
- `x`, `y`, `count`
- `my-var`, `total-sum`
- `value_1`, `result_2`
- `camelCase`, `snake_case`

✗ **Invalid:**
- `123` (starts with digit)
- `_test` (starts with underscore)
- `-var` (starts with hyphen)
- `my var` (contains space)

---

## Tips

1. **Quote expressions**: Always use `'(...)` for expressions
2. **Check environment**: Use `(env)` to see current state
3. **Immutable data**: Variables can't be reassigned, must remove first
4. **Test incrementally**: Define variables step by step
5. **Read error messages**: They're descriptive and helpful

---

## Running Tests

```bash
racket -e '(require "expression-evaluator.rkt") (run-tests)'
```

Runs comprehensive test suite covering all operations.
