#!/bin/bash
# Watch out!, intended for use in production
"${BASH_SOURCE%/*}/setup.sh" &&
bundle exec puma -e $RAILS_ENV -b unix://$SOCK_PATH 
