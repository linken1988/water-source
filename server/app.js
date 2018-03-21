var config = require( './config' );
var net = require( 'net' );
var util = require( 'util' );
var validator = require( 'validator' );
var http = require( 'http' );
var url = require( 'url' );
var pattern = /@LEN.+?#/ig;
var isDebugging=true;//如果是true,则打印日志文件
var dgram=require('dgram');

var log4js = require( 'log4js' );
log4js.configure( {
    appenders: [{
        type: 'dateFile',
        filename: 'C:\server\logs\sensorData.log',
        pattern: '-yyyy-MM-dd',
        alwaysIncludePattern: false
    }]
});
var logger = log4js.getLogger();

if ( validator.isNull( config.receiveDataKey ) )
    return console.log( 'receiveDataKey参数配置错误' );

if ( !validator.isURL( config.receiveDataUrl ) )
    return console.log( 'receiveDataUrl参数不是有效的URL格式' );

function sendData( data ) {
    
    if (/A[0-9]{2}:99999/gi.test(data) || /P[0-9]{2}:99999999/gi.test(data)) {
        //如果A通道中找到连续的5个9则放弃此报文 如果P通道中找到连续的8个9则放弃此报文 K通道的情况不用考虑
        util.log('丢弃此报文');
        return;
    }

    var urlObj = url.parse( config.receiveDataUrl );

    var options = {
        hostname: urlObj.hostname,
        port: urlObj.port,
        path: urlObj.path,
        method: 'POST',
        headers: {
            'receiveDataKey': config.receiveDataKey,
            'content-length': Buffer.byteLength( data, 'utf8' ),
            'content-type': 'text/plain;charset=utf-8'
        }
    };

    var req = http.request( options, function ( res ) {
        res.setEncoding( 'utf8' );
        var body = '';
        res.on( 'data', function ( chunk ) {
            body += chunk;
        });
        res.on( 'end', function () {
            util.log( body );
        });
    });

    req.on( 'error', function ( e ) {
        util.log( util.format( '发送数据时发生错误：%s', e.message ) );
    });
    req.end( data );
};

var srv = net.createServer( function ( c ) {
    var ipEndPoint = util.format( '%s:%d', c.remoteAddress, c.remotePort );
    var data = '';
    util.log( util.format( '客户端 %s 连接', ipEndPoint ) );

    c.on( 'data', function ( str ) {
        data += str;
        var array = data.match( /@LEN.+?#/ig );
        if ( array !== null ) {
            array.forEach( function ( value, index, traversedObject ) {
                if ( isDebugging ) {
                    logger.info( value );
                };
                sendData( value );
                c.write('@888','ascii');
            });
            data = data.replace( pattern, "" )
        };
    });

    c.on( 'error', function ( e ) {
        util.log( util.format( '客户端 %s 出现错误', ipEndPoint ) );
    });

    c.on( 'close', function ( had_error ) {
        util.log( util.format( '客户端 %s %s关闭', ipEndPoint, had_error ? '由于错误导致' : '' ) );
    });

    c.on( 'end', function () {
        util.log( util.format( '客户端 %s 断开', ipEndPoint ) );
    });
});

srv.on( 'error', function ( e ) {
    util.log( e.code === 'EADDRINUSE' ? util.format( '端口 %d 被占用', config.tcpPort ) : e.message );
});

srv.on( 'close', function () {
    util.log( '服务器关闭' );
});

srv.listen( config.tcpPort, function () {
    util.log( util.format( 'TCP服务器在%d端口监听', config.tcpPort ) );
});

/* ===============UDP================== */

var s = dgram.createSocket("udp4");

s.on("error", function (err) {
  util.log(util.format('UDP服务器发生错误:%s',err.stack));
  s.close();
});

s.on("message", function (msg, rinfo) {
    sendData(msg.toString('ascii'));
    var buff=new Buffer('@888','ascii');
    s.send(buff, 0, buff.length, rinfo.port, rinfo.address);
});

s.on("listening", function () {
  var address = s.address();
  util.log(util.format('UDP服务运行在%s:%d',address.address,address.port));
});

s.bind(config.udpPort);
