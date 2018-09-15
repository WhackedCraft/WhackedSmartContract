pragma solidity ^0.4.23;

contract Exchange {

    event AssetAssign(uint id, address user, address emitter, string data);
    event AssetBurn(uint id);
    event AssetMove(uint id, address from, address to);
    event NewTradeOffer(uint id, address sender, address receiver, uint[] my_items, uint[] their_items);
    event ModifyTradeOffer(uint id, TradeOfferState state);

    enum TradeOfferState {
        PENDING,
        CANCELLED,
        ACCEPTED,
        DECLINED
    }

    struct Asset {
        address asset_emitter;
        string data;
    }

    struct TradeOffer {
        address offer_sender;
        address offer_recipient;
        uint[] my_items;
        uint[] their_items;
        TradeOfferState state;
    }

    struct User {
        uint[] owned_assets;
        uint pending_offer_id;
    }

    TradeOffer[] offers;
    Asset[] assets;

    mapping(address => User) users;

    function assign(address _user, string _data) external {
        // gives a new asset with _data string to _user
        // asset_emitter equals msg.sender
    }

    function burn(uint _id) external {
        // burns the asset with given id or throws IF:
        // - the asset emitter is not msg.sender
        // - the asset with said id does not exist
    }

    function sendTradeOffer(address _partner, uint[] _my_items, uint[] _their_items) external {
        // should make a new trade offer or throw IF:
        // - sender address does not have an item listen in _my_items
        // - partner address does not have an item listen in _their_items
        // - you have a pending trade offer
    }

    function cancelTradeOffer() external {
        // should cancel pending trade offer or throw IF:
        // - sender has no pending tradeoffer
    }

    function acceptTradeOffer(uint _offer_id) external {
        // should make the magic (exchange the items) or throw IF:
        // - offer_recipient is not sender
        // - items do not exist anymore in either inventories
        // - offer must be PENDING
    }

    function declineTradeOffer(uint _offer_id) external {
        // should decline pending trade offer or throw IF:
        // - _offer_id does not exist
        // - offer's recipient is not msg.sender
        // - offer is not PENDING
    }

    function getUserInventory(address _address) external view returns (uint[]) {
        return users[_address].owned_assets;
    }

    function getMyInventory() external view returns (uint[]) {
        return users[msg.sender].owned_assets;
    }
}