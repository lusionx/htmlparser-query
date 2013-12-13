util = require 'util'
fs = require 'fs'

xQuery = require '../lib/htmlparser-query'
$ = xQuery.$

assert = require('assert')

writejson = (path, obj) ->
    ss = util.inspect obj, {showHidden: true, depth: null}
    fs.writeFile path, ss, (err) ->
        throw err if err
        console.log 'write fin!'


fs.readFile './seemh.html', {encoding: 'utf-8'}, (err, data) ->
    # #id div .some [aa=xx] div.class div[aa] div.xxx[n=v]
    dd = xQuery.load(data)

    gg = (slt) -> dd.find(slt)

    writejson './seemh.json', dd.elms

    x = gg('#chapter-list-0')
    assert(x.size() == 3)

    x = gg('.chapter-list ul li a[title]')
    assert(x.size() == 63)

