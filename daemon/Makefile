# Go parameters

GO          = go
GOFMT       = gofmt
BINARY_NAME = videoplatformd

all: test build
build: 
	@$(GO) build -o $(BINARY_NAME) -v
test: 
	@$(GO) test -v ./...
clean: 
	@$(GO) clean
	@rm -f $(BINARY_NAME)
run: build
	@./$(BINARY_NAME)
deps:
	@$(GO) get -u ./...
format: 
	@$(GOFMT) -w $(shell find . -name '*.go')
