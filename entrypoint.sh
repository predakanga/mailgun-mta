#!/bin/sh

set -e

# Make sure the requisite env vars are set
: ${MG_API_KEY?Please set the MG_API_KEY env var to your Mailgun API key}
: ${MG_DOMAIN?Please set the MG_DOMAIN env var to your Mailgun domain}

exec postfix start-fg
