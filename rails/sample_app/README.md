### How to deploy to Heroku.app

1. signup below.
    - https://signup.heroku.com/
2. get heroku-cli
    - https://devcenter.heroku.com/articles/heroku-cli
3. set env, push to deploy

```
$ heroku config:set REPORT_URI_SUBDOMAIN="XXXXXXXX"
$ heroku config:set HEROKU_APP_NAME="XXXXXXXX"
$ git push heroku
```
