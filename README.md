# Automated Sync Tests
This document covers the on-going automated sync tests that the EF DevOps team is running on a weekly basis. The tests run in Kubernetes, but are started/monitored/finished with Github Actions.

All logs are uploaded as job artifacts & also stored in s3 for public consumption. Metrics & logs are available in the EF Grafana instance for client teams to access. If any client teams are missing access please reach out.

If you're interested in running your own tests check out the Helm Chart to get started.

### Links
- Repo: https://github.com/samcm/ethereum-sync-testing
- Helm Chart: https://github.com/samcm/ethereum-sync-test-helm-chart

Contact: [Twitter](https://twitter.com/samcmAU)


## Tests


-----

### Syncs To Head (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-to-head.yaml)

The most basic test case. The test concludes when both clients consider themselves synced & the chain progresses.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |  ✔️  |  ✔️  |     ✔️     |   ✔️    |
| **Prysm**      |  ✔️  |  ✔️  |     ✔️     |   x    |
| **Teku**       |  ✔️  |  ✔️  |     ✔️     |   ✔️    |
| **Lodestar**   |  ✔️  |  ✔️  |     ✔️     |   ✔️    |
| **Nimbus**     |  x   |  x   |     x      |   ✔️    |

Notes:
- Nimbus potentially just needs more time - tests re-running.
- `prysm-erigon` timed out, re-running.

------

### Complex 1 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex1.yaml)

Fully syncs EL & CL, stops the EL for < 1 epoch and then restarts the EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |  ✔️  |  ✔️  |     ✔️     |       |
| **Prysm**      |  ✔️  |  ✔️  |     ✔️     |       |
| **Teku**       |  ✔️  |  ✔️  |     ✔️     |       |
| **Lodestar**   |  ✔️  |  ✔️  |     ✔️     |       |
| **Nimbus**     |      |      |            |        |

Notes:
- Nimbus & Erigon haven't run yet - disabled until the `To Head` tests pass.

------

### Complex 2 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex2.yaml)

Fully syncs EL & CL, stops EL for > 1 epoch and then restarts EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |  ✔️  |   ✔️   |      ✔️      |        |
| **Prysm**      |  ✔️  |  ✔️  |            |        |
| **Teku**       |  ✔️  |   ✔️   |     ✔️       |        |
| **Lodestar**   |  ✔️  |  ✔️  |      ✔️      |        |
| **Nimbus**     |      |      |            |        |

- Nimbus & Erigon haven't run yet - disabled until the `To Head` tests pass.

-----

### Complex 3 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex3.yaml)

Fully syncs EL, then starts genesis syncing CL. Then stops EL for a few epochs, starts EL and waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |   ✔️   |            |        |
| **Prysm**      |      |   ✔️   |            |        |
| **Teku**       |      |      |            |        |
| **Lodestar**   |      |      |            |        |
| **Nimbus**     |      |      |            |        |

Notes: Tests on-going

-----

## Development
### TODO: 
- Snapshot EF Grafana dashboard after each job completes and publish for the community to access
- Add additional test cases