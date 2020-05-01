package main

import (
	"context"
	"github.com/mailgun/mailgun-go/v4"
	"log"
	"os"
	"time"
)

func main() {
	log.SetFlags(0)
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %v recipient...", os.Args[0])
	}

	mg, err := mailgun.NewMailgunFromEnv()
	if err != nil {
		log.Fatalf("Error creating mailgun client: %v", err)
	}

	message := mg.NewMIMEMessage(os.Stdin, os.Args[1:]...)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second * 30)
	defer cancel()

	resp, id, err := mg.Send(ctx, message)
	if err != nil {
		log.Fatalf("4.0.0 Error sending message: %v", err)
	}

	log.Printf("%v %v", resp, id)
}
