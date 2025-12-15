CXX = g++
CXXFLAGS = -std=c++23 -g -Wall -pthread
CPPFLAGS = -I$(INC_DIR)

SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build
BIN_DIR = $(BUILD_DIR)/bin
OBJ_DIR = $(BUILD_DIR)/obj

# Исходники сервера (без peer_main.cpp)
SERVER_SRCS = $(filter-out $(SRC_DIR)/peer_main.cpp, $(wildcard $(SRC_DIR)/*.cpp))
SERVER_OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SERVER_SRCS))

# Исходники пира (общие модули + peer_main.cpp)
PEER_SRCS = $(SRC_DIR)/peer_main.cpp $(SRC_DIR)/logger.cpp $(SRC_DIR)/ipc.cpp
PEER_OBJS = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(PEER_SRCS))

SERVER = $(BIN_DIR)/server
PEER = $(BIN_DIR)/peer

all: $(SERVER) $(PEER)

$(SERVER): $(SERVER_OBJS) | $(BIN_DIR)
    @echo "Linking server..."
    @$(CXX) $(CXXFLAGS) -o $@ $^

$(PEER): $(PEER_OBJS) | $(BIN_DIR)
    @echo "Linking peer..."
    @$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
    @echo "Compiling $<..."
    @$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<

$(BIN_DIR) $(OBJ_DIR):
    @mkdir -p $@

clean:
    @echo "Cleaning..."
    @rm -rf $(BUILD_DIR)

# Создать необходимые директории
dirs:
    @mkdir -p static/error server_init_files temp data

.PHONY: all clean dirs