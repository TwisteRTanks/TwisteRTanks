# !!! WARNING - TEST SERVER  (не для продакшна) !!! 

import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('', 9265))
client = []
print('Start Server')
while 1:
    data, addres = sock.recvfrom(1024)
    print(f"{addres[0]}:{addres[1]} cords = {data}")
    if addres not in client:
        client.append(addres)
    for clients in client:
        if clients == addres:
            continue
        sock.sendto(data, clients)
