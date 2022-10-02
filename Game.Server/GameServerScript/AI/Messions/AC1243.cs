using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class AC1243 : AMissionControl
    {
        private SimpleBoss boss = null;
        private int bossID = 1243;

        private int kill = 0;

        public override int CalculateScoreGrade(int score)
        {
            base.CalculateScoreGrade(score);
            if (score > 1750)
            {
                return 3;
            }
            else if (score > 1675)
            {
                return 2;
            }
            else if (score > 1600)
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
            int[] resources = { bossID };
            int[] gameOverResource = { bossID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(1, "bombs/56.swf", "tank.resource.bombs.Bomb56");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            Game.AddLoadingFile(2, "image/game/effect/5/guang.swf", "asset.game.4.guang");
            Game.AddLoadingFile(2, "image/game/effect/5/tang.swf", "asset.game.4.tang");
            Game.AddLoadingFile(2, "image/game/effect/5/ruodian.swf", "asset.game.4.ruodian");
            Game.AddLoadingFile(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.xieyanjulongAsset");
            Game.SetMap(1243);			
        }
        
        public override void OnStartGame()
        {
            base.OnStartGame();
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            config.IsWorldBoss = true;
            boss = Game.CreateBoss(bossID, 1170, 370, -1, 0, "", config);            
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);  
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
            if (boss != null && boss.IsLiving == false)
            {
                kill++;
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return kill;
        }      

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (boss != null && boss.IsLiving == false)
            {                
                Game.IsWin = true;
            }
            else
            {
                Game.IsWin = false;
            }
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player p in players)
            {               
                p.PlayerDetail.UpdatePveResult("worldboss", p.TotalDameLiving, Game.IsWin);
            }
        }
    }
}