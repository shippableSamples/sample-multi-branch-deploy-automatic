#!/bin/bash
# Already on the production
[[ $BRANCH = 'production' ]] && exit 0

git branch -f production
ssh-agent bash -c "ssh-add ~/keys/id_${JOB_ID}; git push -f origin production"
