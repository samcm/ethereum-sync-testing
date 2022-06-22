# Automated Sync Tests
This document covers the on-going automated sync tests that the EF is running on a weekly basis. The tests run in Kubernetes, but are started/monitored/finished with Github Actions.




> Repo: https://github.com/samcm/ethereum-sync-testing

> Run your own tests: https://github.com/samcm/ethereum-sync-test-helm-chart

Contact: [Twitter](https://twitter.com/samcmAU)


## Test Case: Syncs To Head (Ropsten)
The most basic test case. The test concludes when both clients consider themselves synced & the chain progresses.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |  ✔️  |  ✔️  |     ✔️     |   x    |
| **Prysm**      |  ✔️  |  ✔️  |     ✔️     |   x    |
| **Teku**       |  ✔️  |  ✔️  |     ✔️     |   x    |
| **Lodestar**   |  ✔️  |  ✔️  |     ✔️     |   x    |
| **Nimbus**     |  x   |  x   |     x      |   x    |

Notes:
- Nimbus consistently stops syncing at epoch 2035 with all ELs (except potentially Erigon).
- Erigon tests on-going, was previously being OOMKilled for using 14gb memory on a 16gb node.


## Test Case: Complex 1 (Ropsten)
Fully syncs EL & CL, stops the EL for < 1 epoch and then restarts the EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |

## Test Case: Complex 2 (Ropsten)
Fully syncs EL & CL, stops EL for > 1 epoch and then restarts EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |

## Test Case: Complex 3 (Ropsten)
Fully syncs EL, then starts genesis syncing CL. Then stops EL for a few epochs, starts EL and waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |