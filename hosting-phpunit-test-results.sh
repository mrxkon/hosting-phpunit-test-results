#!/bin/bash

# Set up the wp.org API KEY & Report URL
API_KEY=""

# Stop editing

# Vars
UNIT_PATH=/var/web/site/public_html/phpunit-test-runner
TEST_PATH=/var/web/site/public_html/wp-test-runner
LOG_FILE=/var/web/site/public_html/hosting-phpunit-test-results.log
ENV_FILE=$UNIT_PATH/.env

# Creates env file & loads ENV vars.
function envfile() {
	if [ -f "$ENV_FILE" ]; then
		rm $ENV_FILE
	fi

	touch $ENV_FILE

	echo "export WPT_PREPARE_DIR="$TEST_PATH > $ENV_FILE
	echo "export WPT_TEST_DIR="$TEST_PATH >> $ENV_FILE
	echo "export WPT_REPORT_API_KEY="$API_KEY >> $ENV_FILE
	echo "export WPT_DB_NAME="`wp config get DB_NAME --path=/var/web/site/public_html/` >> $ENV_FILE
	echo "export WPT_DB_USER="`wp config get DB_USER --path=/var/web/site/public_html/` >> $ENV_FILE
	echo "export WPT_DB_PASSWORD="`wp config get DB_PASSWORD --path=/var/web/site/public_html/` >> $ENV_FILE
	echo "export WPT_DB_HOST="`wp config get DB_HOST --path=/var/web/site/public_html/` >> $ENV_FILE

	source $ENV_FILE
}

# Runs PHP code
function runphp() {
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "START PHP UNIT TESTING "$(date)
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	php $UNIT_PATH/prepare.php
	php $UNIT_PATH/test.php
	php $UNIT_PATH/report.php
	php $UNIT_PATH/cleanup.php
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "END PHP UNIT TESTING "$(date)
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

# Sets up the log file
function logsetup() {
	if [ ! -f "$LOG_FILE" ]; then
		touch $LOG_FILE
	fi

	> $LOG_FILE
}

# If phpunit-test-runner exists create .env file & run PHP code.
# else
# If phpunit-test-runner doesn't exist clone the php-unit-test-runner, create .env file & run PHP code.
if [ -d "$UNIT_PATH" ]; then
	# Set up logging
	logsetup
	# Create .env
	envfile
	# Run php
	runphp | tee -ai $LOG_FILE
else
	# Set up logging
	logsetup
	# Clone repo
	git clone https://github.com/WordPress/phpunit-test-runner.git $UNIT_PATH
	# Create .env
	envfile
	# Run php
	runphp | tee -ai $LOG_FILE
fi
