# CS 441 Program 3: Expression Evaluator with Environment

**Student:** Gabriel Morais (Senior, Computer Science)  
**Course:** CS 441  
**Assignment:** Program 3 - Expression Evaluator with Environment

A Racket-based expression evaluator that supports variable management and stateful computation using Either/Result types instead of Maybe.

**Development Note:** This project was developed with AI assistance (GitHub Copilot with Claude Sonnet 4.5), but the AI did not do the work for me. I provided detailed requirements, reviewed all code, identified and fixed bugs, validated functionality, and ensured deep understanding of all concepts.

## Features

- **Either/Result Type System**: Returns `(success value)` or `(failure message)` instead of Maybe's `(just value)` or `#<nothing>`
- **Environment Management**: Maintains state of defined variables and their values
- **Variable Operations**:
  - `define`: Create new variables (with or without initial values)
  - `assign`: Assign values to undefined variables (immutable data)
  - `remove`: Remove variables from environment
  - `id`: Reference variable values in expressions
- **Arithmetic Operations**: `add`, `sub`, `mult`, `div` with proper error handling
- **Interactive REPL**: Read-Eval-Print Loop for interactive expression evaluation

## Usage

### Running Tests

```bash
racket -e '(require "expression-evaluator.rkt") (run-tests)'
```

### Starting the REPL

Edit the file and uncomment the last line:
```racket
(repl)
```

Then run:
```bash
racket expression-evaluator.rkt
```

Or from the REPL:
```bash
racket
> (require "expression-evaluator.rkt")
> (repl)
```

### REPL Commands

- `(quit)` - Exit the REPL
- `(env)` - Display current environment state
- Any expression to evaluate

## Expression Grammar

### Numeric Literals
```racket
'(num 5)
```

### Arithmetic Operations
```racket
'(add (num 5) (num 3))        ; 5 + 3 = 8
'(sub (num 10) (num 4))       ; 10 - 4 = 6
'(mult (num 3) (num 7))       ; 3 * 7 = 21
'(div (num 20) (num 4))       ; 20 / 4 = 5
```

### Variable Management

#### Define (with value)
```racket
'(define x (num 10))          ; Define x and assign 10
```

#### Define (without value)
```racket
'(define y)                   ; Define y as undefined
```

#### Assign
```racket
'(assign y (num 20))          ; Assign 20 to previously undefined y
```

#### Remove
```racket
'(remove x)                   ; Remove x from environment
```

#### Reference Variable
```racket
'(id x)                       ; Get value of x
'(add (id x) (num 5))        ; Use x in expression
```

## Examples

```racket
> '(define a (num 10))
Success: Defined a = 10

> '(add (id a) (num 5))
Success: 15

> '(define b)
Success: Defined b (undefined)

> '(assign b (mult (id a) (num 2)))
Success: Assigned b = 20

> '(sub (id b) (id a))
Success: 10

> '(remove a)
Success: Removed a

> '(id a)
Error: Identifier not defined: a
```

## Identifier Rules

- Must start with an alphabetic character
- Can contain letters, digits, hyphens (-), and underscores (_)
- Valid examples: `x`, `my-var`, `count_2`, `totalSum`
- Invalid examples: `123`, `_test`, `-var`

## Error Handling

The evaluator returns descriptive errors for:
- Division by zero
- Undefined identifiers
- Redefinition of existing identifiers
- Assignment to non-existent or already-assigned identifiers
- Removal of non-existent identifiers
- Invalid identifier names
- Unknown operations

## Implementation Details

### State Management
- Uses immutable hash tables for functional state management
- State is threaded through all evaluations
- On success: returns updated state
- On failure: returns original state unchanged

### Either/Result Type
```racket
(list success value)    ; Success case
(list failure message)  ; Failure case
```

Helper functions:
- `(from-success default result)` - Extract success value
- `(from-failure default result)` - Extract failure message

### Immutability
- All variables are immutable once assigned
- Can define → assign → use, but cannot reassign
- Must remove and redefine to change a value

## Project Structure

```
program3/
├── expression-evaluator.rkt       # Main implementation with evaluator, REPL, and tests
├── run-repl.rkt                   # Simple launcher to start the REPL
├── README.md                      # This file - complete project documentation
├── QUICK_REFERENCE.md             # Quick reference card for REPL usage
├── LLM_PROMPTS.md                 # Documentation of AI prompts used
├── MACHINE_GENERATED_CODE.md      # Tracking of AI-generated code
└── VIDEO_GUIDE.md                 # Guide for creating the video presentation
```

## Testing

The implementation includes comprehensive tests covering:
- Basic numeric expressions
- Arithmetic operations
- Division by zero handling
- Variable definition and usage
- Variable assignment
- Variable removal
- Error cases (undefined variables, redefinition, etc.)

Run tests with: `racket -e '(require "expression-evaluator.rkt") (run-tests)'`
