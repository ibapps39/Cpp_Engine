// find a c++ makefile template .
// Source: https://stackoverflow.com/a/69233940 .
Appname := App
#Output Dir for Object and dependency files
ObjectsDir := ./Objects

#Find all the source files
SrcFiles := $(shell find . -name "*.cpp")
#Create a variable holding all the objects
Objects := $(patsubst %.cpp,$(ObjectsDir)/%.o,$(SrcFiles))

#Compiler Flags
CXX = g++
CXXFLAGS = -Wall -std=c++20 -fsanitize=address  
CPPFLAGS = -DDEBUG -I ./Game/Headers -I ./Engine/Headers -I ./Engine/Headers/External
LDLIBS = $(shell sdl2-config --libs) -l dl

.PHONY: all

all : $(Appname)

#Link the object files
$(Appname) : $(Objects)
    $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(Objects) -o $(Appname) $(LDLIBS)

#Rule: For every object file require a dependency file and a C++ file
#1. Create the Folder
#2. Create Dependency File
#3. Create Object File
$(ObjectsDir)/%.o: %.cpp
    mkdir -p $(@D)
    $(CXX) $(CXXFLAGS) $(CPPFLAGS) -MMD -MP -c $< -o $@ $(LDLIBS)

clean:
    rm -rf $(ObjectsDir)

run:
    ./$(Appname)

#Include the dependency files
Deps = $(Objects:%.o=%.d)
-include $(Deps)
