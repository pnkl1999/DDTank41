using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class TVS12003 : AMissionControl
  {
    private int bossID = 12010;
    private SimpleBoss m_boss;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 1540)
        return 3;
      if (score > 1410)
        return 2;
      return score > 1285 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
      Game.AddLoadingFile(2, "image/game/effect/9/duqidd.swf", "asset.game.nine.duqidd");
      Game.LoadResources(new int[1]
      {
        bossID
      });
      Game.LoadNpcGameOverResources(new int[1]
      {
        bossID
      });
      Game.SetMap(1209);
    }

    public override void OnStartGame()
    {
      m_boss = Game.CreateBoss(bossID, 770, 700, -1, 1,"");
      m_boss.SetRelateDemagemRect(-21, -87, 100, 79);
      m_boss.PlayMovie("born", 0, 6000);
      base.OnStartGame();
    }

    public override void OnNewTurnStarted()
    {
      base.OnNewTurnStarted();
    }

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
    }

    public override bool CanGameOver()
    {
      base.CanGameOver();
      return !m_boss.IsLiving;
    }

    public override int UpdateUIData()
    {
      if (m_boss == null)
        return 0;
      if (!m_boss.IsLiving)
        return 1;
      else
        return base.UpdateUIData();
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (!m_boss.IsLiving)
        Game.IsWin = true;
      else
        Game.IsWin = false;
    }
  }
}
