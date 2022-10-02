using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class TVS12004 : AMissionControl
  {
    private int InSet = 0;
    private int bossID = 12014;
    private int bossID2 = 12015;
    private int bossID3 = 12016;
    private int npcID = 12017;
    private int npcID2 = 12018;
    private int npcID3 = 12020;
    private SimpleBoss m_boss;
    private SimpleBoss boss;
    private SimpleBoss king;
    private SimpleNpc npc;
    private PhysicalObj m_moive;
    private PhysicalObj m_front;

    public override int CalculateScoreGrade(int score)
    {
      base.CalculateScoreGrade(score);
      if (score > 900)
        return 3;
      if (score > 825)
        return 2;
      return score > 725 ? 1 : 0;
    }

    public override void OnPrepareNewSession()
    {
      base.OnPrepareNewSession();
      Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
      Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
      Game.AddLoadingFile(2, "image/game/effect/9/daodan.swf", "asset.game.nine.daodan");
      Game.AddLoadingFile(2, "image/game/effect/9/diancipao.swf", "asset.game.nine.diancipao");
      Game.AddLoadingFile(2, "image/game/effect/9/fengyin.swf", "asset.game.nine.fengyin");
      Game.AddLoadingFile(2, "image/game/effect/9/siwang.swf", "asset.game.nine.siwang");
      Game.AddLoadingFile(2, "image/game/effect/9/shexian.swf", "asset.game.nine.shexian");
      Game.AddLoadingFile(2, "image/game/effect/9/biaoji.swf", "asset.game.nine.biaoji");
      int[] npcIds = new int[7]
      {
        bossID,
        bossID2,
        bossID3,
        npcID,
        npcID2,
        npcID3,
        12319
      };
      Game.LoadResources(npcIds);
      Game.LoadNpcGameOverResources(npcIds);
      Game.SetMap(1210);
    }

    public override void OnStartGame()
    {
      base.OnStartGame();
      boss = Game.CreateBoss(bossID, 1000, 400, -1, 1,"");
      boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
      boss.PlayMovie("", 4000, 4000);
    }

    public void CreateBoss()
    {
      Game.ClearAllChild();
      InSet = 1;
      m_boss = Game.CreateBoss(bossID2, boss.X, boss.Y, boss.Direction, 1, "");
      m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
      m_boss.PlayMovie("", 6000, 0);
        /*
      npc = Game.CreateNpc(12319, 100, 600, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 200, 500, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 300, 400, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 500, 600, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 600, 500, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 700, 400, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1300, 400, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1400, 500, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1500, 600, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1600, 400, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1700, 500, -1, 12, "NoBlood");
      npc = Game.CreateNpc(12319, 1800, 600, -1, 12, "NoBlood");*/
    }

    public void CreateKing()
    {
      Game.ClearAllChild();
      InSet = 2;
      king = Game.CreateBoss(bossID3, m_boss.X, m_boss.Y, m_boss.Direction, 1, "");
      m_moive = (PhysicalObj) Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
      m_front = (PhysicalObj) Game.Createlayer(king.X - 475, king.Y - 100, "font", "game.asset.living.fengkuangAsset", "out", 1, 0);
      king.SetRelateDemagemRect(king.NpcInfo.X, king.NpcInfo.Y, king.NpcInfo.Width, king.NpcInfo.Height);
      m_moive.PlayMovie("in", 4000, 0);
      m_front.PlayMovie("in", 4000, 0);
      m_moive.PlayMovie("out", 7000, 0);
      king.PlayMovie("", 8000, 0);
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
      if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
        return true;
      if (boss != null && !boss.IsLiving && InSet == 0)
        CreateBoss();
      if (m_boss != null && !m_boss.IsLiving && InSet == 1)
        CreateKing();
      return king != null && !king.IsLiving && InSet == 2;
    }

    public override int UpdateUIData()
    {
      return base.UpdateUIData();
    }

    public override void OnGameOver()
    {
      base.OnGameOver();
      if (!king.IsLiving)
        Game.IsWin = true;
      else
        Game.IsWin = false;
    }
  }
}
