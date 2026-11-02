# Run-layer balance — 2 seed(s) × 4 policy(ies), 40 weeks

8 run(s), 4034 s wall clock, 4.7.2-stable (official).

| metric | cautious | minimal | military-first | accept-all |
|---|---|---|---|---|
| lowest fit officers | 3.50 [3–4] | 9 [7–11] | 5.50 [4–7] | 6 [5–7] |
| weeks under 12 fit | 15.50 [14–17] | 12.50 [1–24] | 30 [29–31] | 22 [19–25] |
| weeks below $0 | 28.50 [28–29] | 0 [0–0] | 7 [5–9] | 32 [30–34] |
| weeks below $0 (1-12) | 7.50 [7–8] | 0 [0–0] | 3.50 [1–6] | 5.50 [4–7] |
| account at week 40 | -1881 [-4189–427] | 413682 [332863–494500] | -2497.50 [-27283–22288] | -3439.50 [-3776–-3103] |
| lowest account | -56667 [-79376–-33958] | 39674 [39132–40216] | -25867 [-27283–-24451] | -37249.50 [-38569–-35930] |
| highest account | 9033 [7766–10300] | 413682 [332863–494500] | 21786.50 [19845–23728] | 8048 [7205–8891] |
| situations unattended | 56 [52–60] | 88 [84–92] | 63.50 [52–75] | 42 [34–50] |
| officers killed | 23.50 [20–27] | 10 [8–12] | 17.50 [14–21] | 25 [21–29] |
| killed per operation | 0.32 [0.27–0.37] | 0.25 [0.20–0.30] | 0.28 [0.19–0.36] | 0.29 [0.24–0.35] |
| civilians killed | 3.50 [3–4] | 2.50 [2–3] | 4.50 [1–8] | 5.50 [5–6] |
| findings | 68.50 [57–80] | 34.50 [32–37] | 62 [60–64] | 68.50 [66–71] |
| allies lost at the end | 3 [3–3] | 2 [2–2] | 3.50 [3–4] | 3.50 [3–4] |
| allies won back | 0 [0–0] | 0 [0–0] | 0 [0–0] | 0 [0–0] |
| run score | -671 [-709–-633] | -409.50 [-429–-390] | -606.50 [-628–-585] | -856.50 [-963–-750] |
| chief kept | 2/2 | 2/2 | 2/2 | 2/2 |

## Gate 1 bands — report-only

```
MISS roster-floor               cautious     >= 10  (got 3)
MISS roster-floor               minimal      >= 10  (got 7)
MISS roster-floor               military     >= 10  (got 4)
MISS roster-floor               accept_all   >= 10  (got 5)
MISS roster-weeks               cautious     <= 8  (got 17)
MISS roster-weeks               minimal      <= 8  (got 24)
MISS roster-weeks               military     <= 8  (got 31)
MISS roster-weeks               accept_all   <= 8  (got 25)
MISS money-deficit              cautious     <= 8  (got 29)
ok   money-deficit              minimal      <= 8  (got 0)
MISS money-deficit              military     <= 8  (got 9)
MISS money-deficit              accept_all   <= 8  (got 34)
MISS money-debt                 cautious     >= -75000  (got -79376)
ok   money-debt                 minimal      >= -75000  (got 39132)
ok   money-debt                 military     >= -75000  (got -27283)
ok   money-debt                 accept_all   >= -75000  (got -38569)
MISS money-end                  cautious     >= 0  (got -1881)
ok   money-end                  minimal      >= 0  (got 413682)
MISS money-end                  military     >= 0  (got -2497.50)
MISS money-end                  accept_all   >= 0  (got -3439.50)
MISS coverage                   cautious     <= 48  (got 56)
MISS coverage                   minimal      <= 48  (got 88)
MISS coverage                   military     <= 48  (got 63.50)
ok   coverage                   accept_all   <= 48  (got 42)
MISS deaths                     cautious     <= 8  (got 23.50)
MISS deaths                     minimal      <= 8  (got 10)
MISS deaths                     military     <= 8  (got 17.50)
MISS deaths                     accept_all   <= 8  (got 25)
MISS lethality                  cautious     <= 0.15  (got 0.37)
MISS lethality                  minimal      <= 0.15  (got 0.30)
MISS lethality                  military     <= 0.15  (got 0.36)
MISS lethality                  accept_all   <= 0.15  (got 0.35)
ok   civilians                  cautious     <= 6  (got 3.50)
ok   civilians                  minimal      <= 6  (got 2.50)
ok   civilians                  military     <= 6  (got 4.50)
ok   civilians                  accept_all   <= 6  (got 5.50)
MISS allies-held                cautious     <= 2  (got 3)
ok   allies-held                minimal      <= 2  (got 2)
MISS allies-held                military     <= 2  (got 3.50)
MISS allies-held                accept_all   <= 2  (got 3.50)
MISS ally-recovery              cautious     >= 0.25  (got 0)
MISS ally-recovery              minimal      >= 0.25  (got 0)
MISS ally-recovery              military     >= 0.25  (got 0)
MISS ally-recovery              accept_all   >= 0.25  (got 0)
MISS score                      cautious     >= 0  (got -671)
MISS score                      minimal      >= 0  (got -409.50)
MISS score                      military     >= 0  (got -606.50)
MISS score                      accept_all   >= 0  (got -856.50)
ok   election                   cautious     >= 0.50  (got 1)
ok   election                   minimal      >= 0.50  (got 1)
ok   election                   military     >= 0.50  (got 1)
ok   election                   accept_all   >= 0.50  (got 1)
```

37 band miss(es); report-only until P1.I (balance_bands.json "enforce").

## What each policy does

- **cautious** — Hire to 14 (an emergency lateral below 12 fit, a standing order for 18 on the books), train, restraint contracts, no military hardware, take the suggested raid kit, answer the gravest two calls and keep high-trauma officers off crowd duty.
- **minimal** — No hiring, no courses, no contracts, no programs, every offer declined, cases left to lapse, one call a week.
- **military-first** — Military contracts and kit, Kettering's offers, cases cleared, hire to 16 (an emergency lateral below 12 fit), three calls a week including crowd events.
- **accept-all** — Sign the cheapest contract and program on the desk, accept every offer and answer every event, hire to 18 (a standing order for 20 on the books), let plans buy kit, three calls a week.