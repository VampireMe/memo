
server {
	listen       80;
	server_name  nwww.comjia.com;

	location / {
		root   /usr/local/gaoqing/nginx/html/code/nwww;
		index  index.html index.htm index.php;


set $host_www 'http://nwww.comjia.com';

if ( $host ~* nwww.(.*) )
{
	rewrite ^/index\.php/(.*)$ /$1 permanent;
	rewrite ^/(site)$ / permanent;
	rewrite ^/(site/)$ / permanent;
	rewrite ^/(site/index)$ / permanent;
	rewrite ^/(site/index/)$ / permanent;

	rewrite ^/header/index(p1\.html)$ /header/$arg_page.html? permanent;
	rewrite ^/header/index$ /header/ permanent;
	rewrite ^/header$ /header/ permanent;

	rewrite ^/header/view/(\d+)$ /header/$1.html permanent;
	rewrite ^/header/review/(\d+)$ /header/review-$1.html permanent;
	rewrite ^/header/essay/(\d+)$ /header/essay-$1.html permanent;
	rewrite ^/header/deal/(\d+)$ /header/deal-$1.html permanent;
	rewrite ^/header/see/(\d+)$ /header/see-$1.html permanent;

	rewrite ^/(site/about)$ /site/about/ permanent;
	rewrite ^/(site/find-us)$ /site/find-us/ permanent;
	rewrite ^/(site/job)$ /site/job/ permanent;
	rewrite ^/(site/statement)$ /site/statement/ permanent;

	rewrite ^/project/view/(\d+)$ /project/$1.html permanent;

	rewrite ^/(yw-order-comment/jd|yw-order-comment/jd/)$ /activity/jd permanent;
	rewrite ^/(yw-order-comment/index)$ /deal-record permanent;
	rewrite ^/(yw-order-comment)$ /deal-record permanent;
	rewrite ^/yw-order-comment/index$ /deal-record-p$arg_page.html permanent;

	rewrite ^/project/all-comment$ /project/$arg_id/expert-comment? permanent;
	rewrite ^/project/global-comment$ /project/$arg_id/customer-comment? permanent;
	rewrite ^/project/front-comment$ /project/$arg_id/front-comment? permanent;

	rewrite ^/(hot/index|hot/index/)$ /hot/ permanent;
	rewrite ^/hot$ /hot/$arg_zhuanti?channel_id=$arg_channel_id? permanent;
	rewrite ^/hot/muying$ /hot/mc? permanent;
	rewrite ^/hot/saorao$ /hot/zh? permanent;
	rewrite ^/hot/tuiguang$ /hot/marketing? permanent;
	rewrite ^/hot/gaoduan$ /hot/high-end? permanent;

}

if ( $host !~* nwww.(.*) )
{
	rewrite ^/index\.php/(.*)$ $host_www/$1 permanent;
	rewrite ^/$ $host_www/ permanent;
	rewrite ^/(site|site/)$ $host_www/ permanent;
	rewrite ^/(site/index|site/index/)$ $host_www/ permanent;
	rewrite ^\/404\.html$ $host_www permanent;

	rewrite ^/header/index(p1\.html)$ $host_www/header/$arg_page.html? permanent;
	rewrite ^/header/index$ $host_www/header/ permanent;
	rewrite ^/header$ $host_www/header/ permanent;

	rewrite ^/header/view/(\d+)$ $host_www/header/$1.html permanent;
	rewrite ^/header/review/(\d+)$ $host_www/header/review-$1.html permanent;
	rewrite ^/header/essay/(\d+)$ $host_www/header/essay-$1.html permanent;
	rewrite ^/header/deal/(\d+)$ $host_www/header/deal-$1.html permanent;
	rewrite ^/header/see/(\d+)$ $host_www/header/see-$1.html permanent;

	rewrite ^/(site/about|site/about/)$ $host_www/site/about/ permanent;
	rewrite ^/(site/find-us|site/find-us/)$ $host_www/site/find-us/ permanent;
	rewrite ^/(site/job|site/job/)$ $host_www/site/job/ permanent;
	rewrite ^/(site/statement|site/statement/)$ $host_www/site/statement/ permanent;

	rewrite ^/project/view/(\d+)$ $host_www/project/$1.html permanent;

	rewrite ^/(yw-order-comment/jd|yw-order-comment/jd/)$ $host_www/activity/jd permanent;
	rewrite ^/(yw-order-comment/index)$ $host_www/deal-record permanent;
	rewrite ^/(yw-order-comment)$ $host_www/deal-record permanent;
	rewrite ^/yw-order-comment/index$ $host_www/deal-record-p$arg_page.html permanent;

	#http://www001.comjia.com/project/all-comment?id=53
	rewrite ^/project/all-comment$ $host_www/project/$arg_id/expert-comment? permanent;
	rewrite ^/project/global-comment$ $host_www/project/$arg_id/customer-comment? permanent;
	rewrite ^/project/front-comment$ $host_www/project/$arg_id/front-comment? permanent;

	rewrite ^/(hot/index|hot/index/)$ $host_www/hot/ permanent;
	rewrite ^/hot$ $host_www/hot/$arg_zhuanti? permanent;
	rewrite ^/hot/muying$ $host_www/hot/mc? permanent;
	rewrite ^/hot/saorao$ $host_www/hot/zh? permanent;
	rewrite ^/hot/tuiguang$ $host_www/hot/marketing? permanent;
	rewrite ^/hot/gaoduan$ $host_www/hot/high-end? permanent;

}

		#if (-d $request_filename){
		#   rewrite ^/(.*)([^/])$ /$1$2/ permanent;
		#}
		#if (-f $request_filename/index.html){
		#  rewrite (.*) $1/index.html break;
		#}
		#if (-f $request_filename/index.php){
		#  rewrite (.*) $1/index.php;
		#}
		if (!-e $request_filename)
		{
			#rewrite ^(.*)$ /?/$1 last;
		   rewrite ^(.*)$ /index.php?/$1 last;
		}
		#if (!-f $request_filename){
		#  rewrite (.*) /index.php;
		#}

	}

	#error_page   500 502 503 504  /50x.html;
	#location = /50x.html {
	#	root   /usr/local/gaoqing/nginx/html/code/nwww;
	#}

	error_page 404 /404.html;
	location = /404.html {
	    try_files /404.html @error;
	    internal;
	}
	location @error {
	    root   /usr/local/gaoqing/nginx/html/code/nwww;
	}

	location ~ \.php$ {
		root /usr/local/gaoqing/nginx/html/code/nwww;

		fastcgi_pass   127.0.0.1:9000;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $DOCUMENT_ROOT$fastcgi_script_name;
		include        fastcgi_params;		

		#fastcgi_param        PATH_INFO                $fastcgi_path_info;
		#fastcgi_param        PATH_TRANSLATED        $document_root$fastcgi_path_info;
		#include        fastcgi.conf;

		fastcgi_buffer_size 128k;
		fastcgi_buffers 4 256k;
		fastcgi_busy_buffers_size 256k;
	}

	#include D:/php_dev/nginx/conf/rewrite/nwww.comjia.com.rewrite.conf

}
