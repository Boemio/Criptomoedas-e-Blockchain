from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import ec
import pickle
import socket 
from socket import *

# Função da transação

def aprovar_transacao():
    #par de chaves de Alice
    private_key_alice = ec.generate_private_key(ec.SECP384R1)
    public_key_alice = private_key_alice.public_key()

    #par de chaves de Bob
    private_key_bob = ec.generate_private_key(ec.SECP384R1)
    public_key_bob = private_key_bob.public_key()
            
    #Transação com alguns dados        
    transacao = {
        'origem': "Alice",
        'destino': "Bob",
        'valor': 50
    }

    transacao = pickle.dumps(transacao)

    # Alice assina a transação com sua chave privada
    signature = private_key_alice.sign(
        transacao,
        ec.ECDSA(hashes.SHA256())
    )


    #Verifica a transação a partir da chave pública de quem a assinou
    #Retorno None -> sem erros
    print(public_key_alice.verify(signature, transacao, ec.ECDSA(hashes.SHA256())))

# SERVER

serverPort = 15000
serverSocket = socket(AF_INET,SOCK_STREAM)
serverSocket.bind(('0.0.0.0',serverPort))
serverSocket.listen(1)
print('The server is ready to receive')
while 1:
     connectionSocket, addr = serverSocket.accept()

     serverSocket.send(aprovar_transacao()) # Manda a função de transação para o outro computador

     connectionSocket.close()