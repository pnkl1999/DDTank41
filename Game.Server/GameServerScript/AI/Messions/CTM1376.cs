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
    public class CTM1376 : AMissionControl
    {
        private PhysicalObj m_kingMoive;

        private PhysicalObj m_kingFront;

        private SimpleBoss m_king = null;

        private SimpleBoss m_secondKing = null;

        private PhysicalObj[] m_leftWall = null;

        private PhysicalObj[] m_rightWall = null;

        private int m_kill = 0;

        private int m_state = 1305;

        private int turn = 0;

        private int firstBossID = 1305;

        private int secondBossID = 1306;

        private int npcID = 1310;

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
            //Game.AddLoadingFile(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
            Game.AddLoadingFile(2, "image/bomb/blastout/blastout61.swf", "bullet61");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet61.swf", "bullet61");          
            Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_left");
            Game.AddLoadingFile(2, "image/map/1076/objects/1076MapAsset.swf", "com.mapobject.asset.WaveAsset_01_right");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");

            int[] resources = { firstBossID, secondBossID, npcID };
            Game.LoadResources(resources);
            int[] gameOverResources = { firstBossID };
            Game.LoadNpcGameOverResources(gameOverResources);

            Game.SetMap(1076);
            //Game.IsBossWar = LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.CHM1376.msg1");
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            Game.IsBossWar = "1376";
            m_kingMoive = Game.Createlayer(0, 0, "kingmoive", "game.asset.living.BossBgAsset", "out", 1, 1);
            m_kingFront = Game.Createlayer(720, 495, "font", "game.asset.living.boguoKingAsset", "out", 1, 1);
            m_king = Game.CreateBoss(m_state, 890, 590, -1, 0, "");

            m_king.FallFrom(890, 590, "fall", 0, 2, 1000);
            m_king.SetRelateDemagemRect(-21, -87, 72, 59);
            m_king.AddDelay(10);

            m_king.Say(LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.CHM1376.msg2"), 0, 3000);
            m_kingMoive.PlayMovie("in", 9000, 0);
            m_kingFront.PlayMovie("in", 9000, 0);
            m_kingMoive.PlayMovie("out", 13000, 0);
            m_kingFront.PlayMovie("out", 13400, 0);
            turn = Game.TurnIndex;

            //设置本关卡为Boss关卡，关卡胜利后，玩家可以翻一张牌
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
        }

        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            base.CanGameOver();
            if (m_king.IsLiving == false)
            {
                if (m_state == firstBossID)
                {
                    m_state++;
                }
            }

            if (m_state == secondBossID && m_secondKing == null)
            {               
                m_secondKing = Game.CreateBoss(m_state, m_king.X, m_king.Y, m_king.Direction, 2, "");
                Game.RemoveLiving(m_king.Id);
                if (m_secondKing.Direction == 1)
                {
                    m_secondKing.SetRelateDemagemRect(-21, -79, 72, 51); //SetRect(-40, -112, 115, 96);

                }
                m_secondKing.SetRelateDemagemRect(-21, -79, 72, 51); //SetRelateDemagemRect(-21, -87, 72, 59);
                m_secondKing.Say(LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.CHM1376.msg3"), 0, 3000);               
                List<Player> players = Game.GetAllFightPlayers();
                Player RandomPlayer = Game.FindRandomPlayer();
                int minDelay = 0;

                if (RandomPlayer != null)
                {
                    minDelay = RandomPlayer.Delay;
                }

                foreach (Player player in players)
                {
                    if (player.Delay < minDelay)
                    {
                        minDelay = player.Delay;
                    }
                }

                m_secondKing.AddDelay(minDelay - 2000);
                turn = Game.TurnIndex;
            }

            if (m_secondKing != null && m_secondKing.IsLiving == false)
            {
                Game.RemoveLiving(m_secondKing.Id);
                PhysicalObj objKing = Game.CreatePhysicalObj(m_secondKing.X, m_secondKing.Y, "king", "game.living.Living005", "specialDie", 1, 0);
                if (objKing.CurrentAction == "specialDie")
                {
                    m_kill++;
                    return true;
                }
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

            //List<LoadingFileInfo> loadingFileInfos = new List<LoadingFileInfo>();
            //loadingFileInfos.Add(new LoadingFileInfo(2, "image/map/show7.jpg", ""));
            //Game.SendLoadResource(loadingFileInfos);

            m_leftWall = Game.FindPhysicalObjByName("wallLeft");
            m_rightWall = Game.FindPhysicalObjByName("wallRight");

            for (int i = 0; i < m_leftWall.Length; i++)
                Game.RemovePhysicalObj(m_leftWall[i], true);

            for (int i = 0; i < m_rightWall.Length; i++)
                Game.RemovePhysicalObj(m_rightWall[i], true);
        }
    }
}
