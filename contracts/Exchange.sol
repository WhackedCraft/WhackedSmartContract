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
        address emitter;
        address owner;
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

    // gives a new asset with _data string to _user
    // asset_emitter equals msg.sender
    function assign(address _owner, string _data) external {
        assets.push(Asset(msg.sender, _owner, _data));
        users[_owner].owned_assets.push(assets.length - 1);
    }
    
    // burns the asset with given id or throws IF:
    // - the asset emitter is not msg.sender
    // - the asset with said id does not exist

    function burn(uint _id) external {

        require(assets[_id].emitter == msg.sender, "In order to burn an asset, you need to be the one who emitted it.");
        
        for(uint i = 0; i < users[assets[_id].owner].owned_assets.length; i++)
        {
            if(users[assets[_id].owner].owned_assets[i] == _id) {
                removeUserAsset(assets[_id].owner, _id);
            }
        }

        delete assets[_id];

    }

    function removeUserAsset(address _user, uint _id) internal {

        uint index = users[_user].owned_assets.length;
        
        for(uint i = 0; i < users[_user].owned_assets.length; i++) {
            if(users[_user].owned_assets[i] == _id) {
                index = _id;
                break;
            }
        }

        if (index >= users[_user].owned_assets.length) return;

        for (i = index; i < users[_user].owned_assets.length-1; i++){
            users[_user].owned_assets[i] = users[_user].owned_assets[i+1];
        }
        users[_user].owned_assets.length--;
    }

    function getAssetEmmiter(uint _id) external view returns (address) {
        return assets[_id].emitter;
    }

    function getAssetOwner(uint _id) external view returns (address) {
        return assets[_id].owner;
    }

    function getAssetData(uint _id) external view returns (string) {
        return assets[_id].data;
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