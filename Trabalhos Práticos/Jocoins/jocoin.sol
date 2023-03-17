// Vinícius de Moraes - 13749910

// Code based on jocoins ICO https://github.com/hagenderouen/mini-chain/blob/master/hadcoins_ico.sol

// Version of compiler
pragma solidity ^0.5.0;

contract jocoin_ico {
    address owner; // Dono atual da moeda

    // Imprimindo o número máximo de jocoins à venda
    uint public max_jocoins = 1000000;

    // Imprimindo a taxa de conversão de USD para jocoins
    uint public usd_to_jocoins = 1000;

    // Imprimindo o número total de jocoins que foram comprados por investidores
    uint public total_jocoins_bought = 0;

    // Mapeamento do endereço do investidor para seu patrimônio em jocoins para USD
    mapping(address => uint) equity_jocoins;
    mapping(address => uint) equity_usd;

    // Verificando se um investidor pode comprar jocoins
    modifier can_buy_jocoins(uint usd_invested) {
        require(owner == msg.sender); // Verifica se o investidor é o dono da moeda
        require (usd_invested * usd_to_jocoins + total_jocoins_bought <= max_jocoins);
        _;
    }

    modifier can_sell_jocoins {
        require(owner == msg.sender); // Verifica se o investidor é o dono da moeda
        _; 
    }

    // Obtendo o patrimônio em jocoins de um investidor
    function equity_in_jocoins(address investor) external view returns (uint) {
        return equity_jocoins[investor];
    }

    // Obtendo o patrimônio em dólares de um investidor
    function equity_in_usd(address investor) external view returns (uint) {
        return equity_usd[investor];
    }

    // Comprando jocoins
    function buy_jocoins(address investor, uint usd_invested) external
    can_buy_jocoins(usd_invested) {
        uint jocoins_bought = usd_invested * usd_to_jocoins;
        equity_jocoins[investor] += jocoins_bought;
        equity_usd[investor] = equity_jocoins[investor] / 1000;
        total_jocoins_bought += jocoins_bought;
    }

    // Vendendo jocoins
    function sell_jocoins(address investor, uint jocoins_sold) external 
    can_sell_jocoins {
        equity_jocoins[investor] -= jocoins_sold;
        equity_usd[investor] = equity_jocoins[investor] / 1000;
        total_jocoins_bought -= jocoins_sold;
    }

    // Mudando o dono da moeda
    function changeOwner(address newOwner) public {
        require(owner == msg.sender);
        owner = newOwner;
    }
}