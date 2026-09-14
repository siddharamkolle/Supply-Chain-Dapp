const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying SupplyChain contract...");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const SupplyChain = await ethers.getContractFactory("SupplyChain");
  const supplyChain = await SupplyChain.deploy();

  await supplyChain.waitForDeployment();

  const address = await supplyChain.getAddress();
  console.log("=============================================");
  console.log("✅ SupplyChain deployed to:", address);
  console.log("👆 HE ADDRESS COPY KAR — index.html madhe paste kar!");
  console.log("=============================================");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
