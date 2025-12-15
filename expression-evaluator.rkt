#lang racket

;; =============================================================================
;; Either/Result type definitions
;; =============================================================================
(provide (all-defined-out))

(define success 'success)
(define failure 'failure)

(define (from-success default-val result)
  (if (and (list? result) (equal? (first result) success))
      (second result)
      default-val))

(define (from-failure default-val result)
  (if (and (list? result) (equal? (first result) failure))
      (second result)
      default-val))

;; =============================================================================
;; Helper functions
;; =============================================================================

(define (safe-div x y) ; num num -> either num
  (if (= y 0)
      (list failure "Division by zero")
      (list success (/ x y))))

(define in-list? ; item list -> bool
  (λ (x lst)
     (not (false? (member x lst)))))

;; Check if a string is a valid identifier
(define (valid-id? s)
  (and (symbol? s)
       (let ([str (symbol->string s)])
         (and (> (string-length str) 0)
              (char-alphabetic? (string-ref str 0))
              (andmap (λ (c) (or (char-alphabetic? c)
                                 (char-numeric? c)
                                 (equal? c #\-)
                                 (equal? c #\_)))
                      (string->list str))))))

;; =============================================================================
;; Environment/State management
;; =============================================================================

;; The state is a hash table mapping symbols to values
;; Special value 'undefined indicates a defined but unassigned variable

(define (make-empty-env)
  (make-immutable-hash '()))

(define (env-has? env id)
  (hash-has-key? env id))

(define (env-get env id)
  (hash-ref env id #f))

(define (env-add env id val)
  (hash-set env id val))

(define (env-remove env id)
  (hash-remove env id))

;; =============================================================================
;; Evaluator
;; =============================================================================

(define (eval expr env)
  ;; Returns: (list (either value) new-env)
  (cond
    ;; num expression
    [(equal? (first expr) 'num)
     (list (list success (second expr)) env)]
    
    ;; id expression - look up value in environment
    [(equal? (first expr) 'id)
     (let ([id (second expr)])
       (if (not (valid-id? id))
           (list (list failure (format "Invalid identifier: ~a" id)) env)
           (if (not (env-has? env id))
               (list (list failure (format "Identifier not defined: ~a" id)) env)
               (let ([val (env-get env id)])
                 (if (equal? val 'undefined)
                     (list (list failure (format "Identifier ~a is undefined" id)) env)
                     (list (list success val) env))))))]
    
    ;; define expression
    [(equal? (first expr) 'define)
     (let ([id (second expr)])
       (if (not (valid-id? id))
           (list (list failure (format "Invalid identifier: ~a" id)) env)
           (if (env-has? env id)
               (list (list failure (format "Identifier ~a already defined" id)) env)
               (if (= (length expr) 2)
                   ;; define without value
                   (list (list success (format "Defined ~a (undefined)" id))
                         (env-add env id 'undefined))
                   ;; define with value
                   (let* ([result-pair (eval (third expr) env)]
                          [result (first result-pair)]
                          [new-env (second result-pair)])
                     (if (equal? (first result) failure)
                         (list result env) ; return failure with original env
                         (list (list success (format "Defined ~a = ~a" id (second result)))
                               (env-add env id (second result)))))))))]
    
    ;; assign expression
    [(equal? (first expr) 'assign)
     (let ([id (second expr)])
       (if (not (valid-id? id))
           (list (list failure (format "Invalid identifier: ~a" id)) env)
           (if (not (env-has? env id))
               (list (list failure (format "Cannot assign to undefined identifier: ~a" id)) env)
               (let ([current-val (env-get env id)])
                 (if (not (equal? current-val 'undefined))
                     (list (list failure (format "Identifier ~a already has a value (immutable)" id)) env)
                     ;; evaluate the expression and assign
                     (let* ([result-pair (eval (third expr) env)]
                            [result (first result-pair)]
                            [new-env (second result-pair)])
                       (if (equal? (first result) failure)
                           (list result env) ; return failure with original env
                           (list (list success (format "Assigned ~a = ~a" id (second result)))
                                 (env-add env id (second result))))))))))]
    
    ;; remove expression
    [(equal? (first expr) 'remove)
     (let ([id (second expr)])
       (if (not (valid-id? id))
           (list (list failure (format "Invalid identifier: ~a" id)) env)
           (if (not (env-has? env id))
               (list (list failure (format "Cannot remove undefined identifier: ~a" id)) env)
               (list (list success (format "Removed ~a" id))
                     (env-remove env id)))))]
    
    ;; arithmetic operations: add, sub, mult, div
    [(in-list? (first expr) '(div add sub mult))
     (let* ([result-x-pair (eval (second expr) env)]
            [result-x (first result-x-pair)]
            [env-x (second result-x-pair)])
       (if (equal? (first result-x) failure)
           (list result-x env) ; propagate failure
           (let* ([result-y-pair (eval (third expr) env-x)]
                  [result-y (first result-y-pair)]
                  [env-y (second result-y-pair)])
             (if (equal? (first result-y) failure)
                 (list result-y env) ; propagate failure
                 (let ([x (second result-x)]
                       [y (second result-y)])
                   (cond
                     [(equal? (first expr) 'div)
                      (let ([div-result (safe-div x y)])
                        (if (equal? (first div-result) failure)
                            (list div-result env)
                            (list div-result env-y)))]
                     [(equal? (first expr) 'add)
                      (list (list success (+ x y)) env-y)]
                     [(equal? (first expr) 'sub)
                      (list (list success (- x y)) env-y)]
                     [(equal? (first expr) 'mult)
                      (list (list success (* x y)) env-y)]))))))]
    
    ;; unknown operation
    [else
     (list (list failure (format "Unknown operation: ~a" (first expr))) env)]))

;; =============================================================================
;; REPL
;; =============================================================================

(define (print-result result)
  (if (equal? (first result) success)
      (displayln (format "Success: ~a" (second result)))
      (displayln (format "Error: ~a" (second result)))))

(define (print-env env)
  (displayln "Current environment:")
  (if (= (hash-count env) 0)
      (displayln "  (empty)")
      (for ([(k v) (in-hash env)])
        (displayln (format "  ~a = ~a" k v)))))

(define (repl)
  (define (repl-loop env)
    (display "\n> ")
    (flush-output)
    (let ([input (read)])
      (cond
        [(eof-object? input)
         (displayln "\nGoodbye!")]
        [(equal? input 'quit)
         (displayln "Goodbye!")]
        [(equal? input 'env)
         (print-env env)
         (repl-loop env)]
        [(not (list? input))
         (displayln "Error: Expression must be a list")
         (repl-loop env)]
        [else
         (let* ([result-pair (eval input env)]
                [result (first result-pair)]
                [new-env (second result-pair)])
           (print-result result)
           (repl-loop new-env))])))
  
  (displayln "Expression Evaluator with Environment")
  (displayln "Commands: (quit) to exit, (env) to show environment")
  (displayln "Examples:")
  (displayln "  '(num 5)")
  (displayln "  '(define x (num 10))")
  (displayln "  '(add (id x) (num 5))")
  (displayln "  '(assign y (mult (id x) (num 2)))")
  (displayln "  '(remove x)")
  (repl-loop (make-empty-env)))

;; =============================================================================
;; Test cases
;; =============================================================================

(define (run-tests)
  (displayln "\n=== Running Tests ===\n")
  
  (define env0 (make-empty-env))
  
  ;; Test 1: Basic numeric expression
  (displayln "Test 1: (num 5)")
  (let ([result (eval '(num 5) env0)])
    (print-result (first result))
    (displayln ""))
  
  ;; Test 2: Arithmetic
  (displayln "Test 2: (add (num 5) (mult (num 2) (num 3)))")
  (let ([result (eval '(add (num 5) (mult (num 2) (num 3))) env0)])
    (print-result (first result))
    (displayln ""))
  
  ;; Test 3: Division by zero
  (displayln "Test 3: (div (num 5) (sub (num 5) (num 5)))")
  (let ([result (eval '(div (num 5) (sub (num 5) (num 5))) env0)])
    (print-result (first result))
    (displayln ""))
  
  ;; Test 4: Define variable
  (displayln "Test 4: (define a (num 10))")
  (let* ([result (eval '(define a (num 10)) env0)]
         [env1 (second result)])
    (print-result (first result))
    
    ;; Test 5: Use defined variable
    (displayln "\nTest 5: (add (id a) (num 5))")
    (let ([result2 (eval '(add (id a) (num 5)) env1)])
      (print-result (first result2))
      (displayln "")))
  
  ;; Test 6: Define without value, then assign
  (displayln "Test 6: (define b), then (assign b (num 20))")
  (let* ([result1 (eval '(define b) env0)]
         [env1 (second result1)])
    (print-result (first result1))
    (let* ([result2 (eval '(assign b (num 20)) env1)]
           [env2 (second result2)])
      (print-result (first result2))
      
      ;; Test 7: Use assigned variable
      (displayln "\nTest 7: (mult (id b) (num 3))")
      (let ([result3 (eval '(mult (id b) (num 3)) env2)])
        (print-result (first result3))
        (displayln ""))))
  
  ;; Test 8: Remove variable
  (displayln "Test 8: Define c, remove c, try to use c")
  (let* ([result1 (eval '(define c (num 5)) env0)]
         [env1 (second result1)])
    (print-result (first result1))
    (let* ([result2 (eval '(remove c) env1)]
           [env2 (second result2)])
      (print-result (first result2))
      (let ([result3 (eval '(id c) env2)])
        (print-result (first result3))
        (displayln ""))))
  
  ;; Test 9: Error cases
  (displayln "Test 9: Try to use undefined variable")
  (let ([result (eval '(id xyz) env0)])
    (print-result (first result))
    (displayln ""))
  
  (displayln "Test 10: Try to redefine variable")
  (let* ([result1 (eval '(define d (num 5)) env0)]
         [env1 (second result1)])
    (print-result (first result1))
    (let ([result2 (eval '(define d (num 10)) env1)])
      (print-result (first result2))
      (displayln "")))
  
  (displayln "=== Tests Complete ===\n"))

;; Uncomment to run tests
;; (run-tests)

;; Uncomment to start REPL
;; (repl)
