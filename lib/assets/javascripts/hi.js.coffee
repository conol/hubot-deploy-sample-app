module.exports = (name) ->
  message = if name then "Hi, #{name}." else "Hi."
  console.log message
