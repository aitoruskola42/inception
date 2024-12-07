FROM alpine:3.20.2

RUN apk update && apk add --no-cache \
    php82 \
    php82-session \
    php82-mysqli \
    php82-pdo \
    php82-pdo_mysql

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /adminer.php

RUN cp adminer.php index.php

RUN echo "<?php phpinfo(); ?>" > /info.php

EXPOSE 9999

CMD ["php", "-S", "0.0.0.0:9999", "-t", "/"]