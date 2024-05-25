local IPayment = {

  -- contract properties:
  date = "string",
  methodData = "string",

  -- contract methods:
  canMakePayment = "function",
  processPayment = "function",
  pay = "function"
}

return IPayment
