using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class CryptBoss3 : ABrain
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
            else 
            {
                AttackB();
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
            Body.PlayMovie("beatA", 1000, 0);
            Body.CallFuction(RangeAttacking, 4500);
        }
       
        private void AttackB()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.CurrentDamagePlus = 0.8f;
                int mtX = Game.Random.Next(target.X - 10, target.X + 10);
                if (Body.ShootPoint(target.X, target.Y, 13, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatB", 1700, 0);
                }
            }  
        }              
        private void RangeAttacking()
        {
            Body.CurrentDamagePlus = 0.9f;
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
    }
}
