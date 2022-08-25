//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ThreeDo {

    bool isTask = false;

    bool approvedBy1 = false;
    bool approvedBy2 = false;
    bool approvedBy3 = false;

    address public approver1;
    address public approver2;
    address public approver3;

    mapping (address => uint) poolAmount;
    mapping (address => string) task;

    modifier onlyApprover() {
        require(msg.sender == approver1 || msg.sender == approver2 || msg.sender == approver3, "Cannot be approved by you");
        _;
    }

    function createTodo(string memory _task, address _approver1, address _approver2, address _approver3) public payable {
        require(isTask == false,"task already added");
        require(msg.value > 0, "Pool some ETH to commit for task");
        poolAmount[msg.sender] += msg.value;
        task[msg.sender] = _task;
        isTask = true;
        approver1 = _approver1;
        approver2 = _approver2;
        approver3 = _approver3;
    }

    function deleteTask() public {
        task[msg.sender] = '';
        isTask = false;
    }

    function getTask() public view returns(string memory, uint) {
        return ( task[msg.sender], poolAmount[msg.sender]);
    }

    function withdraw() public {
        require(approvedBy1 == true && approvedBy2 == true && approvedBy3 == true, "Not yet approved");
        address payable to = payable(msg.sender);
        to.transfer(poolAmount[msg.sender]);
        poolAmount[msg.sender] = 0;
    }

    function approve() public onlyApprover {
        if(msg.sender == approver1) {
            approvedBy1 = true;
        }
        if(msg.sender == approver2) {
            approvedBy2 = true;
        }
        if(msg.sender == approver3) {
            approvedBy3 = true;
        }
    }

    function taskFailed() public {
        address payable one = payable(approver1);
        address payable two = payable(approver2);
        address payable three = payable(approver3);
        one.transfer(poolAmount[msg.sender]/3);
        two.transfer(poolAmount[msg.sender]/3);
        three.transfer(poolAmount[msg.sender]/3);
        poolAmount[msg.sender] = 0;
    }

}
