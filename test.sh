
# p0 o1 install
peer chaincode install -n mypd -v 1.0 -p github.com/chaincode/myprivate/
# p1 o1 install
export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
peer chaincode install -n mypd -v 1.0 -p github.com/chaincode/myprivate/
# p0 o2 install
export CORE_PEER_LOCALMSPID=Org2MSP
export PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
peer chaincode install -n mypd -v 1.0 -p github.com/chaincode/myprivate/
# p1 o2 install
export CORE_PEER_ADDRESS=peer1.org2.example.com:10051
peer chaincode install -n mypd -v 1.0 -p github.com/chaincode/myprivate/
# p1 o2 instantiate
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile $ORDERER_CA -C mychannel -n mypd -v 1.0 -c '{"Args":["init"]}' -P "OR('Org1MSP.member','Org2MSP.member')" --collections-config  $GOPATH/src/github.com/chaincode/myprivate/collections_config.json

sleep 5

# p0 o1 invoke - initMarble -marble1
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

export MARBLE=$(echo -n "{\"name\":\"marble1\",\"color\":\"blue\",\"size\":35,\"owner\":\"tom\",\"price\":99}" | base64 | tr -d \\n)
peer chaincode invoke -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n mypd -c '{"Args":["initMarble"]}'  --transient "{\"marble\":\"$MARBLE\"}"

sleep 5

# p0 o1 query - readMarble -marble1
peer chaincode query -C mychannel -n mypd -c '{"Args":["readMarble","marble1"]}'
# p0 o1 query - readMarblePrivateDetail -marble1
peer chaincode query -C mychannel -n mypd -c '{"Args":["readMarblePrivateDetails","marble1"]}'
# p0 o2 query - readMarble -marble1
export CORE_PEER_ADDRESS=peer0.org2.example.com:9051
export CORE_PEER_LOCALMSPID=Org2MSP
export PEER0_ORG2_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

peer chaincode query -C mychannel -n mypd -c '{"Args":["readMarble","marble1"]}'
# p0 o2 query - readMarblePrivateDetail -marble1
peer chaincode query -C mychannel -n mypd -c '{"Args":["readMarblePrivateDetails","marble1"]}'

# purge process
# p0 o1 invoke - initMarble -marble2

# p0 o1 invoke - transferMarble -marble2 -newOwner CHOI

# p0 o1 invoke - transferMarble -marble2 -newOwner LEE

# p0 o1 invoke - transferMarble -marble2 -newOwner KIMM

# p0 o1 query - readMarblePrivateDetail -marble1

# p0 o2 query - readMarblePrivateDetail -marble1


