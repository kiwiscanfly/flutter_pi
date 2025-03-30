
rsync -avz ./ rebecca@pypi:/home/rebecca/flutter_pi/express --exclude=node_modules

ssh rebecca@pypi "
  cd /home/rebecca/flutter_pi/express
  npm install
  pm2 restart express
"