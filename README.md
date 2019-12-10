# Hosting PHP Unit Testing for WordPress

This is a simple script that sets up a local WordPress test suite and runs all PHP Unit tests to report back to wordpress.org.

Reports can be found at https://make.wordpress.org/hosting/test-results/ .

The whole script takes about 15minutes to finish on each full run ( including downloading from scratch / building etc ).

## Requirements

- Latest node
- Latest npm
- Latest npm grunt-cli
- ImageMagick ( via apt for convert command )

**Everything should be available & run as www-data user.**

## Set up
1. Upload  the hosting-phpunit-test-results.sh script into `/var/web/site/public_html`
2. Edit the script and add the API key as needed. No need to change anything else.
3. Add a cron event to run the script every 3 hours as suggested by wp.org #hosting guides. `0 */3 * * * /bin/bash /var/web/site/public_html/hosting-phpunit-test-results.sh > /dev/null 2>&1`.
4. Add PATH to www-data cron.

## Results
If everything goes well any builds either failing or passing will be reported to wp.org.

The script will create 2 folders & 1 log file under `/var/web/site/public_html/` :

- `phpunit-test-runner` with the necessary extra scripts.
- `wp-test-runner` with the WordPress test installation.
- `hosting-phpunit-test-results.log` for logging purposes.
