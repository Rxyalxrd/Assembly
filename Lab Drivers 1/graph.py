import numpy as np
import matplotlib.pyplot as plt
from math import factorial


def f(x, a=1, n=3):
    numerator = np.sqrt(np.abs(x - a / 2)) + np.cos(x * np.pi / a)
    denominator = a + (x**n) / factorial(n)
    return numerator / denominator


x_values_f = np.linspace(-1, 1, 500)
y_values_f = f(x_values_f)


x_values_g = []
y_values_g = []

with open("result.txt", "r") as file:
    for line in file:
        x, y = map(float, line.split())

        if abs(y) > 1e10:
            continue

        x_values_g.append(x)
        y_values_g.append(y)


plt.style.use('dark_background')

plt.plot(
    x_values_f, y_values_f, color='cyan',
    linewidth=2, label='f(x) - python func'
)
plt.plot(
    x_values_g, y_values_g, color='magenta',
    linewidth=2, label='g(x) - asm func'
)


plt.axhline(0, color='white', linewidth=0.8)
plt.axvline(0, color='white', linewidth=0.8)


plt.title('Сравнение функции и данных из файла', color='white', fontsize=16)
plt.xlabel('X', color='white')
plt.ylabel('Y', color='white')
plt.grid(True, color='gray', linestyle='--', linewidth=0.5)

plt.xticks(color='white')
plt.yticks(color='white')


plt.legend()
plt.show()
