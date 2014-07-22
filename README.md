Sample for automatic deployment to multiple environments
========================================================

This sample demonstrates how to setup continuous integration and deployment of an Express+MongoDB
project with multiple Heroku environments. After the build is triggered by the webhook and the
project builds successfully, it is first deployed to the staging environment (a separate Heroku app).

Then, the commit is automatically pushed to a special branch called `production`. This triggers another
Shippable build, but this time `BRANCH` environment variable is set to `production`. In this second
build, we can use different testing logic, e.g. by performing functional tests on the staging instance.

For example, in this (minimal) sample, we perform 'smoke test' of the staging deployment, by checking if
the home page of the application gets displayed properly. If this test succeeds, we automatically 
proceed to deploy the application to the production environment.

Shippable configuration
-----------------------

To be able to deploy to two Heroku applications, we need to add two separate remotes: `staging`, 
`production`. This is done here in `before_install` step:

    - git remote -v | grep ^staging || heroku git:remote --remote staging --app $STAGING_APP_NAME
    - git remote -v | grep ^production || heroku git:remote --remote production --app $PROD_APP_NAME

Then, in `script` step, we can check the current branch and run the relevant test logic.

    script:
      - >
        [[ $BRANCH = 'production' ]] && ./smoke_test.sh || npm test

(note that we use `>`, so square brackets don't get interpreted by YAML parser)

Finally, in the `after_success` step, we push the code to the correct Heroku remote. After this, we
launch the `push_to_production.sh` script that is included in this repository. This script does not
do anything if already launched on `production` branch. Otherwise, it modifies the `production` branch
to point to the current commit and updates the source GitHub repo.

    - >
      [[ $BRANCH = 'production' ]] && REMOTE=production || REMOTE=staging
    - git push -f $REMOTE master
    - ./push_to_production.sh

For more detailed documentation on Heroku deployment, please see Shippable's continuous
deployment section: http://docs.shippable.com/en/latest/config.html#continuous-deployment

This sample is built for Shippable, a docker based continuous integration and deployment platform.
