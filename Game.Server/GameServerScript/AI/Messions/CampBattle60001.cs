using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;
using Game.Server.Rooms;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class CampBattle60001 : AMissionControl
    {
        private List<SimpleNpc> SomeNpc = new List<SimpleNpc>();

        private int npcId = 60001;

        private int totalNpcSpawn = 0;

        private int deadCount = 0;

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
            //Game.AddLoadingFile(2, "image/game/effect/8/xiezi.swf", "asset.game.eight.xiezi");
            int[] resources = { npcId };
            int[] gameOverResource = { npcId };
            Game.LoadResources(resources);
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(11018);			
        }
        
        public override void OnStartGame()
        {
            base.OnStartGame();
            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }
            for (int i = 0; i < 4; i++)
            {
                totalNpcSpawn++;

                if (i < 1)
                {
                    SomeNpc.Add(Game.CreateNpc(npcId, 888, 568, 0, -1));
                }
                else if (i < 3)
                {
                    SomeNpc.Add(Game.CreateNpc(npcId, 995, 518, 0, -1));
                }
                else
                {
                    SomeNpc.Add(Game.CreateNpc(npcId, 1087, 572, 0, -1));
                }
            }

            totalNpcSpawn++;
            SomeNpc.Add(Game.CreateNpc(npcId, 1221, 587, 0, -1));
        }

        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();

            if (Game.GetLivedLivings().Count == 0)
            {
                Game.PveGameDelay = 0;
            }

            if (Game.TurnIndex > 1 && (Game.CurrentPlayer == null || Game.CurrentPlayer.Delay > Game.PveGameDelay))
            {
                for (int i = 0; i < 4; i++)
                {
                    if (totalNpcSpawn < 20)
                    {
                        totalNpcSpawn++;

                        if (i < 1)
                        {
                            SomeNpc.Add(Game.CreateNpc(npcId, 888, 568, 0, -1));
                        }
                        else if (i < 3)
                        {
                            SomeNpc.Add(Game.CreateNpc(npcId, 995, 518, 0, -1));
                        }
                        else
                        {
                            SomeNpc.Add(Game.CreateNpc(npcId, 1087, 572, 0, -1));
                        }
                    }
                }

                if (totalNpcSpawn < 20)
                {
                    totalNpcSpawn++;
                    SomeNpc.Add(Game.CreateNpc(npcId, 1221, 587, 0, -1));
                }

            }

        }     

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();           
        }

        public override bool CanGameOver()
        {
            base.CanGameOver();
            bool result = true;
            
            deadCount = 0;

            foreach (SimpleNpc redNpc in SomeNpc)
            {
                if (redNpc.IsLiving)
                {
                    result = false;
                }
                else
                {
                    deadCount++;
                }
            }

            if (result && deadCount == 20)
            {
                Game.IsWin = true;
                return true;
            }


            if (Game.TurnIndex > Game.MissionInfo.TotalTurn - 1)
            {
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalKillCount;
        }      

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (Game.GetLivedLivings().Count == 0)
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
                p.PlayerDetail.UpdateCampBattleResult(Game.GameType, Game.BossCampId, players.Count, Game.IsWin);
            }
        }
    }
}