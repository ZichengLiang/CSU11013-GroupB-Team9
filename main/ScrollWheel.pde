int buttonWidth = 50;
int buttonHeight = 30;
float arrowMargin = 10; // Margin from the top and the right edge
float arrowX = width - buttonWidth - arrowMargin + 1810; 
float downArrowY = arrowMargin + buttonHeight + 10;
float leftArrowX = width - (buttonWidth * 2 + arrowMargin * 3) + 1850;
float rightArrowX = width - (buttonWidth + arrowMargin * 2) + 1850;
float horizontalArrowsY = arrowMargin + 100; // Y position for both left and right arrows
float plusMinusButtonSize = 20; // Square dimension for button area
float buttonX = width - buttonWidth - arrowMargin; // Align with the arrows, adjust as necessary
float plusButtonY = downArrowY + buttonHeight + 30; // Below the down arrow
float minusButtonY = plusButtonY + plusMinusButtonSize + 10; 
