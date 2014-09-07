
CC = gcc -g
LEX = flex
YACC = bison

all:format index format_str index_json

format:	sql.tab.o sql.o adlist.o format.o func.h
	${CC} -o format format.o sql.tab.o sql.o adlist.o

format.o:CFLAGS+= -D__FORMAT__
format.o:format.c

format2.o:format.c
	gcc -g -c -o format2.o format.c

format_str:	sql.tab.o sql.o adlist.o format_str.o
	${CC} -o format_str format_str.o sql.tab.o sql.o adlist.o

format_str.o: format_str.c

index_json: sql.tab.o sql.o adlist.o index.o format2.o index_json.o
	${CC} -o index_json index_json.o sql.tab.o sql.o adlist.o format2.o

index_json.o:index_json.c

index: sql.tab.o sql.o adlist.o index.o format2.o
	${CC} -o index index.o sql.tab.o sql.o adlist.o format2.o

index.o:index.c

sql.tab.o:CFLAGS += -DYYDEBUG

sql.tab.c sql.tab.h:	sql.y
	${YACC} -vd sql.y

sql.c:	sql.l
	${LEX} -o $@ $<

sql.o: sql.c sql.tab.h

clean:
	rm -f format used_index sql.tab.c sql.tab.h sql.c sql.tab.o sql.o *.o sql.output index index_json format_str format_file

.SUFFIXES:	.l .y .c

