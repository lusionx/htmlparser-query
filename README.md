htmlparser-query
================

lang: (english)[./README.en.md]

## 用法`coffee`
实例:
> xQuery = require('htmlparser-query').xQuery

> raw = '通过下载或者文件得到的html字符串'

> x = xQuery.init(raw)

> x.qq('#id')

支持 `#id div .some [aa=xx] div.class div[aa] div.xxx[n=v]` 查询
也支持 子代查询 比如: `div .bar a[title]`

x.elms is a list of object
{raw:'', data: '', type:'text|tag|..', name:'div..', attribs:{}, children: []}

