// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SupplyChain {

    enum Status { Created, InTransit, AtWarehouse, InCustoms, OutForDelivery, Delivered }

    struct Checkpoint {
        string location;
        string action;
        string handler;
        uint256 timestamp;
        Status status;
    }

    struct Product {
        uint256 id;
        string name;
        string origin;
        string manufacturer;
        address owner;
        uint256 createdAt;
        bool exists;
        Checkpoint[] checkpoints;
    }

    mapping(uint256 => Product) private products;
    uint256 public productCount;

    event ProductRegistered(uint256 indexed productId, string name, address owner);
    event CheckpointAdded(uint256 indexed productId, string location, Status status);

    function registerProduct(
        string memory _name,
        string memory _origin,
        string memory _manufacturer,
        string memory _firstLocation
    ) public returns (uint256) {
        productCount++;
        uint256 newId = productCount;

        Product storage p = products[newId];
        p.id = newId;
        p.name = _name;
        p.origin = _origin;
        p.manufacturer = _manufacturer;
        p.owner = msg.sender;
        p.createdAt = block.timestamp;
        p.exists = true;

        p.checkpoints.push(Checkpoint({
            location: _firstLocation,
            action: "Product Registered",
            handler: _manufacturer,
            timestamp: block.timestamp,
            status: Status.Created
        }));

        emit ProductRegistered(newId, _name, msg.sender);
        return newId;
    }

    function addCheckpoint(
        uint256 _productId,
        string memory _location,
        string memory _action,
        string memory _handler,
        Status _status
    ) public {
        require(products[_productId].exists, "Product not found");

        products[_productId].checkpoints.push(Checkpoint({
            location: _location,
            action: _action,
            handler: _handler,
            timestamp: block.timestamp,
            status: _status
        }));

        emit CheckpointAdded(_productId, _location, _status);
    }

    function getProduct(uint256 _productId) public view returns (
        uint256 id,
        string memory name,
        string memory origin,
        string memory manufacturer,
        address owner,
        uint256 createdAt,
        uint256 checkpointCount
    ) {
        require(products[_productId].exists, "Product not found");
        Product storage p = products[_productId];
        return (p.id, p.name, p.origin, p.manufacturer, p.owner, p.createdAt, p.checkpoints.length);
    }

    function getCheckpoint(uint256 _productId, uint256 _checkpointIndex) public view returns (
        string memory location,
        string memory action,
        string memory handler,
        uint256 timestamp,
        Status status
    ) {
        require(products[_productId].exists, "Product not found");
        require(_checkpointIndex < products[_productId].checkpoints.length, "Checkpoint not found");
        Checkpoint storage c = products[_productId].checkpoints[_checkpointIndex];
        return (c.location, c.action, c.handler, c.timestamp, c.status);
    }

    function getCurrentStatus(uint256 _productId) public view returns (Status) {
        require(products[_productId].exists, "Product not found");
        Product storage p = products[_productId];
        return p.checkpoints[p.checkpoints.length - 1].status;
    }
}
