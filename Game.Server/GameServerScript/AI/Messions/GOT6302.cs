using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Server.GameServerScript.AI.Messions
{
  public class GOT6302 : AMissionControl
  {
        private SimpleBoss m_boss;

        private SimpleBoss m_hero;

        private PhysicalObj m_wall;

        private int bossID = 6323;

        private int blueID = 6322;

        private int redID = 6321;

        private int homeID = 6324;

        private int heroID = 6314;

        private int m_maxPoint = 11;

        private SimpleNpc m_tempNpc;

        private int m_finishRedCount = 0;

        private int m_finishBlueCount = 0;

        private List<Point> m_point = new List<Point>() { new Point(620, 1080) };

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 900)
            {
                return 3;
            }
            else if (score > 825)
            {
                return 2;
            }
            else if (score > 725)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            Game.AddLoadingFile(2, "image/game/effect/6/danti.swf", "asset.game.six.danti"); // sam xet mau xanh
            Game.AddLoadingFile(2, "image/game/effect/6/qunti.swf", "asset.game.six.qunti"); // thu loi xanh
            Game.AddLoadingFile(2, "image/game/effect/6/zhaozi.swf", "asset.game.six.zhaozi"); // tron tron nhay nhay
            Game.AddLoadingFile(2, "image/game/effect/6/danjia.swf", "asset.game.six.danjia"); // effect buff mau
            Game.AddLoadingFile(2, "image/game/effect/6/qunjia.swf", "asset.game.six.qunjia"); // effect hinh tru buff

            //Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
            //Game.AddLoadingFile(2, "image/game/living/Living190.swf", "game.living.Living190");

            int[] resources = { bossID, redID, blueID, homeID, heroID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1166);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_boss = Game.CreateBoss(bossID, 1910, 1080, -1, 1, "");
            m_boss.Delay = 1;

            m_hero = Game.CreateBoss(heroID, 460, 1080, -1, 1, "");
            m_hero.Config.CanTakeDamage = false;
            m_hero.Config.HasTurn = false;

            m_hero.MoveTo(450, 1080, "walk", 500, 3);
            m_hero.PlayMovie("go", 1500, 0);
            m_hero.Say("Tấn công đội xanh, bảo vệ đội đỏ.", 0, 2000);

            m_wall = Game.CreateLayerBoss(1100, 1080, "font", "game.living.Living190", "stand", 1, 0);
            //m_front = Game.Createlayerboss(1245, 520, "font", "game.living.Living189", "stand", 1, 0);
            //m_boss.FallFrom(m_boss.X, m_boss.Y, "", 0, 0, 1000);
            //m_boss.SetRelateDemagemRect(-34, -35, 100, 70);
            m_boss.CallFuction(CreateNpcBlue, 2500);
            Game.PveGameDelay = 0;
        }

        private void CreateNpcBlue()
        {
            m_maxPoint = 10;

            m_tempNpc = Game.CreateNpc(blueID, 300, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.MaxStepMove = 6;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(blueID, 250, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.MaxStepMove = 6;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(blueID, 200, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.MaxStepMove = 6;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(blueID, 150, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.MaxStepMove = 6;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(blueID, 100, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.MaxStepMove = 6;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_maxPoint = 9;

            m_tempNpc = Game.CreateNpc(redID, 50, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.IsHelper = true;
            m_tempNpc.Config.MaxStepMove = 4;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(redID, 0, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.IsHelper = true;
            m_tempNpc.Config.MaxStepMove = 4;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(redID, -50, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.IsHelper = true;
            m_tempNpc.Config.MaxStepMove = 4;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(redID, -100, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.IsHelper = true;
            m_tempNpc.Config.MaxStepMove = 4;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;

            m_tempNpc = Game.CreateNpc(redID, -150, 1080, 1, 1);
            m_tempNpc.Config.IsFly = true;
            m_tempNpc.Config.IsHelper = true;
            m_tempNpc.Config.MaxStepMove = 4;
            m_tempNpc.Config.FirstStepMove = m_maxPoint;
            m_tempNpc.MoveTo(m_point[0].X, m_point[0].Y, "walk", 0, 8);
            m_maxPoint -= 2;
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();

            SimpleNpc[] allNpcs = Game.FindAllNpcLiving();
            m_finishRedCount = 0;
            m_finishBlueCount = 0;
            foreach (SimpleNpc npc in allNpcs)
            {
                if (npc.Config.CompleteStep)
                {
                    if (npc.NpcInfo.ID == redID)
                        m_finishRedCount++;
                    else
                        m_finishBlueCount++;
                }
            }

            if (m_finishRedCount >= 5 || m_finishBlueCount >= 5)
                return true;

            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (m_finishRedCount >= 5)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
    }
}
