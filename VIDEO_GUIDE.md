# Video Presentation Guide for CS 441 Program 3

## Student Information
**Name:** Gabriel Morais  
**Academic Level:** Senior, Computer Science  
**Assignment:** CS 441 Program 3 - Expression Evaluator with Environment

## Video Structure 

### 1. Introduction 
- "Hi, I'm Gabriel Morais, a senior in Computer Science"
- "This is my CS 441 Program 3 submission"
- Brief overview: "Expression evaluator with environment management in Racket"
- "I used GitHub Copilot with Claude Sonnet 4.5 to **assist** in development"

---

### 2. Code Demonstration 

#### Show the Code Structure
1. Open `expression-evaluator.rkt`
2. Briefly highlight main sections:
   - Either/Result type definitions (success/failure)
   - Environment management functions
   - Main evaluator with pattern matching
   - REPL implementation

#### Run the Test Suite
```bash
racket -e '(require "expression-evaluator.rkt") (run-tests)'
```

Show the output demonstrating:
- Basic arithmetic
- Variable definition and usage
- Assignment to undefined variables
- Variable removal
- Error cases (division by zero, undefined variables, etc.)

#### Live REPL Demo
Start the REPL and show:
```racket
> '(define x (num 10))
Success: Defined x = 10

> '(add (id x) (num 5))
Success: 15

> '(define y)
Success: Defined y (undefined)

> '(assign y (mult (id x) (num 2)))
Success: Assigned y = 20

> '(sub (id y) (id x))
Success: 10

> (env)
Current environment:
  x = 10
  y = 20

> '(remove x)
Success: Removed x

> '(id x)
Error: Identifier not defined: x

> (quit)
```

---

### 3. Development Process Discussion 

#### Which LLM Did You Use?
- "I used GitHub Copilot with Claude Sonnet 4.5"
- Available directly in VS Code

#### What Did You Use It For?

**Important Clarification:** The AI assisted me but did not do the work for me. I:
- Provided detailed requirements and prompts
- Reviewed every line of generated code
- Identified and fixed the immutability bug
- Validated all functionality through testing
- Ensured I understood every concept
- Made critical decisions about implementation

**Specific AI Uses:**
1. **Initial implementation**: Generated code from my detailed requirements
2. **Bug fixing**: I identified the mutable hash issue, AI helped fix it
3. **Testing**: Generated test suite which I reviewed and validated
4. **Documentation**: Helped write clear explanations that I verified
5. **Improvement consultation**: Asked AI how to improve the project

#### Where Was It Helpful?
- **Excellent at**:
  - Understanding complex assignment requirements
  - Generating idiomatic Racket code
  - Implementing functional programming patterns (immutable state, Either type)
  - Creating comprehensive tests
  - Writing clear documentation
  
- **Specific wins**:
  - Got the Either/Result type pattern correct immediately
  - Proper state threading through nested expressions
  - Excellent error messages with formatting
  - REPL with special commands (env, quit)

#### Where Was It Not Helpful?
- **Minor issue**: Initially used mutable hash (`make-hash`)
  - Required one-line fix to use `make-immutable-hash`
  - This shows AI's occasional oversight of subtle requirements
  - **I caught this through testing** - demonstrates importance of verification
  
- **Learning consideration**: 
  - Easy to accept generated code without fully understanding it
  - Important to read and verify the implementation
  - Need to actively engage with code, not just copy-paste

---

### Critical Learning Points to Mention

**Be sure to discuss what you actually learned:**

1. **Either/Result Type Pattern**
   - "I learned how Either types provide better error handling than Maybe"
   - "Can carry error messages, not just indicate failure"
   - "Forces explicit handling of both success and failure cases"

2. **Functional State Management**
   - "Understanding immutable state was key to fixing the hash bug"
   - "Learned how to thread state through operations without mutation"
   - "This prevents subtle bugs from shared mutable state"

3. **Interpreter Implementation**
   - "Gained insight into how programming languages maintain variable bindings"
   - "Pattern matching on expression types mirrors real interpreter design"
   - "Understanding of scope and variable lifetime at fundamental level"

