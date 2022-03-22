// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract KendoApp {
    address public owner;
    struct KendoPlayer {
        string Name;
        string SurName;
        uint8 Age;
        //string TechnicalGrade;
        bool active;
        TechnicalGrade _TechnicalGrade;
    }

    uint256 mapSize;

    mapping(address => KendoPlayer) public KendoPlayers;
    address[] public KendoPlayersAddresses;

    address[] public ActivePlayersInTournament;

    enum TechnicalGrade {
        SixKyu,
        FiveKyu,
        FourKyu,
        ThreeKyu,
        TwoKyu,
        OneKyu,
        OneDan,
        TwoDan,
        ThreeDan,
        FourDan,
        FiveDan,
        SixDan,
        SevenDan,
        EightDan
    }
    TechnicalGrade choice;

    constructor() {
        owner = msg.sender;
    }

    function addKendoPlayer(
        address addr,
        string memory name,
        string memory surname,
        uint8 age,
        TechnicalGrade technical // string memory technicalgrade
    ) external {
        KendoPlayers[addr].Name = name;
        KendoPlayers[addr].SurName = surname;
        KendoPlayers[addr].Age = age;
        //KendoPlayers[addr].TechnicalGrade = technicalgrade;
        KendoPlayers[addr]._TechnicalGrade = technical;
        KendoPlayers[addr].active = true;
        mapSize++;
        KendoPlayersAddresses.push(addr);
    }

    function getKendoPlayer(address addr)
        external
        view
        returns (KendoPlayer memory)
    {
        return KendoPlayers[addr];
    }

    function AddPlayerInTheTournament(
        uint256 minAge,
        uint256 maxAge,
        TechnicalGrade minTechnicalGrade,
        TechnicalGrade maxTechnicalGrade
    ) external {
        for (uint256 i = 0; i < mapSize; i++) {
            address addr = KendoPlayersAddresses[i];
            if (
                KendoPlayers[addr].Age > minAge &&
                KendoPlayers[addr].Age < maxAge &&
                KendoPlayers[addr]._TechnicalGrade > minTechnicalGrade &&
                KendoPlayers[addr]._TechnicalGrade < maxTechnicalGrade
            ) {
                ActivePlayersInTournament.push(addr);
            }
        }
    }

    function getSubjects() external view returns (address[] memory) {
        return ActivePlayersInTournament;
    }

    function CreateBracket(uint256 sizeoftour) external {}

    // Solidity pseudo-random function:
    function random() private view returns (uint256) {
        // sha3 and now have been deprecated
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        ActivePlayersInTournament
                    )
                )
            );
        // convert hash to integer
        // players is an array of entrants
    }

    function remove(uint256 index) public {
        ActivePlayersInTournament[index] = ActivePlayersInTournament[
            ActivePlayersInTournament.length - 1
        ];
        ActivePlayersInTournament.pop();
    }

    // invoke random function in a pickWinner example function
    function pickWinner() public returns (uint256) {
        uint256 index = random() % ActivePlayersInTournament.length;
        remove(index);
        return index;
    }
}
