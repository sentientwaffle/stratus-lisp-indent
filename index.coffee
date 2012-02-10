stratus = require 'stratus'

hasUnbalancedParens = (editor) ->
  {buffer, cursor} = editor
  
  # We assume that it is a carat and not a selection because this
  # is triggered when the user presses <Enter>.
  {row, col} = cursor.point
  
  # If the cursor is in the middle of the line when <Enter> is
  # pressed, use the text before it.
  line = buffer.text row - 1
  
  p   = line.split("(").length > line.split(")").length
  p ||= line.split("[").length > line.split("]").length
  p ||= line.split("{").length > line.split("}").length
  return p

# `\n` means <Enter>.
stratus.on "fractus.key.\n", (editor) ->
  syntax = editor.syntax?.name
  # Only match Lisp or Racket.
  return unless syntax && /^(Lisp|Racket)\b/.test syntax
  
  if hasUnbalancedParens editor
    editor.cursor.insert editor.tab

