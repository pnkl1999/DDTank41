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
    public class WCN14103 : AMissionControl
    {

        private SimpleNpc npc = null;
        private SimpleNpc goal = null;
        private SimpleBoss boss = null;
        private SimpleNpc arbiNpc = null;
        private int npcID = 14008;
        private int bossID = 14009;
        private int goalID = 14006;
        private int arbiID = 14007;
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
            int[] resources = { bossID, npcID, goalID, arbiID };
            int[] gameOverResource = resources;
            Game.LoadResources(resources);
            Game.AddLoadingFile(1, "bombs/110.swf", "tank.resource.bombs.Bomb110");
            Game.AddLoadingFile(2, "image/game/effect/0/294b.swf", "asset.game.zero.294b");
            Game.LoadNpcGameOverResources(gameOverResource);
            Game.SetMap(1407);			
        }
        private int needGoal = 6;
        private List<SimpleNpc> someNpc = new List<SimpleNpc>();
        public override void OnStartGame()
        {
            base.OnStartGame();            
            Game.AddAction(new CallFunctionAction(AddArbiNpc, 2000));            
        }
        private void AddArbiNpc()
        {
            LivingConfig config = Game.BaseConfig();
            config.IsHelper = true;
            config.HasTurn = false;
            arbiNpc = Game.CreateNpc(arbiID, 785, 261, 1, 1, config);
            Game.SendGameFocus(arbiNpc, 0, 100);
            arbiNpc.SetRelateDemagemRect(0, 0, 0, 0);
            LivingConfig config1 = Game.BaseConfig();
            config1.HasTurn = false;
            config1.IsGoal = true;
            goal = Game.CreateNpc(goalID, 1469, 860, 1, -1, config1);
            goal.SetRelateDemagemRect(-56, -110, 110, 110);
            Game.AddAction(new CallFunctionAction(AddBoss, 2000));
        }
        private void AddBoss()
        {
            LivingConfig config = Game.BaseConfig();
            config.IsShield = true;
            config.KeepLife = true;
            boss = Game.CreateBoss(bossID, 1223, 861, -1, 1, "", config);
            Game.SendGameFocus(boss, 0, 1000);
            boss.SetRelateDemagemRect(boss.NpcInfo.X, boss.NpcInfo.Y, boss.NpcInfo.Width, boss.NpcInfo.Height);
            boss.PlayMovie("standB", 2000, 0);
            Game.AddAction(new CallFunctionAction(ProtectGoal, 3000));
        }
        private void ProtectGoal()
        {
            goal.PlayMovie("beatA", 1000, 0);
            Game.AddAction(new CallFunctionAction(AddNpc, 1000));
            boss.AddDelay(2500);
        }
        private void AddNpc()
        {
            Game.SendGameFocus(arbiNpc, 0, 1000);
            LivingConfig config = Game.BaseConfig();
            config.IsFly = true;
            int x = Game.Random.Next(225, 1115);
            int y = Game.Random.Next(113, 354);
            for (int i = 0; i < 10; i++)
            {                
                someNpc.Add(Game.CreateNpc(npcID, x, y, 0, -1, config));
                x = Game.Random.Next(225, 1115);
                y = Game.Random.Next(113, 354);
            }
        }
        public override void OnStartMovie()
        {
            base.OnStartMovie();
            List<Player> players = Game.GetAllFightPlayers();
            foreach (Player p in players)
            {
                if (p != null && p.IsLiving)
                {
                    ItemTemplateInfo info = ItemMgr.FindItemTemplate(10471);
                    ItemInfo item = ItemInfo.CreateFromTemplate(info, 1, 101);
                    p.PlayerDetail.AddTemplate(item, eBageType.FightBag, 1, eGameView.OtherTypeGet);
                }
            }            
        }
        public override void OnNewTurnStarted()
        {
            base.OnNewTurnStarted();
            if (boss.Config.IsDown)
            {
                goal.PlayMovie("beatB", 1000, 0);
            }
            if (Game.IsGoal && boss.Blood == 1)
            {
                Game.AddAction(new CallFunctionAction(Goal, 1000));
            }
        }
        
        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();       
            if(Game.CanBeginNextProtect && boss.Blood == boss.NpcInfo.Blood)
            {
                Game.PveGameDelay = 0;
                ProtectGoal();
                Game.CanBeginNextProtect = false;
            }
        }
        public override void OnShooted()
        {
            base.OnShooted();
            if (Game.IsGoal && boss.Config.IsDown)
            {
                Game.TotalGoal++;        
            }
        }
        private void Goal()
        {
            Game.SendGameFocus(arbiNpc, 0, 2000);
            arbiNpc.Say(string.Format("Vào, tỉ số là {0}-0", Game.TotalGoal), 1, 100);
            Game.IsGoal = false;
        }
        public override bool CanGameOver()
        {
            if (needGoal <= Game.TotalGoal || Game.IsMissBall)
            {
                return true;
            }
            return false;
        }

        public override int UpdateUIData()
        {
            base.UpdateUIData();
            return Game.TotalGoal;
        }      

        public override void OnGameOver()
        {
            base.OnGameOver();

            if (needGoal <= Game.TotalGoal && !Game.IsMissBall)
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
        }
    }
}