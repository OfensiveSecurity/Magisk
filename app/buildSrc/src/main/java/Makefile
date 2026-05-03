# Variables del compilador
CXX = g++
CXXFLAGS = -std=c++17 -Wall -O2

# Nombre del ejecutable final
TARGET = super_cifrador

# Lista de archivos fuente
SRCS = main.cpp ARC4.cpp

# Lista de archivos de objetos (se generan automáticamente)
OBJS = $(SRCS:.cpp=.o)

# Regla principal: Compilar el proyecto
all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)
	@echo "-------------------------------------------"
	@echo " PROYECTO COMPILADO CON EXITO: ./$(TARGET) "
	@echo "-------------------------------------------"

# Regla para compilar archivos .cpp en .o
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Regla para limpiar archivos temporales
clean:
	rm -f $(OBJS) $(TARGET)
	@echo "Archivos temporales eliminados."

# Regla para ejecutar el programa directamente
run: all
	./$(TARGET)
