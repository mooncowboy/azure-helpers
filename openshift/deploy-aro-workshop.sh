#!/bin/bash
oc new-project $1

oc process openshift//mongodb-persistent \
    -p MONGODB_USER=ratingsuser \
    -p MONGODB_PASSWORD=ratingspassword \
    -p MONGODB_DATABASE=ratingsdb \
    -p MONGODB_ADMIN_PASSWORD=ratingspassword | oc create -f -

oc new-app https://github.com/shoegazerpt/rating-api --strategy=source
oc set env dc rating-api MONGODB_URI=mongodb://ratingsuser:ratingspassword@mongodb.$1.svc.cluster.local:27017/ratingsdb
oc set env dc rating-api PORT=8080

oc new-app https://github.com/shoegazerpt/rating-web --strategy=source
oc set env dc rating-web API=http://rating-api:8080
oc expose svc/rating-web
oc get route rating-web