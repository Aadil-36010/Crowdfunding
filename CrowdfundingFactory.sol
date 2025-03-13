// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Crowdfunding} from "./Crowdfunding.sol";

contract CrowdfundingFactory {
    address public owner ;
    bool public paused;

    struct Campaign {
        address campaignAddress;
        address owner ;
        string name ;
        uint256 creationTime;
    }

    Campaign[] public campaigns;
    mapping(address => Campaign[] ) public userCampaign;

    modifier onlyOwner (){
        require(msg.sender == owner , " Not Owner,");
        _;

    }
    modifier notPaused () {
        require(!paused,"factory is paused.");
        _;
    }
    

    constructor () {
        
        owner = msg.sender;
    }
    function createCampaign (

        string memory _name,
        string memory _description,
        uint256 _goal,
        uint256 _durationIndays
    )external notPaused {
        Crowdfunding newCampaign = new Crowdfunding(
            msg.sender,
            _name,
            _description,
            _goal,
            _durationIndays

        );
        address campaignAddress = address(newCampaign);

        Campaign memory campaign = Campaign({
            campaignAddress:campaignAddress,
            owner: msg.sender,
            name: _name,
            creationTime: block.timestamp 
        });

        campaigns.push(campaign);
        userCampaign[msg.sender].push(campaign);
    }
    function getUserCampaign(address _user)external view returns( Campaign[]memory ){
        return userCampaign[_user];
    }
    function getAllCampaign() external view returns ( Campaign[]memory){
        return campaigns;

    }
    function togglePause() external onlyOwner{
        paused = !paused;
    }

}
