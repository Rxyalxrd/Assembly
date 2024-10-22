#include <iostream>
#include <fstream>

extern "C" double ComputeEquation(double X, double a); // Обновлено: добавлено a в параметры

int main() {
    std::ofstream outFile("result.txt");

    if (!outFile.is_open()) {
        std::cerr << "Error opening file" << std::endl;
        return 1;
    }

    double a = 1.0;
    double X = -1.0;
    double step = 0.1;
    double end = 1.5;

    while (X <= end) {
        double result = ComputeEquation(a, X); // Передаем a в функцию
        outFile << X << " " << result << std::endl;
        X += step;
    }

    outFile.close();
    std::cout << "Results saved to result.txt" << std::endl;

    return 0;
}