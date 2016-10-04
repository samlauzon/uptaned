
CC = gcc
CFLAGS = -Wall -fpic 
LDFLAGS = 
TARGET = uptaned
PREFIX = /usr/sbin
#OBJS = src/uptaned.o 
OBJS = $(patsubst src/%.c,src/%.o,$(wildcard src/*.c))

%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

build: $(OBJS)
	$(CC) $(LDFLAGS) -o $(TARGET) $(OBJS) 

all: $(build)

install: $(build)
	install -D $(TARGET) $(PREFIX)/$(TARGET) 
	install -D ./scripts/uptaned /etc/init.d/uptaned
	-ln -sf /etc/init.d/uptaned /etc/rc2.d/S99uptaned

reinstall: $(build)
	install -D $(TARGET) $(PREFIX)/$(TARGET) 
	systemctl daemon-reload


deb: $(all) 
	fakeroot dpkg-buildpackage -B

uninstall:
	-rm -f $(PREFIX)/$(TARGET) 
	-rm -f /etc/init.d/uptaned
	-rm -f /etc/rc2.d/S99uptaned


clean: 
	rm $(OBJS) $(TARGET) 

