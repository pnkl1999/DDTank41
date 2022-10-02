using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupBossFor14102 : ABrain
    {
        private int m_attackTurn = 0;
        private int ballID = 14101;
        public int currentCount = 0;
        public int Dander = 0;
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
            Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);

            if (Body.Direction == -1)
            {
                Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }
            else
            {
                Body.SetRect(-((SimpleBoss)Body).NpcInfo.X - ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }

        }
        private PhysicalObj moive;
        private Living target;
        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            FindBall();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();            
        }           
        private void FindBall()
        {           
            List<Living> List = Game.FindHoldBall();
            if (List.Count > 0)
            {
                target = List[0];
                if (moive != null && (target.X < moive.X + 100 && target.X > moive.X - 100))
                {
                    AttackA();
                }
                else
                {
                    GoOut();
                    int posX = target.X;
                    if (posX < Body.X)
                    {
                        posX += 160;
                    }
                    else
                    {
                        posX -= 160;
                    }
                    Body.MoveTo(posX, target.Y, "walk", 500, "", 7, new LivingCallBack(TargetBall));
                }
            }
        }
        private void TargetBall()
        {
            if (target != null)
            {
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.nine.biaoji", "out", 1, 1);
            }
            Body.CallFuction(AttackC, 100);
        }
        private void AttackC()
        {
            Body.PlayMovie("beatC", 1000, 0);
            List<Player> list = Game.GetAllFightPlayers();
            foreach(Player p in list)
            {
                if (p != null && (p.X < moive.X + 100 && p.X > moive.X - 100))
                {
                    int m_count = 0;//p.Energy - 30;
                    p.AddEffect(new ReduceStrengthEffect(2, m_count), 0);
                    ((Player)p).LimitEnergy = true;
                    ((Player)p).TotalCureEnergy = 30;
                    p.AddRemoveEnergy(30);
                }
            }
            if (m_attackTurn == 1)
            {
                Body.CallFuction(AttackB, 1000);
            }
            else
            {
                m_attackTurn++;
            }
        }
        private void AttackB()
        {
            Body.CurrentDamagePlus = 2.0f;
            Body.PlayMovie("beatB", 1000, 0);
            Body.CallFuction(MovingPlayer, 1000);
        }
        private void MovingPlayer()
        {
            Player[] players = Game.GetAllPlayers();
            foreach (Player p in players)
            {
                int posX = p.X;
                if (posX < Game.Map.Info.ForegroundWidth / 2)
                {
                    posX += 100;
                }
                else
                {
                    posX -= 100;
                }
                p.StartSpeedMult(posX, p.Y);
            }
            Body.CallFuction(RangeAttacking, 1000);
        }
        private void RangeAttacking()
        {            
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
            m_attackTurn = 0;
        }
        private void AttackA()
        {
            Body.PlayMovie("beatA", 1500, 0);
            Body.CallFuction(shotBall, 1500);
        }
        private void shotBall()
        {
            if (target != null)
            {
                int posX = target.X + 200 * Body.Direction;
                if (posX > Game.Map.Info.ForegroundWidth)
                {
                    posX = Game.Map.Info.ForegroundWidth;
                }
                if (posX < 1)
                {
                    posX = 1;
                }
                if (target is Player)
                {
                    LivingConfig config = ((PVEGame)Game).BaseConfig();
                    config.IsHelper = true;
                    config.HasTurn = false;
                    SimpleNpc ball = ((PVEGame)Game).CreateNpc(ballID, target.X, target.Y, 1, -1, config);                  
                    ball.MoveTo(posX, ball.Y, "walk", 0, 3);
                    Game.TakePassBall(-1);
                }
                else if (target is SimpleNpc)
                {                   
                    target.MoveTo(posX, target.Y, "walk", 0, 3);
                }
                ((PVEGame)Game).IsMissBall = true;
            }
        }
        private void GoOut()
        {
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
        }
    }
	
}
