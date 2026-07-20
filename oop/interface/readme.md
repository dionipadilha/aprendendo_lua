# Lua Shopping Cart with Payment System

This project demonstrates a simple shopping cart implementation in Lua, featuring support for multiple payment methods through an interface-based design.

## Key Components

-   **`IPayment` Interface (`ipayment.lua`)**: Defines the contract for payment methods, specifying the required properties (`date`,  `methodData`) and methods (`canMakePayment`,  `processPayment`,  `pay`).
    
-   **Payment Implementations**:
    
    -   **`CreditCard` (`creditcard.lua`)**: Handles credit card payments, storing card details and simulating payment processing.
    -   **`Pix` (`pix.lua`)**: Supports Pix payments, storing the Pix key and simulating payment processing.
-   **`ShoppingCart` (`shoppingcart.lua`)**: Represents the shopping cart itself. It allows setting a payment method and initiating the checkout process.
    
-   **`main.lua`**: Provides a usage example, creating a shopping cart, setting different payment methods, and performing checkouts.
    

## How It Works

1.  **Payment Interface**: The `IPayment` interface ensures that all payment methods adhere to a common structure, making the shopping cart adaptable to different payment options.
    
2.  **Payment Classes**: The `CreditCard` and `Pix` classes implement the `IPayment` interface, providing concrete implementations for credit card and Pix payments respectively.
    
3.  **Shopping Cart**: The `ShoppingCart` class holds a reference to the selected payment method. When `checkout` is called, it delegates the payment processing to the associated payment object.
    
4.  **Main Script**: The `main.lua` script demonstrates how to create a shopping cart, set payment methods, and perform checkouts.


## Usage

1.  **Include Modules**: Require the necessary modules in your Lua script:

```lua
local ShoppingCart = require "shoppingcart"
local CreditCard = require "creditcard"
local Pix = require "pix"
```
2. **Create Instances**: Create instances of the shopping cart and payment methods:

```lua
local cart = ShoppingCart:new()
local creditCard = CreditCard:new {}
local pix = Pix:new {}
```
3. **Set Payment Method**: Associate a payment method with the cart:
```lua
cart:setPayment(creditCard)  -- Or cart:setPayment(pix)
```

4. **Checkout**: Initiate the checkout process with the desired amount:
```lua
cart:checkout(100) 
```

## Additional Notes

-   **Simulation**: The payment processing in this example is simulated. In a real-world application, you would integrate with actual payment gateways.
    
-   **Error Handling**: The code includes basic error handling for invalid payment amounts and failed payment processing.
    
-   **Extensibility**: You can easily add more payment methods by creating new classes that implement the `IPayment` interface.
