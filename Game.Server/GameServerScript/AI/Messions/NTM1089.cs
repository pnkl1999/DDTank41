using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using SqlDataProvider.Data;
using Bussiness.Managers;
using Game.Server.Statics;
using Game.Logic;
using Game.Base.Packets;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class NTM1089 : AMissionControl
    {       
        private int mapId = 1129;//640,500

        private int dieCount = 0;

        private int[] birthX = { 52, 115, 1155, 1106};

        private int[] birthY = { 388, 392, 399, 387};
        private int npcID = 25001;
        //private int npcID = 23001;
        private int bossID = 25002;
        
        private SimpleBoss m_boss;

        private PhysicalObj m_moive;

        private PhysicalObj m_front;
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 900)
            {
                return 3;
            }
            if (score > 825)
            {
                return 2;
            }
            if (score > 725)
            {
                return 1;
            }
            return 0;
        }

        public override void OnPrepareNewSession()
        {
            base.OnPrepareNewSession();
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.shikongAsset");
            int[] npcIdList = { npcID, bossID };
            Game.LoadResources(npcIdList);
            Game.LoadNpcGameOverResources(npcIdList);
            Game.SetMap(mapId);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            //left born
            //int index = Game.Random.Next(0, birthY.Length);
            int Y= birthX[0];
            someNpc.Add(Game.CreateNpc(npcID, 52, Y, 1, -1));
            //index = Game.Random.Next(0, birthY.Length);
            //Y = birthX[index];
            someNpc.Add(Game.CreateNpc(npcID, 100, Y, 1, -1));            

            //Right born
            // index = Game.Random.Next(0, birthY.Length);
            //Y = birthX[index];
            someNpc.Add(Game.CreateNpc(npcID, 1120, Y, 1, 1));
            //index = Game.Random.Next(0, birthY.Length);
            //Y = birthX[index];
            someNpc.Add(Game.CreateNpc(npcID, 1155, Y, 1, 1));
            
        }
        public void CreateBoss()
        {        
            m_moive = Game.Createlayer(0, 0, "moive", "game.asset.living.BossBgAsset", "out", 1, 0);
            m_front = Game.Createlayer(200, 200, "font", "game.asset.living.shikongAsset", "out", 1, 0);
            m_boss = Game.CreateBoss(bossID, 160, 330, 1, 1, "");
            m_boss.SetRelateDemagemRect(m_boss.NpcInfo.X, m_boss.NpcInfo.Y, m_boss.NpcInfo.Width, m_boss.NpcInfo.Height);
            m_moive.PlayMovie("in", 6000, 0);
            m_front.PlayMovie("in", 6000, 0);
            m_moive.PlayMovie("out", 9000, 0);
            //m_front.PlayMovie("out", 6000, 0);
        }
        //public override void OnPrepareNewGame()
        //{
        //    base.OnPrepareNewGame();
        //}

        public override void OnNewTurnStarted()
        {
            if (Game.TurnIndex > 1 && m_boss == null)
            {
                if (Game.GetLivedLivings().Count < 4)
                {
                    for (int i = 0; i < 4 - Game.GetLivedLivings().Count; i++)
                    {
                        if (someNpc.Count == 8)
                        {
                            break;
                        }
                        else
                        {
                            int index = Game.Random.Next(0, birthX.Length);
                            int NpcX = birthX[index];
                            //int NpcY = birthY[index];
                            int dis = 1;
                            if (NpcX < 200)
                            {
                                dis = -1;
                            }
                            someNpc.Add(Game.CreateNpc(npcID, NpcX, birthY[0], 1, dis));
                            
                        }
                    }
                }
            }
        }
        
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
        }

        public override bool CanGameOver()
        {
            bool result = true;

            base.CanGameOver();

            dieCount = 0;

            foreach (SimpleNpc npc in someNpc)
            {
                if (npc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    dieCount++;
                }
            }

            if (result && dieCount == 8 && m_boss == null)
            {
                CreateBoss();
            }

            if (m_boss != null && !m_boss.IsLiving)
            {                
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            if (m_boss == null)
                return 0;

            if (!m_boss.IsLiving)
            {
                return 1;
            }
            return base.UpdateUIData();
        }

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (m_boss != null)
            {

                if (!m_boss.IsLiving)
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
}
