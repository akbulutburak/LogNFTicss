// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract LogNFTics is ERC721, Ownable {
    constructor(address initialOwner)
        ERC721(" LogNFTics", "LGNFT")
        Ownable(initialOwner)
    {}

   struct Shipment {
    uint256 id;                // Sevkiyatın benzersiz kimliği (id)
    string origin;             // Sevkiyatın çıkış noktası (origin)
    string destination;        // Sevkiyatın varış noktası (destination)
    string status;             // Sevkiyatın durumu (status) (örneğin, "Created", "In Transit", "Delivered")
    uint256 timestamp;         // Sevkiyatın zaman damgası (timestamp) (oluşturulma veya güncellenme zamanı)
    string sender;             // Sevkiyatın göndericisi (sender)
    string receiver;           // Sevkiyatın alıcısı (receiver)
    uint256 weight;            // Sevkiyatın ağırlığı (weight) (örneğin, kilogram cinsinden)
    string dimensions;         // Sevkiyatın boyutları (dimensions) (örneğin, "10x20x30 cm")
    string additionalInfo;     // Sevkiyat hakkında ek bilgiler (additionalInfo) (örneğin, özel talimatlar)
}

    mapping(uint256 => Shipment) public shipments;
    uint256 public shipmentCounter;

    event ShipmentCreated(uint256 id, string origin, string destination, uint256 timestamp, string sender, string receiver, uint256 weight, string dimensions, string additionalInfo);
    event ShipmentStatusUpdated(uint256 id, string status, uint256 timestamp);
    event ShipmentDetailsUpdated(uint256 id, string sender, string receiver, uint256 weight, string dimensions, string additionalInfo);

function createShipment(string memory _origin, string memory _destination, string memory _sender, string memory _receiver, uint256 _weight, string memory _dimensions, string memory _additionalInfo) public onlyOwner {
        shipmentCounter++;
        shipments[shipmentCounter] = Shipment(shipmentCounter, _origin, _destination, "Created", block.timestamp, _sender, _receiver, _weight, _dimensions, _additionalInfo);
        _mint(msg.sender, shipmentCounter); // NFT mintleme
        emit ShipmentCreated(shipmentCounter, _origin, _destination, block.timestamp, _sender, _receiver, _weight, _dimensions, _additionalInfo);
    }

    function updateShipmentStatus(uint256 _id, string memory _status) public onlyOwner {
        require(shipments[_id].id != 0, "Shipment does not exist");
        shipments[_id].status = _status;
        shipments[_id].timestamp = block.timestamp;
        emit ShipmentStatusUpdated(_id, _status, block.timestamp);
    }

    function updateShipmentDetails(uint256 _id, string memory _sender, string memory _receiver, uint256 _weight, string memory _dimensions, string memory _additionalInfo) public onlyOwner {
        require(shipments[_id].id != 0, "Shipment does not exist");
        shipments[_id].sender = _sender;
        shipments[_id].receiver = _receiver;
        shipments[_id].weight = _weight;
        shipments[_id].dimensions = _dimensions;
        shipments[_id].additionalInfo = _additionalInfo;
        emit ShipmentDetailsUpdated(_id, _sender, _receiver, _weight, _dimensions, _additionalInfo);
    }

    function getShipment(uint256 _id) public view returns (Shipment memory) {
        require(shipments[_id].id != 0, "Shipment does not exist");
        return shipments[_id];
    }

    function changeManager(address newManager) public onlyOwner {
        transferOwnership(newManager);
    }
}
