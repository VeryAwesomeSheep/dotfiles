# Simple script for parsing bank statements.
# It takes the raw copied data from bank website and parses it.
# The plan was to parse the monthly summary pdf file, but turns out there is less
# information there ¯\_(ツ)_/¯

import re
from sys import argv
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


def m_bank_extract_transactions(data: list[str]) -> dict[Any, dict[str, str]]:
  """
  Parses the data and packs it into dict.
  """
  # look for first instance of date and remove everything up to that point -1 index (to account the beginning of actual data log which is payment type)
  date_regex = re.compile(r"^\d{1,2}\.\d{2}\.\d{4}$")

  for idx, line in enumerate(data):
    if date_regex.match(line.strip()):
      del data[: idx - 1]
      break

  # remove the "BLIK Icon" string line that appears with blik payments
  while "BLIK Icon" in data:
    data.remove("BLIK Icon")

  transactions = {}

  i = 0
  transaction_idx = 0
  while i < len(data):
    date = data[i + 1]
    title = data[i + 2]
    tmp_amount = data[i + 4]

    # strip "\u2009" and currency
    match = re.search(
      r"^(.*?),(\d{2})", tmp_amount
    )  # regex for amount with , and 2 decimal places
    if match:
      amount = match.group(1) + "," + match.group(2)
    else:
      amount = tmp_amount
      print(
        f"ERROR: Failed to parse amount for transaction from {date} with title: {title}"
      )

    transactions[transaction_idx] = {"date": date, "title": title, "amount": amount}

    i += 5  # move to next transaction
    transaction_idx += 1

  return transactions


def p_bank_extract_transactions(data: list[str]) -> dict[Any, dict[str, str]]:
  regex = re.compile(
    r"^(\d{2}\.\d{2}\.\d{4})\s+\d{2}\.\d{2}\.\d{4}\s+([^\t]*)\s[^\t]*\t[^\t]*\t([^\t]*)\t([^\t]*)"
  )

  transactions = {}

  i = 11
  transaction_idx = 0
  while i < (len(data) - 2):
    match = regex.match(data[i])
    if match:
      date = match.group(1)
      if match.group(3).startswith("*"):
        title = match.group(2).strip()
      else:
        title = match.group(2).strip() + " " + match.group(3).strip()
      amount = match.group(4).strip()

      transactions[transaction_idx] = {
        "date": date,
        "title": title,
        "amount": amount,
      }
      transaction_idx += 1
    i += 1
    # ^(\d{2}\.\d{2}\.\d{4})\s+\d{2}\.\d{2}\.\d{4}\s+([^\t]*)\s[^\t]*\t[^\t]*\t([^\t]*)\t([^\t]*)

  return transactions


def print_formated_data(
  transactions: dict[Any, dict[str, str]], separator: str
) -> None:
  """
  Prints transactions data in format that can be pasted into Excel with selected
  separator.
  """
  for _, transaction_data in transactions.items():
    print(
      f"{transaction_data['date']}{separator}{transaction_data['title']}{separator}{transaction_data['amount']}"
    )

  print(f"\nFound {len(transactions)} transactions\n")


if __name__ == "__main__":
  SEPARATOR = ";"

  if len(argv) < 2:
    # m bank statement - get data from user input
    data = get_raw_input()
    transactions = m_bank_extract_transactions(data)
    print_formated_data(transactions, SEPARATOR)
  else:
    # p bank statement - get data from file
    with open(argv[1], "r") as f:
      data = f.readlines()
    transactions = p_bank_extract_transactions(data)
    print_formated_data(transactions, SEPARATOR)
