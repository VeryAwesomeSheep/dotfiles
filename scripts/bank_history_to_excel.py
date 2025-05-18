# Simple script for parsing bank statements.
# It takes the raw copied data from bank website and parses it.
# The plan was to parse the monthly summary pdf file, but turns out there is less
# information there ¯\_(ツ)_/¯

import re
from typing import Any

def open_and_prepare_file(filename: str) -> list[str]:
  """
  Opens log file and strips all empty lines.
  """
  try:
    with open(filename, "r") as f:
      lines = [line.strip() for line in f.readlines() if line.strip()]

    return lines

  except FileNotFoundError:
    print(f"ERROR: File {filename} not found")
    exit(1)

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
  transactions = {}

  i = 1 # skip first index as it's a payment type
  transaction_idx = 0
  while i + 2 < len(data):
    date = data[i]
    title = data[i+1]
    tmp_amount = data[i+2]

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

    i += 4 # move to next transaction and skip the payment type
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
  # FILE = "transaction_log.txt"
  SEPARATOR = ";"

  # data = open_and_prepare_file(FILE)
  data = get_raw_input()
  find_first_date(data)
  transactions = extract_transactions(data)
  print_formated_data(transactions, SEPARATOR)
