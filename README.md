htmlparser-query
================
lang: [us-en](https://github.com/lusionx/htmlparser-query/blob/master/README.en.md)

由于[jquery](https://npmjs.org/package/jquery)在node@windows上无法运行, 编写此工具完成简单查询. 查询方法尽力向jquery靠拢.

## 安装
> npm install htmlparser-query

## 用法

```js
var x = require('htmlparser-query').init('string or Buffer');
x.find('...');
```

### 查询方法
- 支持的基本查询 `#id div .class [a] [a=b] [a!=b] [a^=b] [a$=b] [a*=b]`.
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
    type: 'tag', // maybe 'text'
    name: 'div',
    attribs: { class: 'cc', href:'' },
    children: []
};
```

### 快捷方法
- `elms -> []` 属性: 符合要求的`[node]`
- `size() -> int` 方法: `elms.length`
- `raw() -> []` 方法: `[node.raw]`
- `text() -> string` 方法: 筛选所以文本节点
- `attr(name) -> string` 方法: 取得第一个拥有此属性的节点的属性值
- `attrs(name) -> [string]` 方法: 取得所有拥有此属性的节点的属性值

### 循环

```js
var a = require('htmlparser-query').load('string or Buffer')
var xq = a.find('ul.border li a[title]')
_.each(xq.elms, function(e){
    console.log($(e).attr('title'));
});
```
