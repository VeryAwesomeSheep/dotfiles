# Simple script for parsing bank statements.
# It takes the raw copied data from bank website and parses it.
# The plan was to parse the monthly summary pdf file, but turns out there is less
# information there ¯\_(ツ)_/¯

import re
from typing import Any

def get_raw_input() -> list[str]:
  """
  Gets raw string from the user and strips all empty lines.
  """
  print("Enter your input (press Ctrl+C to finish):")
  lines = []
  try:
      while True:
          line = input()
          lines.append(line)
  except KeyboardInterrupt:
      print("\nINFO: Input finished.")  # Add a newline for cleaner output

  non_empty_lines = [line.strip() for line in lines if line.strip()]
  return non_empty_lines

def find_first_date(data: list[str]):
  """
  Looks for first instance of date and removes everything up to that point -1 index (to account the beginning of actual data log which is payment type).
  """
  date_regex = re.compile(r"^\d{1,2}\.\d{2}\.\d{4}$")


  for idx, line in enumerate(data):
    if date_regex.match(line.strip()):
      del data[:idx - 1]
      return

def extract_transactions(data: list[str]) -> dict[Any, dict[str, str]]:
  """
  Parses the data and packs it into dict.
  """
  # remove the "BLIK Icon" string line that appears with blik payments
  while "BLIK Icon" in data:
    data.remove("BLIK Icon")

  transactions = {}

  i = 0
  transaction_idx = 0
  while i < len(data):
    date = data[i+1]
    title = data[i+2]
    tmp_amount = data[i+4]

    # strip "\u2009" and currency
    match = re.search(r"^(.*?),(\d{2})", tmp_amount) # regex for amount with , and 2 decimal places
    if match:
      amount = match.group(1) + "," + match.group(2)
    else:
      amount = tmp_amount
      print(f"ERROR: Failed to parse amount for transaction from {date} with title: {title}")

    transactions[transaction_idx] = {
      "date": date,
      "title": title,
      "amount": amount
    }

    i += 5 # move to next transaction
    transaction_idx += 1

  return transactions

def print_formated_data(transactions: dict[Any, dict[str, str]], separator: str) -> None:
  """
  Prints transactions data in format that can be pasted into Excel with selected
  separator.
  """
  for _, transaction_data in transactions.items():
    print(f"{transaction_data['date']}{separator}{transaction_data['title']}{separator}{transaction_data['amount']}")

  print(f"\nFound {len(transactions)} transactions\n")

if __name__ == "__main__":
  SEPARATOR = ";"

  data = get_raw_input()
  find_first_date(data)
  transactions = extract_transactions(data)
  print_formated_data(transactions, SEPARATOR)
