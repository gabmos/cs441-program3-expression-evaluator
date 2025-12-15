# LLM Prompts for CS 441 Program 3

## Initial Project Setup Prompt

**Prompt to LLM:**
```
I need to build a Racket expression evaluator with environment management for CS 441 Program 3. 

Requirements:
1. Convert the existing Maybe-based evaluator to use Either/Result type that returns (success x) or (failure x)
2. Add state/environment management to track variables (id-value pairs)
3. Implement operations: define, assign, remove, and id for variable management
4. Variables must follow naming rules: start with letter, contain letters/digits/hyphens/underscores
5. Implement a REPL loop that prompts for expressions and displays results
6. Data should be immutable - once assigned, variables cannot be reassigned

The evaluator should support:
- Numeric expressions: '(num 5)
- Arithmetic: '(add ...) '(sub ...) '(mult ...) '(div ...)
- Variables: '(define x (num 10)), '(id x), '(assign x ...), '(remove x)
- Proper error handling with descriptive messages
- State threading through all evaluations

Please create a complete implementation with tests.
```

## Follow-up Prompts

### Hash Table Error Fix
**Prompt:**
```
I'm getting this error: "hash-set: contract violation expected: (and/c hash? immutable?)"
The hash table needs to be immutable. Can you fix the make-empty-env function?
```

### Testing Improvements
**Prompt:**
```
Add comprehensive test cases that cover:
- Basic arithmetic operations
- Variable definition, assignment, and removal
- Error cases (undefined variables, redefinition attempts, division by zero)
- Nested expressions with variables
```

### REPL Enhancement
**Prompt:**
```
Add a special command (env) to the REPL that displays the current environment state.
Also add helpful startup messages explaining available commands and syntax.
```

### Documentation
**Prompt:**
```
Create a comprehensive README.md that explains:
- How to run the program and tests
- Complete expression grammar
- Examples of all operations
- Error handling behavior
- Implementation details about state management and Either type
```

## Additional Prompts Used

### Identifier Validation
**Prompt:**
```
Implement a valid-id? function that checks if a symbol:
1. Starts with an alphabetic character
2. Contains only letters, digits, hyphens, or underscores
Return false if it doesn't meet these criteria.
```

### Error Message Formatting
**Prompt:**
```
Make error messages more descriptive. Include the identifier name and specific reason
for failure (e.g., "Identifier x already defined" instead of just "error").
```

### State Threading
**Prompt:**
```
Ensure that when an operation fails, the original environment is returned unchanged.
When operations succeed, the updated environment should be threaded through to the
next operation. This should work correctly in nested expressions.
```

## Prompts for Debugging

### Division by Zero
**Prompt:**
```
The division operation should return (failure "Division by zero") instead of throwing
an exception. Update safe-div to return an Either type.
```

### Environment Lookup
**Prompt:**
```
When looking up an id, we need to distinguish between three cases:
1. ID doesn't exist in environment -> error
2. ID exists but is undefined -> error 
3. ID exists with a value -> return the value
Fix the id lookup logic.
```

## Reflection Prompts

**Prompt:**
```
Review the complete implementation and check for:
- Consistent error handling across all operations
- Proper state threading in nested expressions
- Edge cases (empty environment, recursive definitions, etc.)
- Code clarity and documentation
```
