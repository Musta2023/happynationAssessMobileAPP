#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting Railway deployment script..."

# Navigate to the backend application directory (if not already in it)
# Assuming the Railway build context is the root of your project (myFirstAPP)
# or the backend folder itself. It's safer to ensure we're in the backend dir.
# If Railway's build context is already 'backend', this cd command is redundant but harmless.
if [ -d "backend" ] && [ ! -f "artisan" ]; then
  echo "Changing directory to backend..."
  cd backend
fi

# Check if composer is installed, if not, install it
if ! command -v composer &> /dev/null
then
    echo "Composer not found, installing..."
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# Install Composer dependencies
echo "Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Cache configuration (optional, but good for performance)
echo "Caching configuration..."
php artisan config:cache

# Start the Laravel development server
echo "Starting Laravel server..."
php artisan serve --host 0.0.0.0 --port $PORT
