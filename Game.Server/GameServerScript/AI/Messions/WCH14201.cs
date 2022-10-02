using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;
using Bussiness.Managers;
using SqlDataProvider.Data;

namespace Game.Server.GameServerScript.AI.Messions
{
    public class WCH14201 : AMissionControl
    {
        private SimpleBoss boss = null;
        private SimpleNpc ball = null;
        private int bossID = 14102;
        private int ballID = 14101;
        private int holdTurn = 30;

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
            int[] resources = { bossID, ballID };
            int[] gameOverResource = resources;
            Game.LoadResources(resources);
            Game.AddLoadingFile(1, "bombs/110.swf", "tank.resource.bombs.Bomb110");
            Game.AddLoadingFile(1, "bombs/117.swf", "tank.resource.bombs.Bomb117");
            Game.AddLoadingFile(2, "image/game/effect/9/biaoji.swf", "asset.game.nine.biaoji");
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1405);            
        }
        public override void OnStartMovie()
        {
            base.OnStartMovie();
            int[] props = new int[] { 10467, 10468, 10469 };
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player p in players)
            {
                if (p != null && p.IsLiving)
                {
                    for (int i = 0; i < props.Length; i++)
                    {
                        ItemTemplateInfo info = ItemMgr.FindItemTemplate(props[i]);
                        ItemInfo item = ItemInfo.CreateFromTemplate(info, 1, 101);
                        p.PlayerDetail.AddTemplate(item, eBageType.FightBag, 1, eGameView.OtherTypeGet);
                    }
                }
            }
            if (players.Count > 2)
            {
                holdTurn = 40;
            }
            Game.PassBallActive = true;
        }
        public override void OnStartGame()
        {
            base.OnStartGame();
            boss = Game.CreateBoss(bossID, 1277, 812, -1, 1, "");
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            LivingConfig config = Game.BaseConfig();
            config.IsHelper = true;
            config.HasTurn = false;
            ball = Game.CreateNpc(ballID, 638, 926, 1, -1, config);
            boss.AddDelay(2500);
        }
        public override void OnShooted()
        {
            base.OnShooted();
            Player player = Game.CurrentPlayer;
            if (player != null && player.PassBallFail)
            {
                LivingConfig config = Game.BaseConfig();
                config.IsHelper = true;
                config.HasTurn = false;                
                if (player != null && !player.LastPoint.IsEmpty)
                {
                    ball = Game.CreateNpc(ballID, player.LastPoint.X, player.LastPoint.Y, 1, -1, config);
                }
                int posX = ball.X + 150 * player.Direction;
                if (posX > Game.Map.Info.ForegroundWidth)
                {
                    posX = Game.Map.Info.ForegroundWidth;
                }
                if (posX < 1)
                {
                    posX = 1;
                }
                ball.MoveTo(posX, ball.Y, "walk", 0, 3);
            }
           
        }
        public override void OnMoving()
        {
            base.OnMoving();
            Player player = Game.CurrentPlayer;
            if (player != null && !player.IsHoldBall)
            {
                if (ball != null && (player.X < ball.X + 25 && player.X > ball.X - 25))
                {
                    Game.TakePassBall(player.Id);
                    Game.RemoveNPC(ball.Id);
                }
            }
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
            if (holdTurn <= Game.TurnIndex || Game.IsMissBall)
            {
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return holdTurn;
        }      

        public override void OnGameOver()
        {
            base.OnGameOver();
            if (holdTurn <= Game.TurnIndex && !Game.IsMissBall)
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
                if (p != null)
                {
                    p.PlayerDetail.ClearFightBag();
                }
            }
            Game.PassBallActive = false;
        }
    }
}