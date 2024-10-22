.data
    two real8 2.0           ; Константа для деления на 2
    three real8 6.0         ; Константа для 3!

    a real8 ?              ; Переменная a
    x real8 ?               ; Переменная x

    eq1 real8 ?             ; Переменная для промежуточного результата eq1
    eq2 real8 ?             ; Переменная для промежуточного результата eq2

    res real8 ?             ; Переменная для финального результата

.code
public ComputeEquation

ComputeEquation proc
    ; extern "C" double Calculate_Func(double a, double x);
	; Input: 
	;   a -> XMM0
	;   x -> XMM1
	; Output:
	;   Result -> XMM0

    movsd a, XMM0
	movsd x, XMM1

    finit                   ; Инициализация FPU

    ; === Числитель: sqrt(abs(X - a / 2)) + cos(X * pi / a) ===

    ; Compute sqrt(abs(X - a / 2))

    fld a                   ; Загрузка a в st(0)
    fdiv two                ; st(0) = a / 2

    fld x                   ; Загрузка x в st(0)
    fsub st(0), st(1)       ; st(0) = X - (a / 2)

    fabs                    ; abs(st(0))
    fsqrt                   ; sqrt(abs(st(0)))
    fstp eq1                ; Сохранение промежуточного результата в eq1

    ; Compute cos(X * pi / a)
    fldpi                   ; Загрузка pi в st(0)
    fld a                   ; Загрузка a в st(0)
    fdiv                    ; st(0) = pi / a
    fld x                   ; Загрузка x в st(0)
    fmul                    ; st(0) = X * (pi / a)
    fcos                    ; cos(st(0))
    fstp eq2                ; Сохранение промежуточного результата в eq2

    ; Суммирование sqrt(abs(X - a / 2)) + cos(X * pi / a)
    fld eq1                 ; Загрузка eq1 в st(0)
    fld eq2                 ; Загрузка eq2 в st(0)
    faddp                    ; st(0) = eq1 + eq2 (числитель)
   
    ; === Знаменатель: a + X^3 / 3! ===

    ; Вычисление X^3 / 3!
    fld x                   ; Загрузка x в st(0)
    fmul                    ; st(0) = X^2
    fmul                    ; st(0) = X^3
    fld three               ; Загрузка константы 3
    fdiv                    ; st(0) = X^3 / 3!
    fld a
    fadd                    ; a + (X^3 / 3!)


    ; === Финальное деление: числитель / знаменатель ===

    fld eq1
    fld eq2
    faddp

    fxch

    fdiv                    ; st(1) = (числитель) / (знаменатель)

    fstp res                ; Сохранение финального результата

    ; Запись результата в XMM0
    movq XMM0, res

    ret
ComputeEquation endp
end
