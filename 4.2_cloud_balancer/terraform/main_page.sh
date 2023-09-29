#/bin/bash
cat << EOF | sudo tee /var/www/html/index.html 
<html>
  <body>

   <h1>Hi, this is server $HOSTNAME </h1>

   <img src="https://storage.yandexcloud.net/netology-kunaev-s3/jhonny.jpeg" alt="Jhonny" />

  </body>
</html> EOF




