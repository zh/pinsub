# PinSub - PinBoard PuSH subscriber

PubSubHubbub subscriber for the PinBoards tags RSS feeds.

## Needed gems (.gems)

    sinatra
    sequel
    simple-rss

## Heroku config (environment variables)

    heroku config:add AUSER=admin
    heroku config:add APASS=secret

## Usage

In the PuSH hub (I prefer Superfeedr) subscription form enter:

* Action: *subscribe*
* Topic: *http://feeds.pinboard.in/rss/t:{some_topic}*
* Callback: *http://{you_domain}/sub/{some_topic}*

Separate topics will be available on URLs: *http://{you_domain}/t/{some_topic}*

The script can be seen in action on URL: http://pinsub.heroku.com/
