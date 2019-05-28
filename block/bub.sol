pragma solidity ^0.4.19;

import "./blood.sol";
import "./root.sol";

contract BUB is Blood, Root{
    
    BloodBag[] private bloods;
    mapping (uint => address) public bloodToAgency; //blood 소유기관= agency (폐기하면 -1로?)
    mapping (address => uint) ownerBloodCount; //각 user가 소유한 혈액 개수
    //mapping (address => uint[]) userToBloods; //user means agency or receiver

    modifier onlyAgency(uint bloodId){
        require(bloodToAgency[bloodId] ==msg.sender);
        _;
    }
    
    modifier agencyHave(uint bloodId){
        require(bloods[bloodId].state < 8);
        _;
    }
    
    modifier canCheck(uint bloodId){
        require(bloods[bloodId].state>2);
        _;
    }
    
    modifier canSend(uint bloodId){
        require(bloods[bloodId].state>=5);
        _;
    }
    
    modifier canTrans(uint bloodId){
        require(bloods[bloodId].state == 7);
        _;
    }
  
    //new blood create (only by redcross)
    function registNewBlood(uint8 _type) public onlyRedcross() returns (uint bloodId) {
     
        uint id = bloods.push(BloodBag(now, 0, _type, 0, 0, 1, 0x00, msg.sender, 0, SensingInfo("RedCross", 3))) - 1;
        bloodToAgency[id] = msg.sender;
        ownerBloodCount[msg.sender]++;
        emit NewBlood(bloods[id].registTimestamp, id, _type);
        return (id);
    }
    
    function setBloodType(uint id, uint8 _type) public onlyAgency(id) agencyHave(id){
        bloods[id].bloodType = _type;
    }
    function setCheck1(uint id, byte testdata) public onlyAgency(id) agencyHave(id) canCheck(id){
        bloods[id].check = byte(0x80) | testdata;
    }
    function setCheckProtein(uint id, uint8 testdata) public onlyAgency(id) agencyHave(id) canCheck(id){ //6~8이 정상
        bloods[id].checkProtein = testdata;
    }
    function setCheckAlt(uint id, uint8 testdata) public onlyAgency(id) agencyHave(id) canCheck(id){ //45 이하가 정상
        bloods[id].checkAlt = testdata;
    }
    
    //소유기관 변경
    function updateAgnecy(uint id, address newAgency) public onlyAgency(id) agencyHave(id) canSend(id){
        bloods[id].state = 6;
        bloods[id].sensingInfo.location = "transfer to Hospital";
        bloods[id].agency = newAgency;
        bloodToAgency[id] = newAgency;
        ownerBloodCount[newAgency]++;
        ownerBloodCount[msg.sender]--;

    }

    //수혈자 설정
    function setReceiver(uint id, address receiver) public onlyAgency(id) agencyHave(id) canTrans(id){
        bloods[id].receiver = receiver;
        bloods[id].state = 8;
        ownerBloodCount[receiver]++;
    }
        
    //혈액 폐기 
    function discard(uint id) public onlyAgency(id) agencyHave(id){
        require(msg.sender == bloodToAgency[id] && (bloods[id].state == 1 || bloods[id].state == 2));
        bloods[id].state = 9;
    }
    
    //call by only sensing node
    function updateLocation(uint id, bool button) public onlySensor() agencyHave(id){ //check면 button clicked, false면 normal
        if(button){
            if(bloods[id].state ==1 || bloods[id].state==3){
                bloods[id].transfer = 1;
                bloods[id].state ++;
                if(bloods[id].state ==2) bloods[id].sensingInfo.location = "to Tester";
                if(bloods[id].state==4)bloods[id].sensingInfo.location = "to BloodBank";
            }
        }
        else{
            if(bloods[id].state == 2 && bloods[id].state ==4 && bloods[id].state ==6){
                bloods[id].transfer +=1;
                if(bloods[id].transfer ==5){
                    bloods[id].state ++;
                    if(bloods[id].state == 3)bloods[id].sensingInfo.location = "Tester";
                    if(bloods[id].state == 5)bloods[id].sensingInfo.location = "BloodBank";
                    if(bloods[id].state == 7)bloods[id].sensingInfo.location = "Hospital";
                }
            }
        }
        emit UpdateLocation(id, bloods[id].sensingInfo.location);
    }
    
    //call by only sensing node
    function updateTemperature(uint id, int16 temperature) public onlySensor() agencyHave(id){ //전혈 기준 1~6이 정상
        bloods[id].sensingInfo.temperature = temperature;
        emit UpdateTemperature(id, temperature);
    }

    
    //////////////////////////////////////////////////////////////////////////////
    //***********************************getter*********************************//
    
    function getBloodInfo(uint id) public view returns (uint registTimestamp, uint8 _type, uint8 checkAlt, uint8 checkProtein, byte check,
                                                        uint8 state, address agency, address receiver, string location, int16 temperature){
        require(hospital[msg.sender]==1 || redcross[msg.sender]==1 || bloods[id].receiver == msg.sender);
        BloodBag tmpBlood = bloods[id];
        return (tmpBlood.registTimestamp, tmpBlood.bloodType, tmpBlood.checkAlt, tmpBlood.checkProtein, tmpBlood.check, 
        tmpBlood.state,tmpBlood.agency, tmpBlood.receiver, tmpBlood.sensingInfo.location, tmpBlood.sensingInfo.temperature);
    }


    function getBloodsIds() view returns(uint[]){
        uint[] memory result = new uint[](ownerBloodCount[msg.sender]);
        if(checkHospital(msg.sender) || checkRedCross(msg.sender)){
            result = getBloodsByAgency();
        }else{
            result = getBloodsByReceiver();
        }
        return result;
    }

    //return receiver's bloods id
    function getBloodsByReceiver() private view returns(uint[]) {
        uint[] memory result = new uint[](ownerBloodCount[msg.sender]);
        uint counter = 0;
        for (uint i = 0; i < bloods.length; i++) {
            if (bloods[i].receiver == msg.sender) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
    //return agency's bloods id
    function getBloodsByAgency() private view returns(uint[]) {
        require(checkHospital(msg.sender) || checkRedCross(msg.sender));
        uint[] memory result = new uint[](ownerBloodCount[msg.sender]);
        uint counter = 0;
        for (uint i = 0; i < bloods.length; i++) {
            if (bloodToAgency[i] == msg.sender) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
    function getBloodsNumber() external view returns(uint256 size){
        return bloods.length;
    }
    
    function uint2str(uint i) internal pure returns (string){
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
}