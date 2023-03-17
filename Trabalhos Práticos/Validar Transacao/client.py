import socket 
from socket import *

# CLIENT

serverName = "localhost"
serverPort = 15000
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((serverName,serverPort))
clientSocket.receive() # Executa a função recebida
clientSocket.close()