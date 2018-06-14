.PHONY: all test clean man fast release install

GO15VENDOREXPERIMENT=1

PROG_NAME := "goxpp"

all: deps test version build install examples

build: deps
	@go build -ldflags "-X main.VERSION=`cat VERSION`" -o ./bin/$(PROG_NAME)-simple ./_examples/simple/*.go

version: deps
	@which $(PROG_NAME)
	@$(PROG_NAME) --version

install: deps
	@go install -ldflags "-X main.VERSION=`cat VERSION`" ./cmd/$(PROG_NAME)
	@$(PROG_NAME) --version

fast: deps
	@go build -i -ldflags "-X main.VERSION=`cat VERSION`-dev" -o ./bin/$(PROG_NAME) ./cmd/$(PROG_NAME)/*.go
	@$(PROG_NAME) --version

deps: deps-ci
	@glide install --strip-vendor

deps-ci:
	@go get -v -u github.com/go-playground/overalls
	@go get -v -u github.com/mattn/goveralls
	@go get -v -u golang.org/x/tools/cmd/cover

test:
	@go test ./pkg/inputs/
	@go test ./pkg/storage/

clean:
	@go clean
	@rm -fr ./bin
	@rm -fr ./dist

release: $(PROG_NAME)
	@git tag -a `cat VERSION`
	@git push origin `cat VERSION`

man:
	@ronn man/textql.1.ronn
