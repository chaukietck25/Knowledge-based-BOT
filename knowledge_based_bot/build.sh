#!/bin/bash

# Remove any existing Flutter directory
rm -rf flutter

# Clone the Flutter repository
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# Add Flutter to the PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Create a non-root user and switch to that user
useradd -m flutteruser
chown -R flutteruser:flutteruser .
su - flutteruser -c "
  cd $(pwd)
  export PATH=\"$PATH\"
  flutter doctor
  flutter pub get
  flutter build web
"