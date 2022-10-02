using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class Labyrinth40020 : AMissionControl
    {
        private SimpleBoss m_boss;

        private int m_kill = 0;

        private SimpleBoss boss;

        private SimpleBoss king;

        private PhysicalObj m_moive;

        private PhysicalObj m_moive1;

        private PhysicalObj m_moive2;

        private PhysicalObj m_moive3;

        private PhysicalObj m_front;

        private PhysicalObj[] m_leftWall = null;

        private PhysicalObj[] m_rightWall = null;

        private PhysicalObj m_wallRight = null;

        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        private PhysicalObj m_NPC;
        private PhysicalObj n_NPC;
        private PhysicalObj npc = null;
        private PhysicalObj npc2 = null;
        private int IsEixt = 0;
        private int IsEixt2 = 0;

        private int bossID = 40028;

        private int bossID2 = 5313;

        private int bossID3 = 5312;

        private int npcID = 40026;

        private int npcID2 = 40027;

        private int npcID3 = 5311;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1870)
            {
                return 3;
            }
            else if (score > 1825)
            {
                return 2;
            }
            else if (score > 1780)
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
            Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
            Game.AddLoadingFile(2, "image/game/effect/5/mubiao.swf", "asset.game.4.mubiao");
            Game.AddLoadingFile(2, "image/game/effect/5/xiaopao.swf", "asset.game.4.xiaopao");
            Game.AddLoadingFile(2, "image/game/effect/5/zao.swf", "asset.game.4.zao");
            Game.AddLoadingFile(2, "image/game/living/living144.swf", "game.living.Living144");
            Game.AddLoadingFile(2, "image/game/living/living152.swf", "game.living.Living152");
            Game.AddLoadingFile(2, "image/game/living/living154.swf", "game.living.Living154");
            Game.AddLoadingFile(2, "image/game/living/living147.swf", "game.living.Living147");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.gebulinzhihuiguanAsset");
            int[] resources = { bossID, bossID2, bossID3, npcID, npcID2, npcID3 };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(resources);
            Game.SetMap(1269);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            m_moive = (PhysicalObj)Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = (PhysicalObj)Game.Createlayer(1100, 395, "font", "game.asset.living.gebulinzhihuiguanAsset", "out", 1, 0);
            m_wallRight = Game.CreatePhysicalObj(1460, 580, "wallLeft", "asset.game.4.zao", "1", 1, 0);
            m_wallRight.SetRect(-75, -159, 100, 130);
            m_boss = Game.CreateBoss(bossID, 1480, 610, -1, 1, "");
            king = Game.CreateBoss(bossID2, 1617, 544, -1, 1, "");
            boss = Game.CreateBoss(bossID3, 1300, 650, -1, 1, "");
            boss.FallFrom(1300, 650, "", 0, 0, 1000);
            m_NPC = Game.Createlayer(1550, 650, "NPC", "game.living.Living154", "stand", 1, 0);
            n_NPC = Game.Createlayer(1367, 845, "NPC", "game.living.Living147", "stand", 1, 0);
            king.SetRelateDemagemRect(-34, -35, 50, 40);
            boss.SetRelateDemagemRect(-34, -35, 50, 40);
            m_boss.SetRelateDemagemRect(-34, -35, 50, 40);
            m_moive.PlayMovie("in", 3000, 0);
            m_front.PlayMovie("in", 3000, 0);
            m_moive.PlayMovie("out", 4000, 0);
            m_front.PlayMovie("out", 4000, 0);
            m_moive1 = Game.Createlayer(1617, 530, "moive", "asset.game.4.mubiao", "out", 1, 0);
            m_moive2 = Game.Createlayer(1300, 635, "moive", "asset.game.4.mubiao", "out", 1, 0);
            m_moive3 = Game.Createlayer(1480, 595, "moive", "asset.game.4.mubiao", "out", 1, 0);
        }

        public override void OnNewTurnStarted()
        {
            base.OnBeginNewTurn();
            if (Game.TurnIndex <= 1)
                return;
            if (m_moive != null)
            {
                Game.RemovePhysicalObj(m_moive, true);
                m_moive = null;
            }
            if (m_moive1 != null)
            {
                Game.RemovePhysicalObj(m_moive1, true);
                m_moive1 = null;
            }
            if (m_moive2 != null)
            {
                Game.RemovePhysicalObj(m_moive2, true);
                m_moive2 = null;
            }
            if (m_moive3 != null)
            {
                Game.RemovePhysicalObj(m_moive3, true);
                m_moive3 = null;
            }
            if (m_front != null)
            {
                Game.RemovePhysicalObj(m_front, true);
                m_front = null;
            }
            if (m_NPC != null)
            {
                Game.RemovePhysicalObj(m_NPC, true);
                m_NPC = null;
            }
            if (n_NPC != null)
            {
                Game.RemovePhysicalObj(n_NPC, true);
                n_NPC = null;
            }
        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            if (boss != null && !boss.IsLiving && king != null && !king.IsLiving)
            {
                m_leftWall = Game.FindPhysicalObjByName("wallLeft", false);
                m_rightWall = Game.FindPhysicalObjByName("wallRight", false);
                m_wallRight.SetRect(0, 0, 0, 0);
                foreach (PhysicalObj phy in m_leftWall)
                {
                    if (phy != null)
                    {
                        Game.RemovePhysicalObj(phy, true);
                    }
                }
                foreach (PhysicalObj phy in m_rightWall)
                {
                    if (phy != null)
                    {
                        Game.RemovePhysicalObj(phy, true);
                    }
                }
            }
        }
        
        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            if (m_boss != null && !m_boss.IsLiving)
            {
                if (Game.CanEnterGate)
                {                    
                    return true;
                }
                Game.CanShowBigBox = true;                               
            }
            return false;
        }
        
        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return 0;
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
            if (m_boss != null && !m_boss.IsLiving)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
            m_leftWall = Game.FindPhysicalObjByName("wallLeft");
            m_rightWall = Game.FindPhysicalObjByName("wallRight");

            for (int i = 0; i < m_leftWall.Length; i++)
                Game.RemovePhysicalObj(m_leftWall[i], true);

            for (int i = 0; i < m_rightWall.Length; i++)
                Game.RemovePhysicalObj(m_rightWall[i], true);
        }

        private void OnDie()
        {
            if (!king.IsLiving && IsEixt == 0)
            {
                npc = Game.Createlayer(king.X, king.Y, "", "game.living.Living144", "standB", 1, 0);
                IsEixt = 1;
            }
            if (boss.IsLiving || IsEixt2 != 0)
                return;
            npc2 = Game.Createlayer(boss.X, boss.Y, "", "game.living.Living152", "standB", 1, 0);
            IsEixt2 = 1;
        }

        public override void OnShooted()
        {
            if (!king.IsLiving)
                king.CallFuction(new LivingCallBack(OnDie), 8000);
            if (boss.IsLiving)
                return;
            boss.CallFuction(new LivingCallBack(OnDie), 8000);
        }
        
    }
}
