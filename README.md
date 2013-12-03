htmlparser-query
================
lang: [english](./README.en.md)

由于[jquery](https://npmjs.org/package/jquery)在node@windows上无法运行, 编写此工具完成简单查询. 查询方法尽力向jquery靠拢.

以下代码使用`coffee`语法

## 安装
> npm -g install coffee-script

下载源码解压, 运行`compile.bat`

## 用法

```coffee
xQuery = require('htmlparser-query')
raw = '通过下载或者文件得到的html字符串'
x = xQuery.init(raw)
x.find('...')
```

### 查询方法
- 支持的基本查询 `#id div .some [a] [a=b] [a!=b] [a^=b] [a$=b] [a*=b]`.
- 支持组合查询 `div.class div[aa..] div.cls[att..]`.
- 支持子代查询 比如: `div .bar a[title]`.
- 支持链式查询: `x.find('div').find('li')` 和 `x.find('div li')` 等效
- **_不_**支持查询: `div~li div>li`
- 空格有严格意义, 不要乱加

### 自定义查询
- 调用`findf(filter)`, 传入过滤方法, 查询`node`属性.
- node结构来自[htmlparser](https://npmjs.org/package/htmlparser).

```js
node = { 
  raw: 'div class="cc"',
  data: 'div class="cc"',
 type: 'tag', // maybe eq 'text'
 name: 'div',
 attribs: { class: 'cc' },
 children: [] }
```

### 快捷方法
- `elms` 属性: 符合要求的`[node]`
- `size()` 方法: `elms.length`
- `raw()` 方法: `[node.raw]`
- `text()` 方法: 筛选所以文本节点
- `attr(name)` 方法: 取得第一个拥有此属性的阶段的属性值

### 循环

```coffee
lks = x.find('div.online_border li a[title]')
for e in lks.elms
    console.log xQuery.$(e).attr('title')
```
