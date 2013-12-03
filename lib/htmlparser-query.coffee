#bin/coffee

util = require 'util'

htmlparser = require 'htmlparser'

func = require('./builtin-func')

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
        @length = @elms.length

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

        rr = func._reg

        qs = []

        doms = @elms

        for ss in selector.split(' ')
            mch = {}
            for k, r of rr
                mch[k] = r.exec ss

            switch
                when m = mch.id then qs.push func.id(m[1])
                when m = mch.class then qs.push func.class(m[1])
                when m = mch.tag then qs.push func.tag(m[1])
                when m = mch.attr then qs.push func.attr(m[1], m[2], m[3])

                when m = mch.tag$cls then qs.push [func.tag(m[1]), func.class(m[2])]
                when m = mch.tag$attr then qs.push [func.tag(m[1]), func.attr(m[2], m[3], m[4])]

                when m = mch.tag$cls$attr then qs.push [func.tag(m[1]), func.class(m[2]), func.attr(m[3], m[4], m[5])]

        return if qs.length == 1 then @findf qs[0] else @findfs qs


xQuery::raw = () ->
    return (a.raw for a in @elms)

xQuery::size = () ->
    return @length

xQuery::text = () ->
    ff = (node) ->
        #console.log node.data if node.type == 'text'
        return node.type == 'text' #and node.data.trim().length

    result = @findf(ff)

    return (a.data.trim() for a in result.elms)

xQuery::attr = (name) ->
    ff = func.attr(name, '', '')
    for node in @elms
        if ff(node) is true
            return node.attribs[name]
    return null


exports.load = xQuery.init

exports.$ = (node) -> new xQuery(node)

exports.xQuery = xQuery
