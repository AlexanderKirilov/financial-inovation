import sys
import json

def main():
    # Read from stdin
    input_data = sys.stdin.read()

    try:
        # Parse the JSON data
        parsed_data = json.loads(input_data)
        print("I AM PYTHON \n")
        print(parsed_data)
    except json.JSONDecodeError:
        print("Error: Invalid JSON data")

if __name__ == "__main__":
    main()