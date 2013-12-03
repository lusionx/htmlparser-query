#bin/coffee


util = require 'util'
fs = require 'fs'

xQuery = require('../lib/htmlparser-query').xQuery

assert = require('assert')

writejson = (path, obj) ->
    ss = util.inspect obj, {showHidden: true, depth: null}
    fs.writeFile path, ss, (err) ->
        throw err if err
        console.log 'write fin!'

data = """
<div>
<div class="cc">
    <ul>
        <li><a href="xxxx" title="title">title
            <span> sp--an </span> span-end
        </a></li>
        <li><a href="xxxx" title="title_x">title_x</a></li>
        <li><a href="xxxx" title="x_title">x_title</a></li>
        <li><a href="xxxx" title="x_ss_x">x_ss_x</a></li>
    </ul>
</div>
<div class="clear">  </div>
<div class="cc">
    <ul>
        <li><a href="xxxx">asdsadsa</a></li>
        <li><a href="xxxx">asdsadsa</a></li>
        <li><a href="xxxx">asdsadsa</a></li>
    </ul>
</div>
</div>
"""

do ->

    dd = xQuery.init(data)
    writejson './d1.json', dd.elms

    gg = (slt) -> dd.qq(slt)


    x = gg('.cc')
    assert(x.size() == 2)

    x = gg('div li')
    #console.log x.size()
    assert(x.size() == 7)

    x = gg('a[title=title]')
    assert(x.size() == 1)
    #console.log x
    console.log x.text()
    #assert(x.text().length == 3)

    x = gg('a[title!=title]')
    assert(x.size() == 3)
    #console.log x

    x = gg('[title^=title]')
    #console.log x
    assert(x.size() == 1)

    x = gg('[title$=title]')
    #console.log x
    assert(x.size() == 1)

    x = gg('[title*=title]')
    #console.log x
    assert(x.size() == 2)


    x = gg('a[title^=title]')
    #console.log x
    assert(x.size() == 1)

    x = gg('a[title$=title]')
    #console.log x
    assert(x.size() == 1)
    ###
    x = gg('a[title*=title]')
    console.log x
    assert(x.size() == 2)
    ###


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