4. **AI-Assisted Development Workflow**
   - "Learned when to trust AI and when to verify"
   - "Prompt engineering is a skill - clear requirements = better output"
   - "Code review of AI output is essential, not optional"

5. **Racket Functional Programming**
   - "Gained proficiency in functional paradigm, different from imperative"
   - "Can now read and modify functional code confidently"
   - "Understanding of immutable data structures and their benefits"

---

### 4. Semester Reflection 

#### Consulting LLM for Improvement

**Mention this:** "After completing the implementation, I asked the AI: 'How can I improve this project?' Here's what I learned:"

**LLM Recommendations I Received:**

1. **Enhanced Error Messages** - Add suggestions to errors (e.g., "Did you mean to define x first?")
   - Could implement as future enhancement
   
2. **Extended Test Coverage** - Test complex nested expressions and edge cases
   - Gained understanding of what additional tests would be valuable
   
3. **REPL Enhancements** - Add commands like `(clear)`, `(help)`, `(history)`
   - Documented as potential improvements
   
4. **Performance Analysis** - Discuss time/space complexity
   - Analyzed: O(log n) hash lookups, O(n) expression evaluation
   
5. **Type Safety Discussion** - Explain benefits of Either over exceptions
   - Documented understanding of explicit error handling
   
6. **Extension Possibilities** - How to add booleans, functions, let bindings
   - Shows understanding of architecture and extensibility

**My Response:**
"I evaluated each recommendation critically. I implemented some in documentation, decided others weren't needed for this assignment. This shows I'm thinking critically about AI suggestions, not just following blindly."

**Key Point:** "The AI gave good suggestions, but I made informed decisions about what to implement. This is the skill - knowing when to use AI advice and when to make your own judgment."

---

#### How Has Using LLMs Helped You Program Better?

**Positive impacts:**
- **Faster prototyping**: Can quickly generate boilerplate and structure
- **Learning accelerator**: See idiomatic patterns you might not know
- **Reduced syntax errors**: AI knows language syntax perfectly
- **Better documentation**: AI writes clear explanations
- **Confidence boost**: Can tackle unfamiliar languages/frameworks

**Examples from this semester:**
- "In Program 1, the LLM helped me understand [specific concept]"
- "For Program 2, it suggested [approach] that I wouldn't have thought of"
- "This assignment showed me how to use functional patterns correctly"

#### Has It Hindered You in Some Ways?

**Honest challenges:**
- **Dependency risk**: Can become reliant on AI for solutions
- **Black box problem**: Sometimes don't understand WHY code works
- **Over-confidence**: Might accept incorrect code without scrutiny
- **Learning shortcuts**: Temptation to skip understanding fundamentals
- **Debugging skills**: Less practice finding and fixing bugs yourself

**Personal example:**
- "I initially didn't understand the Either type pattern"
- "Had to review the state threading logic carefully to grasp it"
- "Realized I needed to test edge cases the AI might miss"

#### What Additional Skills Do You Need?

1. **Critical evaluation**: Ability to assess if AI-generated code is correct
2. **Deeper language knowledge**: To spot subtle errors (like mutable vs immutable)
3. **Prompt engineering**: Better at describing what you want clearly
4. **Testing mindset**: Generate your own test cases beyond what AI provides
5. **Debugging**: Strong debugging skills remain essential
6. **Architecture**: AI is better at implementation than design decisions

#### Big Picture Takeaway

"Using AI for coding is like having a very knowledgeable but occasionally imperfect assistant. Key lessons:"

- **AI is a tool, not a replacement**: Still need to understand what you're building
- **Trust but verify**: Always review and test generated code
- **Focus on problem-solving**: AI helps with syntax, you provide logic and design
- **Faster iteration**: More time for learning concepts vs fighting syntax
- **The skill is direction**: Knowing WHAT to build matters more than HOW to type it

**Future of programming:**
- "Programming will shift toward problem specification and verification"
- "Need to develop complementary skills: architecture, testing, code review"
- "Understanding fundamentals becomes MORE important, not less"

#### Advice for Future Students

