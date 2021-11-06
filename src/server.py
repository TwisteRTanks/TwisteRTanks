import socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('', 9265))
client = []  # Массив где храним адреса клиентов
print('Start Server')
while 1:
    data, addres = sock.recvfrom(1024)
    print(f"{addres[0]}:{addres[1]} cords = {data}")
    if addres not in client:
        client.append(addres)  # Если такого клиента нету , то добавить
    for clients in client:
        if clients == addres:
            continue  # Не отправлять данные клиенту, который их прислал
        sock.sendto(data, clients)
