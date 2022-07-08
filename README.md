# Automated Sync Tests
This document covers the on-going automated sync tests that the EF DevOps team is running on a weekly basis. The tests run in Kubernetes, but are started/monitored/finished with Github Actions.

All logs are uploaded as job artifacts & also stored in s3 for public consumption. Metrics & logs are available in the EF Grafana instance for client teams to access. If any client teams are missing access please reach out.

If you're interested in running your own tests check out the Helm Chart to get started.

### Links
- Repo: https://github.com/samcm/ethereum-sync-testing
- Helm Chart: https://github.com/samcm/ethereum-sync-test-helm-chart

Contact: [Twitter](https://twitter.com/samcmAU)

## Updates
- **8 July 2022**
    - Should see more success with Nimbus after the inclusion of [this PR](https://github.com/status-im/nimbus-eth2/pull/3793).
    - Erigon still being OOMKilled with `batch-size=128m`, runs happening with `batch-size=16m` now.
    - `complex-3` tests only passing for Besu. Most likely just an issue with the detection for when an EL is considered synced and not indicative of real issues at this stage.
    - Work on adding checkpoint-sync to the tests on-going.

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
- `erigon-prysm` job is being killed for using too much memory, rerunning with a lower `batch-size` in Erigon.
- Expecting to see more success with Nimbus with the inclusion of [this PR](https://github.com/status-im/nimbus-eth2/pull/3793). Run happening here: 
    - https://github.com/samcm/ethereum-sync-testing/actions/runs/2633429388

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
- Nimbus jobs haven't run yet - disabled until the `To Head` tests pass.
- Erigon being OOMKilled, rerunning with lower batch size

------

### Complex 2 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex2.yaml)

Fully syncs EL & CL, stops EL for > 1 epoch and then restarts EL. Waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |  ✔️  |   ✔️   |      ✔️      |        |
| **Prysm**      |  ✔️  |  ✔️  |       ✔️     |        |
| **Teku**       |  ✔️  |   ✔️   |     ✔️       |        |
| **Lodestar**   |  ✔️  |  ✔️  |      ✔️      |    ✔️    |
| **Nimbus**     |      |      |            |        |

- Nimbus jobs haven't run yet - disabled until the `To Head` tests pass.
- Erigon being OOMKilled, rerunning with lower batch size

-----

### Complex 3 (Ropsten)
> Test runs can be found [here](https://github.com/samcm/ethereum-sync-testing/actions/workflows/ropsten-complex3.yaml)

Fully syncs EL, then starts genesis syncing CL. Then stops EL for a few epochs, starts EL and waits for both to be considered synced.
|                | Geth | Besu | Nethermind | Erigon |
| -------------- |:----:|:----:|:----------:|:------:|
| **Lighthouse** |      |   ✔️   |            |        |
| **Prysm**      |      |   ✔️   |            |        |
| **Teku**       |      |   ✔️   |            |        |
| **Lodestar**   |      |   ✔️   |            |        |
| **Nimbus**     |      |      |            |        |

Notes: 
- Besu the only EL client that appears to be working out-of-the-box with this test. Debugging of other EL's ongoing - most likely just an issue with the test itself since the EL needs to report that it is synced once TTD is reached but its unable to do that without a CL.
    - May require additional detection methods around the "Fully syncs EL" step.

-----

## Development
### TODO: 
- Snapshot EF Grafana dashboard after each job completes and publish for the community to access
- Add additional test cases