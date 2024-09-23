# Use the official Golang image to build the app
FROM golang:1.20 as builder

# Set the current working directory inside the container
WORKDIR /app

# Copy the main.go file to the container
COPY main.go .

# Build the Go app as a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app main.go

# Use a lightweight image for the final container
FROM alpine:3.18

# Set up certificates (optional, useful for HTTPS)
RUN apk add --no-cache ca-certificates

# Set the working directory inside the new image
WORKDIR /root/

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/app .

# Expose port 80 to the outside world
EXPOSE 80

# Command to run the app
CMD ["./app"]
