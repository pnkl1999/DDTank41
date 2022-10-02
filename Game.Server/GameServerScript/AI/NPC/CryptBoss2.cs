using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class CryptBoss2 : ABrain
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
        private PhysicalObj moive;
        private Player target;
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 1000f;
            Body.PlayMovie("beatC", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }
        private void AttackA()
        {
            Body.PlayMovie("beatA", 3000, 0);
            Body.CallFuction(GoShootA, 4000);
        }
        private void GoShootA()
        {
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.eleven.055a", "out", 1, 1);
                Body.CallFuction(GoOutA, 2000);
                Body.CallFuction(RangeAttacking, 1000);
            }
        }

        private void GoOutA()
        {
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }

        }        
        private void AttackC()
        {
            Player target = Game.FindNearestPlayer(0, 1500);
            if (target != null)
                Body.MoveTo(target.X + 110, target.Y, "fly", 1000, "", 18, NextAttackC);
        }
        private void NextAttackC()
        {
            Body.CurrentDamagePlus = 0.7f;
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.PlayMovie("beatC", 2500, 0);
            Body.CallFuction(RangeAttackingC, 3700);
        }
        private void RangeAttackingC()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
            Body.CallFuction(Comback, 1500);
        }
        private void AttackB()
        {
            Body.PlayMovie("beatB", 3000, 0);
            Body.CallFuction(GoShootB, 4000);
        }
        private void GoShootB()
        {
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.eleven.055b", "out", 1, 1);
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
        private void Comback()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.MoveTo(796, 361, "fly", 1000, "", 18, ChangeDirection);
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
