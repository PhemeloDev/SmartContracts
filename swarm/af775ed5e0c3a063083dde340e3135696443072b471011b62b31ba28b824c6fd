// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract DocumentSignerTest {
    struct Document {
        string documentHash;     // Simulating IPFS hash or document reference
        address[] signers;       // Required signers
        mapping(address => bool) hasSigned;
        bool isCompleted;
        uint256 amount;
    }
    
    mapping(uint256 => Document) public documents;
    uint256 public documentCount;
    
    event DocumentCreated(uint256 documentId, string documentHash, address[] signers, uint256 amount);
    event DocumentSigned(uint256 documentId, address signer);
    event PaymentReleased(uint256 documentId, uint256 amount);
    
    // Create a document with required signers
    function createDocument(string memory _documentHash, address[] memory _signers) public payable {
        require(_signers.length > 0, "Need at least one signer");
        require(msg.value > 0, "Must include payment");
        
        uint256 docId = documentCount;
        Document storage doc = documents[docId];
        
        doc.documentHash = _documentHash;
        doc.signers = _signers;
        doc.amount = msg.value;
        
        documentCount++;
        
        emit DocumentCreated(docId, _documentHash, _signers, msg.value);
    }
    
    // Sign a document
    function signDocument(uint256 _documentId) public {
        Document storage doc = documents[_documentId];
        
        require(!doc.isCompleted, "Document already completed");
        require(isSigner(msg.sender, doc.signers), "Not authorized to sign");
        require(!doc.hasSigned[msg.sender], "Already signed");
        
        doc.hasSigned[msg.sender] = true;
        emit DocumentSigned(_documentId, msg.sender);
        
        if (checkAllSigned(_documentId)) {
            doc.isCompleted = true;
            payable(msg.sender).transfer(doc.amount);
            emit PaymentReleased(_documentId, doc.amount);
        }
    }
    
    // Helper: Check if address is a signer
    function isSigner(address _signer, address[] memory _signers) internal pure returns (bool) {
        for (uint i = 0; i < _signers.length; i++) {
            if (_signers[i] == _signer) return true;
        }
        return false;
    }
    
    // Helper: Check if all parties have signed
    function checkAllSigned(uint256 _documentId) internal view returns (bool) {
        Document storage doc = documents[_documentId];
        for (uint i = 0; i < doc.signers.length; i++) {
            if (!doc.hasSigned[doc.signers[i]]) return false;
        }
        return true;
    }
    
    // View function to check document status
    function getDocumentInfo(uint256 _documentId) public view returns (
        string memory documentHash,
        address[] memory signers,
        bool completed,
        uint256 amount
    ) {
        Document storage doc = documents[_documentId];
        return (doc.documentHash, doc.signers, doc.isCompleted, doc.amount);
    }

    // View function to check if a specific address has signed
    function hasAddressSigned(uint256 _documentId, address _signer) public view returns (bool) {
        return documents[_documentId].hasSigned[_signer];
    }
}