# Automated Sync Tests
This document covers the on-going automated sync tests that the EF DevOps team is running on a weekly basis. The tests run in Kubernetes, but are started/monitored/finished with Github Actions.


> Repo: https://github.com/samcm/ethereum-sync-testing

> Run your own tests: https://github.com/samcm/ethereum-sync-test-helm-chart

Contact: [Twitter](https://twitter.com/samcmAU)

All logs are uploaded as job artifacts. Metrics & logs are available in the EF Grafana instance for client teams to access. If any client teams are missing access please reach out.


## Tests
All tests use genesis syncing unless otherwise stated in the test description.
### Syncs To Head (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-to-head.yaml)

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


### Complex 1 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex1.yaml)

Fully syncs EL & CL, stops the EL for < 1 epoch and then restarts the EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |

### Complex 2 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex2.yaml)

Fully syncs EL & CL, stops EL for > 1 epoch and then restarts EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |

### Complex 3 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex3.yaml)

Fully syncs EL, then starts genesis syncing CL. Then stops EL for a few epochs, starts EL and waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |      |            |        |
| **Prysm**      |      |      |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |


## Development
### TODO: 
- Snapshot EF Grafana dashboard after each job completes and publish for the community to access
- Add additional test cases