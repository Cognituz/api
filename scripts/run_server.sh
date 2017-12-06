#!/bin/bash
# Watch out!, intended for use in production
rake db:migrate &&
bundle exec puma -e $RAILS_ENV -b unix://$SOCK_PATH
