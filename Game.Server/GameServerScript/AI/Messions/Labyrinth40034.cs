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
    public class Labyrinth40034 : AMissionControl
    {
        private SimpleBoss boss = null;

        private int kill = 0;

        private int npcID = 40054;

        private int bossID = 40055;

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
            int[] resources = { bossID, npcID };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/bomb/blastOut/blastOut51.swf", "bullet51");
            Game.AddLoadingFile(2, "image/bomb/bullet/bullet51.swf", "bullet51");
            Game.SetMap(11008);
        }

        public override void OnStartGame()
        {
            base.OnStartGame();
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            boss = Game.CreateBoss(bossID, 972, 444, -1, 1, "", config); 
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);    
        }

        public override void OnNewTurnStarted()
        {
        }
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();            
        }
        
        public override bool CanGameOver()
        {
            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            if (boss != null && !boss.IsLiving)
            {
                if (Game.CanEnterGate)
                {
                    return true;
                }
                kill++;
                Game.CanShowBigBox = true;                               
            }
            return false;
        }
        
        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }

        public override void OnGameOverMovie()
        {
            base.OnGameOverMovie();
            if (boss != null && boss.IsLiving == false)
            {
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
        }
      
        public override void OnGameOver()
        {
            base.OnGameOver();
            
        }
        
    }
}
