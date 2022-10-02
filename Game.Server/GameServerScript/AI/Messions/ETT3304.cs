using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using SqlDataProvider.Data;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class ETT3304 : AMissionControl
    {
        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private SimpleBoss m_king = null;

        private SimpleBoss m_secondKing = null;

        private int IsSay = 0;

        private int m_kill = 0;

        private int m_state = 3316;

        private int turn = 0;

        private int firstBossID = 3316;

        private int secondBossID = 3317;

        private int npcID = 3303;

        private int npcID3 = 3318;

        private int npcID2 = 3312;

        private int npcID1 = 3313;

        private int direction;



        private static string[] KillPlayerChat = new string[]{
            "Đùa với các ngươi chán quá!",

            "Trình chỉ tới vậy sao?",
            "Ta mới sử dụng 1 phần công lực thôi đó."
        };

        private static string[] AngryChat = new string[]{
            "Dám chọc giận ta à?",
            "Ta né, ta né!!!",
            "Đồ khốn nạn. Dám đánh ta!!"
        };

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1150)
            {
                return 3;
            }
            else if (score > 925)
            {
                return 2;
            }
            else if (score > 700)
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
            Game.AddLoadingFile(1, "bombs/55.swf", "tank.resource.bombs.Bomb55");
            Game.AddLoadingFile(1, "bombs/54.swf", "tank.resource.bombs.Bomb54");
            Game.AddLoadingFile(1, "bombs/53.swf", "tank.resource.bombs.Bomb53");
            Game.AddLoadingFile(2, "image/map/1126/object/1126object.swf", "game.assetmap.Flame");
            Game.AddLoadingFile(2, "image/map/1076/objects/1076mapasset.swf", "com.mapobject.asset.wordtip75");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.ClanLeaderAsset");

            int[] resources = { firstBossID, secondBossID, npcID, npcID2, npcID1, npcID3 };
            Game.LoadResources(resources);
            int[] gameOverResources = { firstBossID };
            Game.LoadNpcGameOverResources(gameOverResources);
            Game.SetMap(1126);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();

            m_kingMoive = Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(700, 355, "font", "game.asset.living.ClanLeaderAsset", "out", 1, 1);
            m_king = Game.CreateBoss(m_state, 800, 400, -1, 1, "");

            m_king.FallFrom(800, 400, "fall", 0, 2, 1200, null);
            m_king.SetRelateDemagemRect(-42, -187, 75, 187);
            //m_king.AddDelay(10);

            m_king.Say("Đến đây thôi, dám ngăn cản nghi lễ của ta, không muốn sống à!", 0, 2000);
            m_kingMoive.PlayMovie("in", 7000, 0);
            m_kingFront.PlayMovie("in", 7000, 0);
            m_kingMoive.PlayMovie("out", 13000, 0);
            m_kingFront.PlayMovie("out", 13400, 0);
            turn = Game.TurnIndex;

            Game.BossCardCount = 1;
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            if (Game.TurnIndex > turn + 1)
            {
                if (m_kingMoive != null)
                {
                    Game.RemovePhysicalObj(m_kingMoive, true);
                    m_kingMoive = null;
                }
                if (m_kingFront != null)
                {
                    Game.RemovePhysicalObj(m_kingFront, true);
                    m_kingFront = null;
                }
            }
            IsSay = 0;
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            if (m_king.IsLiving == false)
            {
                if (m_state == firstBossID)
                {
                    m_state = secondBossID;
                }
            }

            if (m_king.IsLiving == false && m_secondKing == null)
            {
                Game.ClearAllChild();
            }

            if (m_state == secondBossID && m_secondKing == null)
            {
                m_secondKing = Game.CreateBoss(m_state, m_king.X, m_king.Y, m_king.Direction, 1, "born");

                //npcHelper = Game.CreateNpc(npcID3, 468, 555, 1, 1, config);

                Game.RemoveLiving(m_king.Id);
                m_secondKing.SetRelateDemagemRect(m_secondKing.NpcInfo.X, m_secondKing.NpcInfo.Y, m_secondKing.NpcInfo.Width, m_secondKing.NpcInfo.Height);
                turn = Game.TurnIndex;
            }

            if (m_state == secondBossID && m_secondKing != null && m_secondKing.IsLiving == false)
            {
                direction = m_secondKing.Direction;
                m_kill++;
                return true;
            }

            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return m_kill;
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (m_state == secondBossID && m_secondKing.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }

        public override void DoOther()
        {
            base.DoOther();
            if (m_king == null)
                return;
            if (m_king.IsLiving)
            {
                int index = Game.Random.Next(0, KillPlayerChat.Length);
                m_king.Say(KillPlayerChat[index], 0, 0);
            }
        }

        public override void OnShooted()
        {
            if (IsSay == 0 && m_king.IsLiving)
            {
                int index = Game.Random.Next(0, AngryChat.Length);
                m_king.Say(AngryChat[index], 0, 1000);
                IsSay = 1;
            }
        }
    }
}
