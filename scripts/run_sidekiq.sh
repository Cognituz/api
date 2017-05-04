#!/bin/bash
# Watch out!, intended for use in production
"${BASH_SOURCE%/*}/setup.sh" &&
bundle exec sidekiq -e $RAILS_ENV -c 2 -q default -q carrierwave
