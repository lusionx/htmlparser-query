call coffee -b -c lib test index.coffee

call npm pack

del lib\*.js 
del test\*.js
del index.js