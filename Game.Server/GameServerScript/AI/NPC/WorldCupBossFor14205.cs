using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupBossFor14205 : ABrain
    {
        private int m_attackTurn = 0;
        public int currentCount = 0;
        public int Dander = 0;
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }
        private int npcID = 14204;
        public List<SimpleNpc> Children = new List<SimpleNpc>();
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
                if (player.IsLiving && player.X >1070)
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
                CallChild();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                AttackA();
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                AttackC();
                m_attackTurn++;
            }
            else
            {                
                if (((SimpleBoss)Body).CurrentLivingNpcNum > 0)
                {
                    HealChild();                    
                }
                else
                {
                    CallChild();
                }
                m_attackTurn = 1;
            }
        }
        public void HealChild()
        {
            Body.PlayMovie("beatD", 1000, 0);
            Body.CallFuction(Heal, 1500);           
        }
        public void Heal()
        {            
            SimpleNpc child = ((SimpleBoss)Body).FindFrostChild();
            if (child != null && child.IsLiving)
            {
                if (child != null && child.IsFrost)
                {
                    ((PVEGame)Game).SendGameFocus(child, 0, 2000);
                    child.IsFrost = false;
                    child.PlayMovie("stand", 1000, 0);
                }
                else
                {
                    child.AddBlood(10000);
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
            Body.PlayMovie("beatD", 1000, 0);
            Body.RangeAttacking(fx, tx, "cry", 4000, null);
        }
        private void CallChild()
        {
            Body.PlayMovie("beatB", 1000, 0);
            Body.CallFuction(CreateChild, 1500);
        }       
        private void AttackA()
        {
            List<Player> players = Game.GetAllFightPlayers();
            Body.CurrentDamagePlus = 1.5f;
            Body.Direction = Game.FindlivingbyDir(Body);
            foreach (Player target in players)
            {
                if (target != null)
                {
                    if (Body.ShootPoint(target.X, target.Y, 14005, 1000, 10000, 1, 3.0f, 1550))
                    {
                        Body.PlayMovie("beatA", 1050, 0);
                    }
                }
            }
        }
        private void AttackC()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.MoveTo(target.X + 220, target.Y, "walkB", 1000, "", 22, new LivingCallBack(NextAttackC));
            }
        }
        private void NextAttackC()
        {
            Body.CurrentDamagePlus = 1.9f;
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.PlayMovie("beatC", 500, 0);
            Body.RangeAttacking(Body.X - 270, Body.X, "cry", 1500, null);
            Body.CallFuction(new LivingCallBack(Comback), 2000);
        }
        private void Comback()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.MoveTo(1816, Body.Y, "walkB", 1000, "", 22, ChangeDirection);
        }        
        private void ChangeDirection()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
        }        
        private void RangeAttacking()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
        public void CreateChild()
        {
            ((SimpleBoss)Body).CreateChild(npcID, 1580, 861, 60, 1, -1);
        }
    }
}
