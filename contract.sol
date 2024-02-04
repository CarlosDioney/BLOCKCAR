// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VentaVehiculo is ERC721, Ownable {
    uint256 public totalVehiculos;

    struct Vehiculo {
        string modelo;
        string marca;
        uint256 precio;
        bool vendido;
    }

    mapping(uint256 => Vehiculo) public vehiculos;

    event VehiculoVendido(uint256 indexed tokenId, address indexed comprador);

    constructor() ERC721("TokenVehiculo", "TV") {}

    function crearNuevoVehiculo(string memory _modelo, string memory _marca, uint256 _precio) external onlyOwner {
        uint256 nuevoTokenId = totalVehiculos + 1;
        _safeMint(msg.sender, nuevoTokenId);
        vehiculos[nuevoTokenId] = Vehiculo(_modelo, _marca, _precio, false);
        totalVehiculos += 1;
    }

    function venderVehiculo(uint256 _tokenId) external payable {
        require (_exists(_tokenId), "El vehículo no existe");
        Vehiculo storage vehiculo = vehiculos[_tokenId];
        require(!vehiculo.vendido, "El vehículo ya ha sido vendido");
        require(msg.value == vehiculo.precio, "El monto enviado no coincide con el precio del vehículo");

        // Transferir el vehículo al comprador
        vehiculo.vendido = true;
        _transfer(ownerOf(_tokenId), msg.sender, _tokenId);

        // Emitir evento de venta
        emit VehiculoVendido(_tokenId, msg.sender);
    }
}
