PKG = capture_fd

all: $(PKG).so

$(PKG).so: $(PKG).c
	R CMD SHLIB $(PKG).c

clean:
	rm -f $(PKG).so $(PKG).o
