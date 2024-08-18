import logging
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import login  # Import the login module

# Configure logging
logging.basicConfig(
    filename='selenium.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger()

def log_with_newlines(text):
    """Helper function to log multi-line text with timestamps."""
    for line in text.splitlines():
        logger.info(line)

def add_remove_from_cart(driver):
    #######################################################################################
    # Check clicking on the 'Add to cart' button for Sauce Labs Backpack
    #######################################################################################
    try:
        addcarts = driver.find_elements(By.CSS_SELECTOR, ".btn.btn_primary.btn_small.btn_inventory")
        if addcarts:
            logger.info(f"Number of 'Add to cart' buttons found: {len(addcarts)}")
            for addcart in addcarts:
                logger.info(f"Button found with text: {addcart.text}")
                addcart.click()
                logger.info('Click on the button with class Add cart successful')

                # Wait for the button to transform into "Remove"
                WebDriverWait(driver, 10).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, ".btn_secondary.btn_small.btn_inventory"))
                )
                logger.info('The button has transformed into Remove')
        else:
            logger.info("No 'Add to cart' buttons found on the page.")
    except Exception as e:
        logger.error(f"An error occurred: {e}")


# If this file is executed directly, perform the login and add/remove from cart actions
if __name__ == "__main__":
    driver = login.login('standard_user', 'secret_sauce')
    try:
        cart_icon = driver.find_element(By.CSS_SELECTOR, "a.shopping_cart_link")
        cart_item_count = cart_icon.text
        add_remove_from_cart(driver)
    finally:
        # Optional: Add some wait time to see the results before the browser closes
        time.sleep(5)  # Wait for 5 seconds
        driver.quit()  # Close the browser
