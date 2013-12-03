
util = require 'util'

htmlparser = require 'htmlparser'

#log = console.log

_ref = (nodes, filter, i, result) ->
    for one in nodes
        val = if util.isArray filter[i] then (f one for f in filter[i]).every (e) -> e else filter[i] one

        i++ if true is val
        if i == filter.length # end match
            result.push(one)
            return
        else
            _ref one.children, filter, i, result if one.children?

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


    filter: (qs) ->
        doms = @elms

        qs = [qs] if not util.isArray qs

        result = []
        _ref doms, qs, 0, result

        return new xQuery result

    qq: (selector) ->
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
        for ss in selector.split(' ')
            mch = {}
            for k of rr
                mch[k] = rr[k].exec ss
            #log mch

            switch
                when m = mch.id then qs.push query.id(m[1])
                when m = mch.class then qs.push query.class(m[1])
                when m = mch.tag then qs.push query.tag(m[1])
                when m = mch.attr then qs.push query.attr(m[1], m[2])

                when m = mch.tag$cls then qs.push [query.tag(m[1]), query.class(m[2])]
                when m = mch.tag$attr then qs.push [query.tag(m[1]), query.attr(m[2], m[3])]

                when m = mch.tag$cls$attr then qs.push [query.tag(m[1]), query.class(m[2]), query.attr(m[3], mch[4])]

        return @filter qs

xQuery::raw = () ->
    ls = []
    for a in @elms
        ls.push(a.raw)
    return ls

xQuery::size = () ->
    return @elms.length


query = {}

query.id = (name) ->
    return query.attr('id', name)

query.tag = (name) ->
    func = (node) ->
        return node.type is 'tag' and node.name == name
    return func

query.class = (name) ->
    func = (node) ->
        has = node.type is 'tag' and node.attribs and node.attribs.class

        if has
            return node.attribs.class.split(' ').some (e) -> e == name
    return func

query.attr = (name, val) ->
    func = (node)->
        has = node.type is 'tag' and node.attribs and node.attribs[name]
        if has and val
            return node.attribs[name] == val
        return Boolean(has)

    return func


exports.xQuery = xQuery
exports.query = query
