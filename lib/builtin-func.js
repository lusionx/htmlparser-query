'use strict';


var _ = require('underscore');

var func = {};

func._reg = {
    id: /^#([\w-]+)$/,
    "class": /^\.([\w-]+)$/,
    tag: /^(\w+)$/,
    attr: /^\[([\w-]+)([\^\$\*!]?=?)([\w-]*)\]$/,
    tag$cls: /^(\w+)\.([\w-]+)$/,
    tag$attr: /^(\w+)\[(\w+)([\^\$\*!]?=?)(\w*)\]$/,
    tag$cls$attr: /^(\w+)\.([\w-]+)\[(\w+)([\^\$\*!]?=?)(\w*)\]$/
};

func.id = function(name) {
    return func.attr('id', '=', name);
};

func.tag = function(name) {
    return function(node) {
        return node.type === 'tag' && node.name === name;
    };
};

func["class"] = function(name) {
    return function(node) {
        var has = node.type === 'tag' && node.attribs && node.attribs["class"];
        if (has) {
            return node.attribs["class"].split(' ').indexOf(name) >= 0;
        }
    };
};

func.attr = function(name, op, val) {
    return function(node) {
        var has = node.type === 'tag' && node.attribs && node.attribs[name];
        if (has) {
            var v = node.attribs[name];
            if (op === '=') {
                return v === val;
            }
            if (op === '!=') {
                return v !== val;
            }
            if (op === '^=') {
                return v !== val && v.slice(0, val.length) === val;
            }
            if (op === '$=') {
                return v !== val && v.slice(0 - val.length) === val;
            }
            if (op === '*=') {
                return v !== val && v.indexOf(val) > -1;
            }
        }
        return Boolean(has);
    };
};


module.exports = func;
