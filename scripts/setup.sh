#!/bin/bash
# Watch out!, intended for use in production
bundle exec rake \
  db:create \
  db:migrate \
  db:seed \
  assets:clean \
  assets:precompile
