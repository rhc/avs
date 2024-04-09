#!/usr/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'

# Setup Selenium to use Chrome in headless mode
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless') # Run without opening a UI window
options.add_argument('--disable-gpu') # Recommended for headless mode
options.add_argument('--no-sandbox') # Bypass OS security model (especially needed on Linux)
options.add_argument('--disable-dev-shm-usage') # Overcome limited resource problems

# Initialize a new driver
driver = Selenium::WebDriver.for(:chrome, options:)

# Define the URL to fetch
url = 'https://msrc.microsoft.com/update-guide/en-US/advisory/CVE-2023-21709'

# Navigate to the URL
driver.get(url)

# Create an instance of WebDriverWait with a timeout
wait = Selenium::WebDriver::Wait.new(timeout: 30) # seconds

# XPath to find a <p> element directly containing a <strong> child with the exact text
xpath = "//p[strong[text()='Are there additional steps needed to protect against this vulnerability?']]"

# Wait until the specified element is present
element = wait.until do
  driver.find_element(xpath:)
end

# Check if the element contains the expected text (optional, as the XPath should ensure this)
if element.text.include?('Are there additional steps needed to protect against this vulnerability?')
  puts 'Question about additional steps found.'
else
  puts 'The specific question was not found, which is unexpected.'
end

# Close the browser
driver.quit
