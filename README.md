# Mailgun MTA for Postfix and mailgun-postfix-relay container

## What
This image was created to help legacy applications send e-mail via Mailgun's API.

The image is based on Alpine Linux, and aims to be cloud-native. To that end, it is configured by environment variables and provides a script for readiness checking.

## Why
The recommended approach for legacy applications is to relay e-mail via Mailgun's SMTP server. Unfortunately, using this method will expose your server's IP address. Using the API instead solves this problem.

Some similar software exists such as [stevenolen/mailgun-smtp-server](https://github.com/stevenolen/mailgun-smtp-server), but they don't benefit from Postfix's robust queuing and logging systems. 

## How
The following environment variables are available for configuration

`MG_API_KEY`: Your Mailgun API key

`MG_DOMAIN`: Your Mailgun domain

`MG_URL`: An alternate URL for the Mailgun API (optional)

Standard environment variables such as `HTTPS_PROXY` are also available, as per Go's documentation. 

By default, only the [standard private subnets](https://tools.ietf.org/html/rfc1918) are allowed to send e-mail. To change this and other settings, please create a new image.

## Readiness checking
This image provides a readiness checking script called `queue_size`.

I recommend configuring a readiness check with the command `queue_size 30`, to ensure that the queue size doesn't grow beyond 30 messages.

The script can also be called with no arguments to view the number of queued messages.