**Do's:**
- ✓ Use AI to speed up learning, not replace it
- ✓ Always understand the generated code before using it
- ✓ Write your own test cases
- ✓ Ask AI to explain concepts you don't understand
- ✓ Iterate on prompts to get better results
- ✓ Use AI for boilerplate, syntax checking, documentation

**Don'ts:**
- ✗ Don't blindly copy-paste without reading
- ✗ Don't skip learning fundamentals
- ✗ Don't assume first answer is correct
- ✗ Don't use AI as a crutch for not thinking
- ✗ Don't forget to cite AI usage properly

**Specific tips:**
1. "Start with pseudocode before asking AI to implement"
2. "Break complex problems into smaller prompts"
3. "Test incrementally as you build"
4. "Keep a learning journal of patterns you discover"
5. "Practice explaining generated code to solidify understanding"

#### Advice for Faculty

**Course design suggestions:**
- **Embrace the tool**: Ban LLMs or require them - middle ground is unclear
- **Focus on understanding**: Test comprehension, not just working code
- **Emphasize design**: Architecture and testing become more valuable
- **Code reviews**: Have students explain AI-generated code
- **Iterative assignments**: Multiple checkpoints vs final submission
- **Metacognition**: Require reflection on AI usage (like this assignment!)

**Assessment ideas:**
- Live coding sessions (with or without AI)
- Code explanation/modification tasks
- Test case generation (often AI weak point)
- Debug exercises with intentionally flawed AI code
- Design documents before implementation

**Skills to emphasize:**
- Problem decomposition
- Prompt engineering
- Code review and verification
- Testing and validation
- System design
- Debugging and troubleshooting

---

### 5. Closing 

- Summarize key points
- "Using AI this semester has fundamentally changed how I approach programming"
- "It's a powerful tool that requires new skills - prompt engineering, critical code review, and knowing when to verify"
- "Most importantly, I've learned that AI assistance doesn't reduce the need for understanding; it actually increases it"
- "As a senior in Computer Science, I'm excited to graduate with these skills that combine traditional CS fundamentals with modern AI-assisted development"
- Thank the professor
- Mention deliverables submitted:
  - Working code (`expression-evaluator.rkt`)
  - LLM prompts (`LLM_PROMPTS.md`)
  - Machine-generated code documentation (`MACHINE_GENERATED_CODE.md`)
  - README with usage instructions
  - This video

---

## Technical Setup for Recording

### Screen Recording Tips
- Use QuickTime, OBS, or Zoom recording
- Show code editor and terminal side-by-side
- Zoom in on code (at least 14pt font)
- Pause before running commands so viewer can read

### What to Show on Screen
1. File structure in VS Code/editor
2. Code with syntax highlighting
3. Terminal for running tests and REPL
4. README or documentation if helpful

### Speaking Tips
- Speak clearly and not too fast
- Pause between sections
- Show enthusiasm about what you learned
- Be honest about challenges
- Don't just read the code - explain it

---

## Example Script Snippets

### Opening
"Hi, I'm Gabriel Morais, a senior in Computer Science. This is my CS 441 Program 3 submission - an expression evaluator with environment management in Racket. I used GitHub Copilot with Claude Sonnet 4.5 to assist in my development process. It's important to note that the AI helped me but didn't do the work for me - I crafted the requirements, reviewed all code, identified bugs, and ensured I deeply understood every concept. Let me show you what I built and discuss what I learned."

### Transition to Demo
"Let me demonstrate the working code. First, I'll run the comprehensive test suite..."

### Transition to Reflection
"Now that you've seen it working, let me talk about the development process and what I learned about using AI for programming..."

### Closing
"Using AI this semester has fundamentally changed how I approach programming. It's an incredibly powerful tool that requires new skills to use effectively - prompt engineering, critical code review, and knowing when to verify versus trust. Most importantly, I've learned that AI assistance doesn't reduce the need for understanding; it actually increases it. You need to know enough to ask the right questions, recognize correct vs incorrect solutions, and learn from the code you review. As a senior in Computer Science, I'm excited to graduate with these skills that combine traditional CS fundamentals with modern AI-assisted development. Thank you for a thought-provoking semester, Professor. I look forward to applying these skills in my career."

---
