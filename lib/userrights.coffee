# Defines a user's rights.

module.exports =
  edit_news: (user, groups) ->
    groups.some (group) ->
      group.title is 'News Editors'
