CPPFLAGS=$(shell llvm-config --cxxflags)
LDFLAGS=$(shell llvm-config --ldflags --libs)

kaleidoscope: lex.yy.o parser.tab.o ast.o
	clang++ $(LDFLAGS) -Wall -o $@ $^

lex.yy.o: lex.yy.c parser.tab.hpp ast.hpp
	clang++ $(CPPFLAGS) -Wno-deprecated -Wall -c -o $@ $<

lex.yy.c: lexer.lex
	flex $<

parser.tab.o: parser.tab.cpp parser.tab.hpp ast.hpp
	clang++ $(CPPFLAGS) -Wall -c -o $@ $< 

parser.tab.cpp parser.tab.hpp: parser.ypp 
	bison -dv $< 

ast.o:	ast.cpp ast.hpp
	clang++ $(CPPFLAGS) -Wall -c -o $@ $<

.PHONY: clean

clean:
	rm -f *.yy.* *.tab.* *.o *.output *.s *.ll
