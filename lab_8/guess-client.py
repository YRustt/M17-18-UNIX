import sys
import argparse
import socket
import struct


def get_parsed_args():
    parser = argparse.ArgumentParser(description="Guess-client", add_help=True)
    parser.add_argument("unix_socket", nargs="?", help="path to unix socket")
    parser.add_argument("-t", "--tcp", nargs=2, help="tcp mode: host port")

    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = get_parsed_args()

    if args.unix_socket:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        server_address = args.unix_socket
    elif args.tcp:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_address = (args.tcp[0], int(args.tcp[1]))
    else:
        sys.stderr.write("Неправильные аргументы\n")
        sys.exit(1)

    try:
        sock.connect(server_address)
    except socket.error:
        sys.exit(1)

    left, right = 0, 1000000000
    for _ in range(32):
        tmp = (left + right) // 2
        sock.send(struct.pack(">I", tmp))
        
        res = sock.recv(1).decode('utf-8')
        if res == "=":
            print("Ответ: {}".format(tmp))
            sys.exit(0)
            break
        elif res == "<":
            right = tmp - 1
        elif res == ">":
            left = tmp + 1
        else:
            raise ValueError()

    sys.stderr.write("Что-то пошло не так\n")
    sys.exit(1)

     
