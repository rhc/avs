#!/usr/bin/env ruby
# frozen_string_literal: true

require 'selenium-webdriver'

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for(:chrome, options:)

url = 'https://msrc.microsoft.com/update-guide/en-US/advisory/CVE-2023-21709'
driver.get(url)

# Wait for the page to fully load
wait = Selenium::WebDriver::Wait.new(timeout: 10)
wait.until { driver.find_element(tag_name: 'body') }

# Use JavaScript to find and return the content between the markers
js_script = <<-JS
  var content = '';
  var elements = document.querySelectorAll('p');
  var capture = false;

  elements.forEach(function(el) {
    if (el.querySelector('strong') && el.innerText.includes('Are there additional steps needed to protect against this vulnerability?')) {
      capture = true;
      return;
    } else if (capture && el.querySelector('strong')) {
      capture = false;
      return;
    }
  #{'  '}
    if (capture) {
      content += el.outerHTML + '\\n';
    }
  });

  return content;
JS

captured_content = driver.execute_script(js_script)
puts captured_content

driver.quit
