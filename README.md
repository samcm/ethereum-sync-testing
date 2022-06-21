# Ethereum Sync Testing
Runs a suite of tests against all Ethereum EL/CL clients using Kubernetes & Github Actions. Each client pair/test/network runs once a week.


If you would like to run your own tests, or to contribute, the Helm chart that faciliates these tests can be found [here](https://github.com/samcm/ethereum-sync-test-helm-chart).
# Results
**Check out the public spreadsheet here:
{{LINK}}**

# 
## Design
Tests are started, watched, and cleaned up by Github Actions to give the client teams & community an easier way to observe test runs. All client logs are uploaded as artifacts at the completion of a run. Test runs can be seen in the [Github Actions](https://github.com/samcm/ethereum-sync-testing/actions) panel for this repo.

The actual tests can be run against 2 Kubernetes clusters:
- KinD (within the Github Actions runner) (`kind`)
- EF Sync Testing Kubernetes cluster (`do`)

Any tests that are expected to run for longer than 60mins should use the `do` Kubernetes cluster. 

### Supported tests
- **Is Healthy** - Waits for both the EL and CL to be "healthy".
- **Starts Syncing** - Waits for both the EL and CL to start syncing.
- **To Head** - The stock standard test. Waits for the client pair to sync to the head of the chain.
- **Complex test 1** - Fully syncs EL & CL, stops the EL for < 1 epoch and then restarts the EL. Waits for both to be considered synced.
- **Complex test 2** - Fully syncs EL & CL, stops EL for > 1 epoch and then restarts EL. Waits for both to be considered synced.
- **Complex test 3** - Fully syncs EL, then starts genesis syncing CL. Then stops EL for a few epochs, starts EL and waits for both to be considered synced.

### Supported Networks
- Kiln
- Ropsten

### Supported Clients
Execution:
- Geth
- Nethermind
- Besu
- Erigon

Consensus:
- Lighthouse
- Prysm
- Teku
- Nimbus
- Lodestar


## Built With

* [samcm/ethereum-sync-test-helm-chart](https://github.com/samcm/ethereum-sync-test-helm-chart)
