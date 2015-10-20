$ = require 'jquery'
_ = require 'underscore'
hi = require 'hi'

$ ->
  _.each [undefined, 'Anonymous'], (name) ->
    console.log hi(name)
