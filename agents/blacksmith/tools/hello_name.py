#!/usr/bin/env python3
import argparse

def main():
    parser = argparse.ArgumentParser(description="A simple hello world script that greets a given name.")
    parser.add_argument("--name", type=str, default="World", help="The name to greet.")
    args = parser.parse_args()
    print(f"Hello, {args.name}!")

if __name__ == "__main__":
    main()
