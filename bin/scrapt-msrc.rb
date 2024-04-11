require 'selenium-webdriver'

# Setup Chrome browser for Selenium
driver = Selenium::WebDriver.for :chrome

begin
  # Navigate to the URL
  driver.get 'https://msrc.microsoft.com/update-guide/vulnerability'

  # Wait for elements to load
  wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds

  # Click on "Select Date Range" button
  # You'll need to replace 'select_date_range_button_selector' with the actual selector
  wait.until { driver.find_element(:css, 'select_date_range_button_selector') }.click

  # Enter "January" in the first month field
  # Replace 'first_month_field_selector' with the actual selector
  wait.until { driver.find_element(:css, 'first_month_field_selector') }.send_keys('January')

  # Enter "2023" in the first year field
  # Replace 'first_year_field_selector' with the actual selector
  wait.until { driver.find_element(:css, 'first_year_field_selector') }.send_keys('2023')

  # Enter "December" in the second month field
  # Replace 'second_month_field_selector' with the actual selector
  wait.until { driver.find_element(:css, 'second_month_field_selector') }.send_keys('December')

  # Enter "2023" in the second year field
  # Replace 'second_year_field_selector' with the actual selector
  wait.until { driver.find_element(:css, 'second_year_field_selector') }.send_keys('2023')

  # Click the "OK" button to apply the date range
  # Replace 'ok_button_selector' with the actual selector
  wait.until { driver.find_element(:css, 'ok_button_selector') }.click
rescue StandardError => e
  puts "An error occurred: #{e}"

  # Uncomment the following line if you want to close the browser automatically after the script runs
  # driver.quit
end
