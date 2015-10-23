hi = require 'hi'

describe "hi", ->
  it "should contain value passed as argument", ->
    expect(hi("Name")).toContain("Name")

