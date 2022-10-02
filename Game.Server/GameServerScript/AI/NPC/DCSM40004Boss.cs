using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class DCSM40004Boss : ABrain
    {
        private int m_attackTurn = 0;

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
                if (player.IsLiving && player.X > 500 && player.X < 1050)
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
                KillAttack(500, 1050);

                return;
            }

            if (m_attackTurn == 0)
            {
                AllAttack();
                m_attackTurn++;
            }
            else
            {
                PersonalAttack();
                m_attackTurn = 0 ;
            }           
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void KillAttack(int fx, int tx)
        {
            ChangeDirection(3);            
            Body.CurrentDamagePlus = 10;
            Body.PlayMovie("beat2", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        private void AllAttack()
        {
            ChangeDirection(3);
            Body.CurrentDamagePlus = 0.5f;            
            Body.FallFrom(Body.X, 509, null, 1000, 1, 12);
            Body.PlayMovie("beat2", 1000, 0);
            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 4000, null);
        }

        private void PersonalAttack()
        {
            ChangeDirection(3);            
            int dis = Game.Random.Next(670, 880);
            int direction = Body.Direction;
            Body.MoveTo(dis, Body.Y, "walk", 1000,"",3, new LivingCallBack(NextAttack));
            Body.ChangeDirection(Game.FindlivingbyDir(Body), 9000);
        }       

        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();
            if (target == null)
                return;
            Body.SetRect(0, 0, 0, 0);  
            Body.CurrentDamagePlus = 0.8f;
            if (target != null)
            {
                if (target.X > Body.Y)
                {
                    Body.ChangeDirection(1, 500);
                }
                else
                {
                    Body.ChangeDirection(-1, 500);
                }
                int mtX = Game.Random.Next(target.X - 50, target.X + 50);

                if (Body.ShootPoint(mtX, target.Y, 61, 1000, 10000, 1, 1, 2200))
                {
                    Body.PlayMovie("beat", 1700, 0);
                }               
            }
        }

        private void ChangeDirection(int count)
        {
            int direction = Body.Direction;
            for (int i = 0; i < count; i++)
            {
                Body.ChangeDirection(-direction, i * 200 + 100);
                Body.ChangeDirection(direction, (i + 1) * 100 + i * 200);
            }
        }      


    }
}
