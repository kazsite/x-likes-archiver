import os
import sys


def create_cookie_file():
    auth_token = os.environ.get("X_AUTH_TOKEN")
    ct0 = os.environ.get("X_CT0")
    output_path = "/tmp/x_cookies.txt"

    if not auth_token or not ct0:
        print("Error: X_AUTH_TOKEN or X_CT0 is not set.")
        sys.exit(1)

    cookies = [
        [".x.com", "TRUE", "/", "TRUE", "1808636480", "auth_token", auth_token],
        [".x.com", "TRUE", "/", "TRUE", "1808636481", "ct0", ct0],
    ]

    try:
        with open(output_path, "w", encoding="utf-8") as f:
            f.write("# Netscape HTTP Cookie File\n")
            f.writelines("\t".join(c) + "\n" for c in cookies)
        print(f"Success: Cookie file created at {output_path}")
    except Exception as e:
        print(f"Error: Failed to write cookie file. {e}")
        sys.exit(1)


if __name__ == "__main__":
    create_cookie_file()
