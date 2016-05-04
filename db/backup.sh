#export yavlena_www
mysqldump --user=yavlena --password=yavlena_site_db --default_character-set=utf8 yavlena_site >/www/yavlena/www/backup/yavlena_site.sql
mysqldump --user=yavlena_blog --password=yavlena_blog_db --default_character-set=utf8 yavlena_blog >/www/yavlena/www/backup/yavlena_blog.sql


# drop/creat yavlena_www database
#mysql --user=yavlena_www --password=4EtH3stE --execute="DROP DATABASE yavlena_www; CREATE DATABASE yavlena_www CHARACTER SET utf8 COLLATE utf8_general_ci;"

#Import data
#mysql --user=yavlena_www --password=4EtH3stE --default-character-set=utf8 --max_allowed_packet=134214728 yavlena_www < yavlena_www.sql
gzip -9 /www/yavlena/www/backup/yavlena_blog.sql
gzip -9 /www/yavlena/www/backup/yavlena_site.sql 
