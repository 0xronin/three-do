//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ThreeDo {

    bool isTask = false;

    address public approver1;

    mapping (address => uint) poolAmount;
    mapping (address => string) task;

    modifier onlyApprover() {
        require(msg.sender == approver1, "Cannot be approved by you");
        _;
    }

    function createTodo(string memory _task, address _approver1) public payable {
        require(isTask == false,"task already added");
        require(msg.value > 0, "Pool some ETH to commit for task");
        poolAmount[msg.sender] += msg.value;
        task[msg.sender] = _task;
        isTask = true;
        approver1 = _approver1;
    }

    function deleteTask() public {
        task[msg.sender] = '';
        isTask = false;
    }

    function getTask() public view returns(string memory, uint) {
        return ( task[msg.sender], poolAmount[msg.sender]);
    }

    function withdraw() public onlyApprover {
        address payable to = payable(msg.sender);
        to.transfer(poolAmount[msg.sender]);
        poolAmount[msg.sender] = 0;
    }

    function taskFailed() public {
        address payable to = payable(approver1);
        to.transfer(poolAmount[msg.sender]);
        poolAmount[msg.sender] = 0;
    }

}
