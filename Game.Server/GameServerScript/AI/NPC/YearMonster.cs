using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class YearMonster : ABrain
    {
        private int m_attackTurn = 0;

        public int currentCount = 0;

        public int Dander = 0;

        private PhysicalObj moive;

        private Player target;
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

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 1000)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(0, Game.Map.Info.ForegroundWidth + 1);

                return;
            }

            if (m_attackTurn == 0)
            {
                AttackA();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                AttackB();
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                AttackC();
                m_attackTurn++;
            }
            else
            {
                AttackD();
                target = Game.FindRandomPlayer();
                if (target != null)
                {
                    if (target.X < 400)
                    {
                        m_attackTurn = 0;
                    }
                    else
                    {
                        m_attackTurn = 1;
                    }
                }
               
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatE", 2000, 0);
            Body.RangeAttacking(fx, tx, "cry", 3000, null);
        }
        private void AttackA()
        {
            Body.CurrentDamagePlus = 1.5f;
            Body.PlayMovie("beatA", 1000, 0);
            Body.CallFuction(MovingPlayer, 3000);
        }
        private void MovingPlayer()
        {
            Player[] players = Game.GetAllPlayers();
            foreach (Player p in players)
            {
                p.StartSpeedMult(p.X - 200, p.Y);
            }
            Body.CallFuction(RangeAttacking, 1000);
        }
        private void AttackB()
        {
            Body.PlayMovie("beatB", 3000, 0);
            Body.CallFuction(new LivingCallBack(GoShootB), 4000);
        }

        private void AttackC()
        {
            Body.CurrentDamagePlus = 3.1f;
            Body.PlayMovie("beatC", 3000, 0);
            Body.CallFuction(RangeAttacking, 4500);
        }

        private void AttackD()
        {
            Body.PlayMovie("beatD", 3000, 0);
            Body.CallFuction(new LivingCallBack(GoShootD), 4000);
        }

        private void GoShootB()
        {
            Body.CurrentDamagePlus = 2.5f;
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.fifteen.305b", "out", 1, 1);                
                Body.CallFuction(GoOutB, 2000);
                Body.CallFuction(RangeAttacking, 1000);
            }
        }

        private void GoOutB()
        {
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
            
        }

        private void GoShootD()
        {
            Body.CurrentDamagePlus = 7.5f;
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.fifteen.305d", "out", 1, 1);
                Body.CallFuction(GoOutD, 2000);
                Body.CallFuction(RangeAttacking, 1000);
            }
        }

        private void GoOutD()
        {
            ((PVEGame)Game).SendGameFocus(Body, 0, 1000);
            Body.PlayMovie("born", 1000, 0);            
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
        }
        private void RangeAttacking()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
    }
}
