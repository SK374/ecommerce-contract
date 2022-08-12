// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;

contract Ecommerce {
    struct Product {
        string title;
        string desc;
        address payable owner;
        uint productId;
        uint price;
        address buyer;
        bool delivered;
    }
    uint counter = 1;
    Product[] public products;
    event added(string title, uint productId, address owner);
    event purchased(uint productId, address buyer);
    event delivered(uint productId);

    function addProduct(string memory _title, string memory _desc, uint _price) public {
        require(_price>0, "Price must be greater than zero");
        Product memory newProduct;
        newProduct.title = _title;
        newProduct.desc = _desc;
        newProduct.price = _price * 10**18;
        newProduct.owner = payable(msg.sender);
        newProduct.productId = counter;
        products.push(newProduct);
        counter++;
        emit added(_title, newProduct.productId, msg.sender);
    }

    function buy(uint _productId) payable public {
        require(products[_productId-1].price==msg.value, "Please pay the exact price");
        require(products[_productId-1].owner!=msg.sender, "The owner cannot buy the products");
        products[_productId-1].buyer=msg.sender;
        emit purchased(_productId, msg.sender);
    }

    function delivery(uint _productId) public {
        require(products[_productId-1].buyer==msg.sender, "Confirmation can only be given by the buyer");
        products[_productId-1].delivered = true;
        products[_productId-1].owner.transfer(products[_productId-1].price);
        emit delivered(_productId);
    }
}