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
    public class AC30001 : AMissionControl
    {
        private SimpleBoss boss = null;
        private int npcID = 30001;
        private int bossID = 30002;
        LivingConfig config;
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();
        private int[] birthX = { 443, 515, 683, 723, 800, 606, 785, 842, 910, 1075 };
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
            int[] resources = { npcID, bossID };
            int[] gameOverResource = { npcID };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
            Game.SetMap(1244);			
        }
       
        public override void OnStartGame()
        {
            base.OnStartGame();
            createNPC();
            config = Game.BaseConfig();
            config.IsFly = true;
            config.IsWorldBoss = true;
        }
        private void createNPC()
        {
            
            foreach (int x in birthX)
            {
                int y = Game.Random.Next(478, 674);
                someNpc.Add(Game.CreateNpc(npcID, x, y, 0, 1, config));
            }
        }
        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            if (Game.GetLivedLivings().Count < 3)
            {
                createNPC();
            }           

        }        

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            
        }

        public override bool CanGameOver()
        {
            if (Game.TotalKillCount > 15 && boss == null)
            {
                Game.ClearAllChild(); 
                boss = Game.CreateBoss(bossID, 944, 481, -1, 0, "", config);
                boss.SetRelateDemagemRect(-200, -179, 272, 200);
                boss.Say(LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.Messions.DCSM2002.msg1"), 0, 200, 0);
                List<Player> players = Game.GetAllFightPlayers();
                Player RandomPlayer = Game.FindRandomPlayer();
                int minDelay = 0;

                if (RandomPlayer != null)
                    minDelay = RandomPlayer.Delay;

                foreach (Player player in players)
                {
                    if (player.Delay < minDelay)
                        minDelay = player.Delay;
                }
                boss.State = 10;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            return Game.TotalKillCount;
        }


        public override void OnGameOver()
        {
            base.OnGameOver();

            if (Game.TotalKillCount > 100)
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