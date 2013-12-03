htmlparser-query
================

xQuery = require('htmlparser-query').xQuery

raw = 'a string get from url/file'

x = xQuery.init(raw)

x.qq('#id')

support one of `#id div .some [aa=xx] div.class div[aa] div.xxx[n=v]`
also support child query splited by ' ' eg: `div .bar a[title]`

x.elms is a list of object
{raw:'', data: '', type:'text|tag|..', name:'div..', attribs:{}, children: []}

