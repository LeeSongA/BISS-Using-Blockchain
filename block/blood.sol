pragma solidity ^0.4.19;

contract Blood {

    event UpdateLocation(uint indexed bloodId, string place);
    event UpdateTemperature(uint indexed bloodId, int16 temperature);
    event NewBlood(uint timestamp, uint256 id, uint8 indexed _type);
    
    struct BloodInfo{
        uint registTimestamp;
        uint8 bloodType;
        uint8 checkAlt;
        uint8 checkProtein;
        byte check;
    }
    
    struct SensingInfo{
        string location;
        int16 temperature; //1~6이 정상
    }
    
    struct BloodBag{
        uint registTimestamp;
        uint transfer;
        uint8 bloodType;
        uint8 checkAlt;
        uint8 checkProtein;
        uint8 state;  //0(x), redcross(1), test(3), bank(5), hospital(7), receiver(8), discard(9)
        byte check; 
        address agency; //소유 기관
        address receiver; //수혈자
        SensingInfo sensingInfo;
    }
}