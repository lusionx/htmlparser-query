var util = require('util');

var fs = require('fs');

var _ = require('underscore');

var xQuery = require('../lib/htmlparser-query');

var $ = xQuery.$;

var assert = require('assert');

var writejson = function(path, obj) {
    var ss = util.inspect(obj, {
        showHidden: true,
        depth: null
    });
    fs.writeFile(path, ss, function(err) {
        if (err) {
            throw err;
        }
        return console.log('write fin!');
    });
};

fs.readFile('./test.html', function(err, data) {
    var dd = xQuery.load(data);
    writejson('./test.json', dd.elms);
    var gg = function(slt) {
        return dd.find(slt);
    };
    var x = gg('.cc');
    assert(x.size() === 2);

    x = gg('div li');
    assert(x.size() === 7);

    x = gg('a[title=title]');
    assert(x.size() === 1);
    assert(x.text() === 'title end');

    x = gg('a[title!=title]');
    assert(x.size() === 3);
    console.log(x.attrs('href'));

    x = gg('[title^=title]');
    assert(x.size() === 1);

    x = gg('[title$=title]');
    assert(x.size() === 1);

    x = gg('[title*=title]');
    assert(x.size() === 2);

    x = gg('a[title^=title]');
    assert(x.size() === 1);
    console.log(x.attr('href'));

    x = gg('a[title$=title]');
    assert(x.size() === 1);

    x = gg('a[title*=title]');
    assert(x.size() === 2);

    console.log(gg('p').text());
    _.each(gg('p').elms, function(e) {
        assert($(e).text() === "p1");
    });
});

fs.readFile('./index.html', {
    encoding: 'utf-8'
}, function(err, data) {
    var dd = xQuery.load(data);
    var gg = function(slt) {
        return dd.find(slt);
    };
    writejson('./index.json', dd.elms);
    var x = gg('#navbg1btn_ont');
    assert(x.size() === 1);

    x = gg('h2');
    assert(x.size() === 3);

    x = gg('.cartoon_online_border');
    assert(x.size() === 2);
    console.log(x.raw());

    x = gg('div.cartoon_online_border');
    assert(x.size() === 2);
    x = gg('div.cartoon_online_border li');
    assert(x.size() === 203);
    x = gg('div.cartoon_online_border a[title]');
    assert(x.size() === 203);
});
