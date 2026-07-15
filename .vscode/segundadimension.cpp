include <iostream>

int main() {
    // Declaring and initializing a 2x2 matrix
    double matrix[2][2] = {
        {1.0, 2.0}, // Row 0 (contains a and b)
        {3.0, 4.0}  // Row 1 (contains c and d)
    };

    // Accessing individual coordinates:
    double a = matrix[0][0];
    double b = matrix[0][1];
    double c = matrix[1][0];
    double d = matrix[1][1];

    // Formatted output to duplicate standard matrix notation
    std::cout << "[" << a << " " << b << "]\n";
    std::cout << "[" << c << " " << d << "]\n";

    return 0;
}