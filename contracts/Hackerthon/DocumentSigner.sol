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
    
    // Add mapping to track user's documents
    mapping(address => uint256[]) private userDocuments;
    
    event DocumentCreated(uint256 documentId, string documentHash, address[] signers, uint256 amount);
    event DocumentSigned(uint256 documentId, address signer);
    event PaymentReleased(uint256 documentId, uint256 amount);
    event Debug(string message); // New debug event
    
    // Create a document with required signers
    function createDocument(string memory _documentHash, address[] memory _signers) public payable {
        require(_signers.length > 0, "Need at least one signer");
        require(msg.value > 0, "Must include payment");
        
        uint256 docId = documentCount;
        Document storage doc = documents[docId];
        
        doc.documentHash = _documentHash;
        doc.signers = _signers;
        doc.amount = msg.value;
        
        // Track document for each signer
        for(uint i = 0; i < _signers.length; i++) {
            userDocuments[_signers[i]].push(docId);
        }
        // Also track for creator
        userDocuments[msg.sender].push(docId);
        
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
            emit Debug("All signers have signed, releasing payment");
            payable(msg.sender).transfer(doc.amount);
            emit PaymentReleased(_documentId, doc.amount);
        } else {
            emit Debug("Not all signers have signed yet");
        }
    }
    
    // Helper: Check if address is a signer
    function isSigner(address _signer, address[] memory _signers) public pure returns (bool) {
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
    
    // New function to get all documents for a user
    function getDocumentsForUser(address _user) public view returns (uint256[] memory) {
        return userDocuments[_user];
    }
    
    // New function to get signing status for multiple signers at once
    function getSigningStatus(uint256 _documentId, address[] memory _signers) public view returns (bool[] memory) {
        bool[] memory status = new bool[](_signers.length);
        for(uint i = 0; i < _signers.length; i++) {
            status[i] = documents[_documentId].hasSigned[_signers[i]];
        }
        return status;
    }
}