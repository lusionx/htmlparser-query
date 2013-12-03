
util = require 'util'

htmlparser = require 'htmlparser'

#log = console.log

_refp = (nodes, filter, i, result) -> # path query
    for one in nodes
        val = if util.isArray filter[i] then (f one for f in filter[i]).every (e) -> e else filter[i] one

        if true is val and i + 1 == filter.length # end match
            result.push(one)
            continue
        if true is val and i + 1 < filter.length # match path ,go next func
            _refp one.children, filter, i + 1, result if one.children?
            continue
        _refp one.children, filter, i, result if one.children?


_ref = (nodes, filter, result) -> # node query
    for one in nodes
        val = if util.isArray filter then (f one for f in filter).every (e) -> e else filter one

        if true is val # end match
            result.push(one)
            continue
        else
            _ref one.children, filter, result if one.children?

class xQuery

    @init: (raw) ->
        handler = new htmlparser.DefaultHandler (error, dom) ->
            return if error
        parser = new htmlparser.Parser handler

        parser.parseComplete raw

        return new xQuery handler.dom

    constructor: (elms) ->
        #log 'new'
        @elms = if util.isArray elms then elms else [elms]

    findf: (q) -> # find by a func
        result = []

        _ref @elms, q, result

        return new xQuery result

    findfs: (qs) -> # find by [func], match the path

        result = []

        _refp @elms, qs, 0, result

        return new xQuery result

    find: (selector) ->
        # #id div .some [aa=xx] div.class div[aa] div.xxx[n=v]

        rr =
            id : /^#(\w+)$/
            class: /^\.(\w+)$/
            tag: /^(\w+)$/
            attr: /^\[(\w+)=?(\w*)\]$/
            tag$cls: /^(\w+)\.(\w+)$/
            tag$attr: /^(\w+)\[(\w+)=?(\w*)\]$/
            tag$cls$attr: /^(\w+)\.(\w+)\[(\w+)=?(\w*)\]$/

        qs = []

        doms = @elms

        for ss in selector.split(' ')
            mch = {}
            for k of rr
                mch[k] = rr[k].exec ss
            #log mch

            switch
                when m = mch.id then qs.push func.id(m[1])
                when m = mch.class then qs.push func.class(m[1])
                when m = mch.tag then qs.push func.tag(m[1])
                when m = mch.attr then qs.push func.attr(m[1], m[2])

                when m = mch.tag$cls then qs.push [func.tag(m[1]), func.class(m[2])]
                when m = mch.tag$attr then qs.push [func.tag(m[1]), func.attr(m[2], m[3])]

                when m = mch.tag$cls$attr then qs.push [func.tag(m[1]), func.class(m[2]), func.attr(m[3], mch[4])]

        return if qs.length == 1 then @findf qs[0] else @findfs qs


xQuery::qq = xQuery::find

xQuery::raw = () ->
    return (a.raw for a in @elms)

xQuery::size = () ->
    return @elms.length


func = {}

func.id = (name) ->
    return func.attr('id', name)

func.tag = (name) ->
    ff = (node) ->
        return node.type is 'tag' and node.name == name
    return ff

func.class = (name) ->
    ff = (node) ->
        has = node.type is 'tag' and node.attribs and node.attribs.class

        if has
            return node.attribs.class.split(' ').some (e) -> e == name
    return ff

func.attr = (name, val) ->
    ff = (node)->
        has = node.type is 'tag' and node.attribs and node.attribs[name]
        if has and val
            return node.attribs[name] == val
        return Boolean(has)

    return ff


exports.xQuery = xQuery
exports.func = func
