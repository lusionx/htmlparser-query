util = require 'util'
fs = require 'fs'

xQuery = require('../lib/htmlparser-query').xQuery

assert = require('assert')

console.log

writejson = (path, obj) ->
    ws = fs.createWriteStream(path)
    ws.write(util.inspect(obj, {showHidden: true, depth: null}))
    ws.end()

fs.readFile './d1.html', {encoding: 'utf-8'}, (err, data) ->
    dd = xQuery.init(data)
    writejson './d1.json', dd.elms

    x = dd.qq('.cc')
    assert(x.size() == 2)

    x = dd.qq('div li')
    assert(x.size() == 6)


fs.readFile './index.html', {encoding: 'utf-8'}, (err, data) ->
    # #id div .some [aa=xx] div.class div[aa] div.xxx[n=v]
    dd = xQuery.init(data)

    writejson './index.json', dd.elms

    x = dd.qq('#navbg1btn_ont')
    assert(x.size() == 1)

    x = dd.qq('h2')
    assert(x.size() == 3)

    x = dd.qq('.cartoon_online_border')
    assert(x.size() == 2)


    x = dd.qq('div.cartoon_online_border')
    assert(x.size() == 2)

    x = dd.qq('div.cartoon_online_border li')
    assert(x.size() == 203)

    x = dd.qq('div.cartoon_online_border a[title]')
    assert(x.size() == 203)

