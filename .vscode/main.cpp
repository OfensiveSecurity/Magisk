#include <iostream>
#include <vector>

void printMatrix(const std::vector<std::vector<double>>& mat) {
    for (const auto& row : mat) {
        std::cout << "[ ";
        for (double val : row) {
            std::cout << val << " ";
        }
        std::cout << "]\n";
    }
}

int main() {
    // 2D vector configuration
    std::vector<std::vector<double>> matrix = {
        {1.5, 2.5},
        {3.5, 4.5}
    };

    printMatrix(matrix);

    // Calculate matrix determinant (ad - bc)
    double determinant = (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0]);
    std::cout << "Determinant: " << determinant << std::endl;

    return 0;
}