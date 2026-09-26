// Rank r -> r+1 costs 300 × min(r, 14) XP (HeroSetConfig RANK_XP_STEP / RANK_COST_CAP_RANK),
// at 600 XP per full day. Plotted from the rule, not hand-placed.
const dayOfRank = (rank: number): number => {
  let xp = 0
  for (let r = 1; r < rank; r++) xp += 300 * Math.min(r, 14)
  return xp / 600
}

const lastRank = 20
const span = dayOfRank(lastRank)
const ranks = Array.from({ length: lastRank - 1 }, (_, i) => i + 2)
const called: Record<number, string> = { 2: 'Day 1', 10: '~3 weeks', 14: '~6½ weeks, then a rank a week', 20: '~12½ weeks' }

export function RankScale() {
  return (
    <figure className="rank-scale">
      <div className="rank-scale__track" role="img" aria-label="Ranks reached with a full 100, 100, 100 every day: rank 2 on day one, rank 10 in about three weeks, rank 14 in about six and a half weeks, then one rank per week.">
        {ranks.map((rank) => (
          <span
            key={rank}
            className={called[rank] ? 'rank-scale__tick is-called' : 'rank-scale__tick'}
            style={{ left: `${(dayOfRank(rank) / span) * 100}%` }}
          >
            {called[rank] && <span className="rank-scale__label"><b>Rank {rank}</b>{called[rank]}</span>}
          </span>
        ))}
      </div>
      <figcaption>Ranks reached doing the full 100 / 100 / 100 every day. Rank reflects the reps you do, not the goal you pick.</figcaption>
    </figure>
  )
}
