#bin/coffee


util = require 'util'

func = {}

func._reg =
    id : /^#(\w+)$/         # #id
    class: /^\.(\w+)$/      # .cls
    tag: /^(\w+)$/          # div
    attr: /^\[(\w+)([\^\$\*!]?=?)(\w*)\]$/          # [a] [a=b] [a!=b] [a^=b] [a$=b] [a*=b]
    tag$cls: /^(\w+)\.(\w+)$/   # div.cls
    tag$attr: /^(\w+)\[(\w+)([\^\$\*!]?=?)(\w*)\]$/     # div[a..]
    tag$cls$attr: /^(\w+)\.(\w+)\[(\w+)([\^\$\*!]?=?)(\w*)\]$/  # div.cls[a..]

func.id = (name) ->
    return func.attr('id', '=', name)

func.tag = (name) ->

    ff = (node) ->
        return node.type is 'tag' and node.name == name
    return ff

func.class = (name) ->

    ff = (node) ->
        has = node.type is 'tag' and node.attribs and node.attribs.class
        if has
            return name in node.attribs.class.split(' ')
    return ff

func.attr = (name, op, val) ->

    ff = (node)->
        has = node.type is 'tag' and node.attribs and node.attribs[name]

        if has
            v = node.attribs[name]
            if op == '='
                return v == val
            if op == '!='
                return v != val
            if op == '^='
                return v != val and v[0..val.length-1] == val
            if op == '$='
                return v != val and v[0-val.length..] == val
            if op == '*='
                return v != val and v.indexOf(val) > -1
        return has

    return ff

# export
for k, f of func
    exports[k] = f
