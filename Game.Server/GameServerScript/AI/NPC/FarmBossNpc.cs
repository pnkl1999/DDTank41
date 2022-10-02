using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FarmBossNpc : ABrain
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
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 919)
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
                KillAttack(765, Game.Map.Info.ForegroundWidth + 1000);
                return;
            }

            if (m_attackTurn == 0)
            {
               PersonalAttack();
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
            Body.PlayMovie("beatB", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }
        private void AttackC()
        {
            Body.PlayMovie("beatC", 1000, 0);
            Body.CallFuction(Health, 2500);            
        }
        private void Health()
        {
            switch ((Body as SimpleBoss).NpcInfo.ID)
            {
                case 50101:
                    Body.AddBlood(5000);
                    break;
                case 50102:
                    Body.AddBlood(15000);
                    break;
                case 50103:
                    Body.AddBlood(20000);
                    break;
                case 50104:
                    Body.AddBlood(25000);
                    break;
                case 50105:
                    Body.AddBlood(30000);
                    break;
            }
        }   
        private void AttackB()
        {
            Body.PlayMovie("beatB", 1000, 0);
            Body.CallFuction(GoShootB, 2000);
        }
        private PhysicalObj moive;
        private Player target;
        private void GoShootB()
        {
            target = Game.FindRandomPlayer();
            if (target != null)
            {
                ((PVEGame)Game).SendGameFocus(target, 0, 1000);
                moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "moive", "asset.game.fifteen.380b", "out", 1, 1);
                Body.CallFuction(GoOutB, 1500);
                Body.CallFuction(RangeAttacking, 1500);
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
        private void PersonalAttack()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                Body.CurrentDamagePlus = 0.8f;
                int mtX = Game.Random.Next(target.X - 10, target.X + 10);
                if (Body.ShootPoint(target.X, target.Y, 127, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatA", 1700, 0);
                }
            }
        }
        private void RangeAttacking()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
    }
}
