<!--toc:start-->

- [options in function](#options-in-function)
  - [function call relation](#function-call-relation)
  - [auto_draw options](#autodraw-options)
    - [H.auto_draw](#hautodraw)
  - [get border options](#get-border-options)
    - [H.get_line_indent](#hgetlineindent)
    - [H.cast_ray](#hcastray)
    - [H.border_from_body](#hborderfrombody)
  - [draw_scope options](#drawscope-options)
    - [draw_scope](#drawscope)
    - [make_draw_function](#makedrawfunction)

<!--toc:end-->

# options in function

Only record the options of the plugin

## function call relation

```txt
H.auto_draw -> MiniIndentscope.get_scope -> H.get_line_indent -> H.blank_indent_funs
                                         -> H.cast_ray
                                         -> H.border_from_body
               H.make_autodraw_opts
               H.draw_scope -> H.indicator_compute -> H.scope_get_draw_indent
                            -> H.make_draw_function
                            -> H.draw_indicator_animation
```

## auto_draw options

This option only contained `lazy` field, which is a boolean value, passed by
caller function.

```lua
	au({ "CursorMoved", "CursorMovedI", "ModeChanged" }, "*", function()
		H.auto_draw({ lazy = true })
	end, "Auto draw indentscope lazily")
```

### H.auto_draw

`H.auto_draw = function(opts)`

This function is used in autocmds, when need refresh the scope, call this.

## get border options

This options is created in `get_scope` function

```lua
opts = H.get_config({ options = opts }).options
```

It is similar to user's config

```lua
{
	draw = {
		delay = 100,
		animation = function(s, n)
			return 20
		end,
		priority = 2,
	},
	mappings = {
		object_scope = "ii",
		object_scope_with_border = "ai",
		goto_top = "[i",
		goto_bottom = "]i",
	},
	options = {
		border = "both",
		indent_at_cursor = true,
		try_as_border = false,
	},
	symbol = "╎",
}
```

Then used in three functions as follows.

### H.get_line_indent

`H.get_line_indent = function(line, opts)`

This function is used to get the indent of a line, it has two situations

1. the line is a blank line, the result is computed base on the opts
1. the line is not a blank line, return the indent of the line (same as `indent`
   function)

### H.cast_ray

`H.cast_ray = function(line, indent, direction, opts)`

This function move the pointer to a direction until it meets a line with indent
less than the reference one, can use it to find scope body top and down

### H.border_from_body

`H.border_from_body = function(body, opts)`

This function is used to get the border of a scope, by using the four possible
`border` in opts (none, both, top, bottom), and the `body` table computed in
`get_scope` function by `cast_ray`.

## draw_scope options

This options is provided by `make_autodraw_opts` function

```lua
	local draw_opts = H.make_autodraw_opts(scope)
```

Its content is as follows

```lua
-- default options
{
    event_id = 0,
    type = "animation",
    delay = 100,
    animation_func = function(s, n)
        return 20
    end,
    priority = 2,
}
```

It is only used in the `draw_scope` function.

### draw_scope

`H.draw_scope = function(scope, opts)`

Scope is a table provided by `get_scope`, contains as follows

- `body`: table with `top`, `bottom`, `indent`, inclusive and line numbers start
  at 1.
- `border`: table with `top`, `bottom`, `indent`, might be nil, line numbers
  start at 1.
- `buf_id`: identifier of current buffer.
- `reference` table with `line`, `column`, `indent`. This record the source of
  the scope, which is used to compute the `border` field.

`opts` is a table, which provided by `make_autodraw_opts` function, introduced
above.

### make_draw_function

`H.make_draw_function = function(indicator, opts)`

`indicator` is a table, contains is similar to the options of
`vim.api.nvim_buf_set_extmark()`

- `buf_id`: identifier of current buffer.
- `virtual_text`: char to show.
- `virtual_text_win_col`: column of the virtual text.
- `top`: line number of the virtual text start (equal with body.top).
- `bottom`: line number of the virtual text end (equal with body.bottom).

`opts` is a table, which provided by `make_autodraw_opts` function too, in this
function only use `event_id` field.

This function return a draw function, which is used to draw the specified line
with given indicator, if

1. `event_id` not equal `H.current.event_id`
1. `H.is_disabled` return true
1. the given line not in `indicator.top` and `indicator.bottom`

It will not draw.
