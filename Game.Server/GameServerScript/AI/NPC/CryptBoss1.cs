using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class CryptBoss1 : ABrain
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
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatA", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }
        private void AttackA()
        {
            Player target = Game.FindNearestPlayer(0, 1500);
            if (target != null)
                Body.MoveTo(target.X + 250, target.Y, "walk", 1000, "", 10, NextAttackA);            
        }
        private void NextAttackA()
        {
            Body.CurrentDamagePlus = 0.5f;
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.PlayMovie("beatA", 3000, 0);
            Body.CallFuction(RangeAttackingA, 4500);
        }
        private void RangeAttackingA()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
            Body.CallFuction(Comback, 1500);
        }
        private void AttackC()
        {
            Body.PlayMovie("beatC", 700, 0);
            Body.CallFuction(RangeAttackingC, 3200);
        }
        private Player target;
        private PhysicalObj moive;
        private void RangeAttackingC()
        {
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.eleven.064", "out", 1, 1);
                Body.CallFuction(RangeAttacking, 1000);
                Body.CallFuction(GoOutC, 2000);
            }
        }
        private void GoOutC()
        {
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
        }
        private void NextAttackB()
        {
            Body.CurrentDamagePlus = 0.7f;
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.PlayMovie("beatB", 3000, 0);
            Body.CallFuction(RangeAttackingB, 4500);
        }
        private void RangeAttackingB()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
            Body.CallFuction(Comback, 1500);
        }
        private void AttackB()
        {
            Player target = Game.FindNearestPlayer(0, 1500);
            if (target != null)
                Body.MoveTo(target.X + 250, target.Y, "walk", 1000, "", 10, NextAttackB);          
        }       
        private void Comback()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.MoveTo(796, Body.Y, "walk", 1000, "", 10, ChangeDirection);
        }
        private void ChangeDirection()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
        }        
        private void RangeAttacking()
        {
            Body.CurrentDamagePlus = 0.9f;
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
    }
}
