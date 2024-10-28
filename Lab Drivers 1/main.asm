.data
    two real8 2.0           ; ��������� ��� ������� �� 2
    three real8 6.0         ; ��������� ��� 3!

    a real8 ?              ; ���������� a
    x real8 ?               ; ���������� x

    eq1 real8 ?             ; ���������� ��� �������������� ���������� eq1
    eq2 real8 ?             ; ���������� ��� �������������� ���������� eq2

    res real8 ?             ; ���������� ��� ���������� ����������

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

    finit                   ; ������������� FPU

    ; === ���������: sqrt(abs(X - a / 2)) + cos(X * pi / a) ===

    ; Compute sqrt(abs(X - a / 2))

    fld a                   ; �������� a � st(0)
    fdiv two                ; st(0) = a / 2

    fld x                   ; �������� x � st(0)
    fsub st(0), st(1)       ; st(0) = X - (a / 2)

    fabs                    ; abs(st(0))
    fsqrt                   ; sqrt(abs(st(0)))
    fstp eq1                ; ���������� �������������� ���������� � eq1

    ; Compute cos(X * pi / a)
    fldpi                   ; �������� pi � st(0)
    fld a                   ; �������� a � st(0)
    fdiv                    ; st(0) = pi / a
    fld x                   ; �������� x � st(0)
    fmul                    ; st(0) = X * (pi / a)
    fcos                    ; cos(st(0))
    fstp eq2                ; ���������� �������������� ���������� � eq2

    ; ������������ sqrt(abs(X - a / 2)) + cos(X * pi / a)
    fld eq1                 ; �������� eq1 � st(0)
    fld eq2                 ; �������� eq2 � st(0)
    faddp                    ; st(0) = eq1 + eq2 (���������)
   
    ; === �����������: a + X^3 / 3! ===

    ; ���������� X^3 / 3!
    fld x                   ; �������� x � st(0)
    fmul                    ; st(0) = X^2
    fmul                    ; st(0) = X^3
    fld three               ; �������� ��������� 3
    fdiv                    ; st(0) = X^3 / 3!
    fld a
    fadd                    ; a + (X^3 / 3!)


    ; === ��������� �������: ��������� / ����������� ===

    fld eq1
    fld eq2
    faddp

    fxch

    fdiv                    ; st(1) = (���������) / (�����������)

    fstp res                ; ���������� ���������� ����������

    ; ������ ���������� � XMM0
    movq XMM0, res

    ret
ComputeEquation endp
end
