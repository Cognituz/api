#!/bin/bash
# Watch out!, intended for use in production
rake setup &&
bundle exec puma -e $RAILS_ENV -b unix://$SOCK_PATH
