using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class CryptBoss5 : ABrain
    {
        private int m_attackTurn = 0;
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

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > Body.X - 150 && player.X < Body.X + 150)
                    result = true;
            }

            if (result)
            {
                KillAttack(Body.X - 150, Body.X + 150);
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
            else
            {
                AttackC();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 2000.5f;
            Body.PlayMovie("beatB", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 3000, null);
        }
        private void AttackA()
        {
            Body.CurrentDamagePlus = 2.5f;
            Body.PlayMovie("beatA", 500, 0);
            Body.CallFuction(RangeAttackingA, 2500);
        }       
        private void RangeAttackingA()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }       
        private void AttackC()
        {
            Body.PlayMovie("beatC", 500, 0);
            Body.CallFuction(MovingPlayer, 3500);
        }
        private void MovingPlayer()
        {
            Player[] players = Game.GetAllPlayers();
            foreach (Player p in players)
            {
                if (p.X > 200)
                {
                    p.StartSpeedMult(p.X - 200, p.Y);
                }
            }
            Body.CallFuction(RangeAttacking, 1000);
        }
        private void RangeAttacking()
        {
            Body.CurrentDamagePlus = 1.9f;
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
        private void AttackB()
        {
            Body.PlayMovie("beatB", 700, 0);
            Body.CallFuction(RangeAttackingB, 3000);            
        }
        private PhysicalObj moive;
        private Player target;
        private void RangeAttackingB()
        {
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.eleven.057", "out", 1, 1);
                Body.CallFuction(RangeAttacking, 1000);
                Body.CallFuction(GoOutB, 2000);
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
    }
}
