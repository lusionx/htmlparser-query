'use strict';

var _ = require('underscore');

var htmlparser = require('htmlparser');

var func = require('./builtin-func');

var _refp = function(nodes, filter, i, result) {
    for (var j = 0; j < nodes.length; j++) {
        var one = nodes[j];

        var val = null
        if (_.isArray(filter[i])) {
            val = _.every(filter[i], function(f) {
                return f(one);
            });
        } else {
            val = filter[i](one);
        }

        if (val === true) { // match filter,
            if (i + 1 < filter.length) { //go next filter with children
                if (one.children) {
                    _refp(one.children, filter, i + 1, result);
                    continue;
                }
            }else{
                result.push(one);
            }

        } else { //not match filter, use curr filter with children
            if (one.children) {
                _refp(one.children, filter, i, result);
            }
        }
    }
};

var _ref = function(nodes, filter, result) {
    _.each(nodes, function(one) {
        var val = null;
        if (_.isArray(filter)) {
            val = _.every(filter, function(f) {
                return f(one);
            });
        } else {
            val = filter(one);
        }
        if (true === val) {
            result.push(one);
        } else {
            if (one.children != null) {
                _ref(one.children, filter, result);
            }
        }
    });
};

var xQuery = function(elms) {
    this.elms = _.isArray(elms) ? elms : [elms];
    this.length = this.elms.length;
};

xQuery.load = function(raw) {
    var handler = new htmlparser.DefaultHandler(function(error, dom) {
        if (error) {

        }
    });
    var parser = new htmlparser.Parser(handler);
    parser.parseComplete(raw);
    return new xQuery(handler.dom);
};

xQuery.prototype.findf = function(q) {
    var result;
    result = [];
    _ref(this.elms, q, result);
    return new xQuery(result);
};

xQuery.prototype.findfs = function(qs) {
    var result;
    result = [];
    _refp(this.elms, qs, 0, result);
    return new xQuery(result);
};

xQuery.prototype.find = function(selector) {
    var rr = func._reg;
    var qs = [];
    var doms = this.elms;
    _.each(selector.split(' '), function(ss) {
        var mch = {};
        _.each(rr, function(r, k) {
            mch[k] = r.exec(ss);
        });
        var m = null;
        switch (false) {
            case !(m = mch.id):
                qs.push(func.id(m[1]));
                break;
            case !(m = mch["class"]):
                qs.push(func["class"](m[1]));
                break;
            case !(m = mch.tag):
                qs.push(func.tag(m[1]));
                break;
            case !(m = mch.attr):
                qs.push(func.attr(m[1], m[2], m[3]));
                break;
            case !(m = mch.tag$cls):
                qs.push([func.tag(m[1]), func["class"](m[2])]);
                break;
            case !(m = mch.tag$attr):
                qs.push([func.tag(m[1]), func.attr(m[2], m[3], m[4])]);
                break;
            case !(m = mch.tag$cls$attr):
                qs.push([func.tag(m[1]), func["class"](m[2]), func.attr(m[3], m[4], m[5])]);
                break;
            default:
                throw new Error('not support selector ' + ss);
        }
    });
    if (qs.length === 1) {
        return this.findf(qs[0]);
    } else {
        return this.findfs(qs);
    }
};

xQuery.prototype.raw = function() {
    return _.map(this.elms, function(e){
        return e.raw;
    });
};

xQuery.prototype.size = function() {
    return this.length;
};

xQuery.prototype.text = function() {
    var ff = function(node) {
        return node.type === 'text';
    };
    var result = this.findf(ff);
    return _.map(result.elms, function(e){
        return e.data;
    }).join('');
};

xQuery.prototype.attr = function(name) {
    var ff = func.attr(name, '', '');
    var arr = _.map(this.elms, function(node) {
        if(ff(node) === true){
            return node.attribs[name];
        };
    });
    arr = _.compact(arr);
    if(arr.length>0){
        return arr[0];
    }else{
        return undefined;
    }
};

xQuery.prototype.attrs = function(name) {
    var ff = func.attr(name, '', '');
    var arr = _.map(this.elms, function(node) {
        if(ff(node) === true){
            return node.attribs[name];
        };
    });
    return _.compact(arr);
};

exports.load = xQuery.load;

exports.$ = function(node) {
    return new xQuery(node);
};

exports.xQuery = xQuery;
