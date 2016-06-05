CREATEINTERFACE_OBJS=common.o createinterface.o env.o
CREATESOURCE_OBJS=common.o createsource.o env.o
CREATEDIST_OBJS=common.o createdist.o env.o
DIST=createinterface createsource createdist

all: $(DIST)

createinterface: $(CREATEINTERFACE_OBJS)
	gcc $(CREATEINTERFACE_OBJS) -lm -lpthread -o $@

%.o:%.d
	gdc -c $< -o $@

createsource: $(CREATESOURCE_OBJS)
	gdc $(CREATESOURCE_OBJS) -lm -lpthread -o $@

createdist: $(CREATEDIST_OBJS)
	gdc $(CREATEDIST_OBJS) -lm -lpthread -o $@

clean:
	rm -f *.o $(DIST)

dist:
	zip createxpcom.zip $(DIST)

distsource:
	zip source.zip *.d Makefile* *.txt

install:
	cp $(DIST) /usr/local/bin

uninstall:
	cd /usr/local/bin&&rm $(DIST)
