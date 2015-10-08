#!/bin/sh -ex

REVISION="$1"
ENVIRONMENT="$2"

test -n "$REVISION"
test -n "$ENVIRONMENT"

eval $(ssh-agent)

ssh-add $HOME/.ssh/id_circleci_github

export REVISION

bundle exec cap $ENVIRONMENT deploy
