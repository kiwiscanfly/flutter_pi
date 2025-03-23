# Deploy to Raspberry Pi
# Usage: . ./deploy.sh

# Build bundle for arm64 linux
# fvm flutter build bundle # --target-platform linux-arm64

fvm exec flutterpi_tool build --arch=arm64 --release
# Sync build bundle to raspberry pi
rsync -avz ./build/flutter_assets/ rebecca@pypi:/home/rebecca/flutter_pi

# Restart the daemon
ssh rebecca@pypi "sudo systemctl restart flutter-pi-daemon"
