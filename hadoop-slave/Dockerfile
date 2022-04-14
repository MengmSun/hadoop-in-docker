FROM smm/hadoop.base:3.3.1
LABEL MengmengSun <smmzkd@mail.ustc.edu.cn>


COPY docker-entrypoint.sh /docker-entrypoint.sh
EXPOSE  9868 9870 22
ENTRYPOINT ["/bin/bash", "--", "/docker-entrypoint.sh"]