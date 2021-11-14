# !!! WARNING - TEST SERVER  (не для продакшна) !!! 

import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('', 9265))
clients = []
print('Start Server')
while 1:
    data, addres = sock.recvfrom(1024)

    if data.decode(
    ) == "get_online":
        sock.sendto(str(len(clients)).encode(), addres)

    if addres not in clients:
        clients.append(addres)
    for client in clients:
        if client == addres:
            continue
        sock.sendto(data, client)