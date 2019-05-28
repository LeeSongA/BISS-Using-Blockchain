pragma solidity ^0.4.19;

contract Root{
    address owner;
    
    constructor (){
        owner = msg.sender;    
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    mapping (address => uint8) redcross;
    mapping (address => uint8) sensor;
    mapping (address => uint8) hospital;
    
    function registRedCross(address redCrossAdd) onlyOwner {
        require(!checkRedCross(redCrossAdd));
        redcross[redCrossAdd] = 1;
    }
    
    function registSensor(address sensorAdd) onlyOwner {
        require(!checkSensor(sensorAdd));
        sensor[sensorAdd]= 1;
    }
    
    function registHospital(address hospitalAdd) onlyOwner {
        require(!checkHospital(hospitalAdd));
        hospital[hospitalAdd]=1;
    }
    
    function checkRedCross(address add) view returns (bool) {
        return redcross[add] == 1;
    }
    function checkSensor(address add) view returns (bool) {
        return sensor[add] == 1;
    }
    function checkHospital(address add) view returns (bool) {
        return hospital[add] == 1;
    }
    
    function deleteRedCross(address redCrossAdd) onlyOwner {
        redcross[redCrossAdd] = 0;
    }
    
    function deleteSensor(address sensorAdd) onlyOwner {
        sensor[sensorAdd]= 0;
    }
    
    function deleteHospital(address hospitalAdd) onlyOwner {
        hospital[hospitalAdd]=0;
    }
    
    modifier onlyRedcross(){
        require(redcross[msg.sender] ==1);
        _;
    }
    
    modifier onlySensor(){
        require(sensor[msg.sender]==1);
        _;
    }
    
    modifier onlyHospital(){
        require(hospital[msg.sender]==1);
        _;
    }
    
   /* //event UpdateLocation(uint bloodId, string place);
    //event UpdateTemperature(uint bloodId, int16 temperature);
    
    //BloodBag[] private bloods;
    //mapping (uint => address) public bloodToAgency; //blood 소유기관 (폐기하면 -1로?)
    //mapping (address => uint[]) userToBloods; //user means agency or receiver
    //mapping (address => uint) ownerBloodCount; //각 user가 소유한 혈액 개수

    agency = 혈액 소유 기관*/
    /*
    constructor (address redcrossAdd, address sensorAdd) public {
        _addRedCross(redcrossAdd);
        _addSensor(sensorAdd);
    }
    */
    

   /* modifier onlyAgency(uint bloodId){
        require(bloodToAgency[bloodId] ==msg.sender);
        _;
    }
    
    //new blood create (only by redcross)
    function registNewBlood(uint8 _type) public onlyRedcross(msg.sender) returns (uint id) {
        uint id = bloods.push(BloodBag(BloodInfo(now, _type, 0, 0, 0x00), 1, msg.sender, 0, SensingInfo("", int16(0xFFFF)))) - 1;
        bloodToAgency[id] = msg.sender;
        userToBloods[msg.sender].push(id);
        ownerBloodCount(msg.sender)++;
        emit NewBlood(bloods[id].bloodInfo.registTimestamp, id, _type);
        return (id);
    }
    
    function setBloodType(uint id, uint8 _type) public onlyAgency(id){
        bloods[id].info.bloodType = _type;
    }
    function setCheck1(uint id, byte testdata) public onlyAgency(id){
        bloods[id].info.check = byte(0x80) || testdata;
    }
    function setCheckProtein(uint id, uint8 testdata) public onlyAgency(id){ //6~8이 정상
        bloods[id].info.checkProtein = testdata;
    }
    function setCheckAlt(uint id, uint8 testdata) public onlyAgency(id){ //45 이하가 정상
        bloods[id].info.checkAlt = testdata;
    }
    
    function getBloodInfo(uint id) public view returns (uint registTimestamp, uint8 _type, uint8 checkAlt, uint8 checkProtein, byte check,
                                                        uint8 state, address agency, address receiver, string location, int16 temperature){
        require(hospital[msg.sender] || redcross[msg.sender] || bloods[id].receiver == msg.sender);
        BloodBag memory tmpBlood = bloods[id];
        return (tmpBlood.registTimestamp, tmpBlood.bloodType, tmpBlood.checkAlt, tmpBlood.checkProtein, tmpBlood.check, 
        tmpBlood.state,tmpBlood.agency, tmpBlood.receiver, tmpBlood.sensingInfo.location, tmpBlood.sensingInfo.temperature);
    }

    //소유기관 변경
    function updateAgnecy(uint id, address newAgency) public onlyAgency(id) {
        bloods[id].state = 2;
        bloodToAgency[id] = newAgency;
        ownerBloodCount[newAgency]++;
        ownerBloodCount[msg.sender]--;
        //userToBloods[newAgency].push(id);
    }

    //수혈자 설정
    function setReceiver(uint id, address receiver) public onlyAgency(id) {
        bloods[id].receiver = receiver;
        bloods[id].state = 3;
        ownerBloodCount[receiver]++;
        //ownerBloodCount[msg.sender]--;
        //userToBloods[receiver].push(id);
    }
    
    //call by only sensing node
    function updateLocation(uint id, string location) public onlySensor(msg.sender){
        bloods[id].sensingInfo.location = location;
        emit UpdateLocation(id, place);
    }
    
    //call by only sensing node
    function updateTemperature(uint id, int16 temperature) public onlySensor(msg.sender){ //전혈 기준 1~6이 정상
        bloods[id].sensingInfo.temperature = temperature;
        emit UpdateTemperature(id, temperature);
    }
    
    //혈액 폐기 
    function discard(uint id) public onlyAgency(id) {
        require(msg.sender == bloodToAgency[id] && (bloods[id].state == 1 || bloods[id].state == 2));
        bloods[id].state = 4;
    }
    
    //return receiver's blood id
    function getBloodsByReceiver() external view returns(uint[]) {
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
    
    //return agency's blood id
    function getBloodsByAgency() external view returns(uint[]) {
        require(hospital[msg.sender] || redcross[msg.sender]);
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
    }*/
}