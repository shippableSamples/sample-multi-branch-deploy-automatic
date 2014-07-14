#!/bin/bash
curl -s "http://${STAGING_APP_NAME}.herokuapp.com/" | grep 'Hello world'
