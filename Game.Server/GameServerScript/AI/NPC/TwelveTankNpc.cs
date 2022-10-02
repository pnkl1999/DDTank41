using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TwelveTankNpc : ABrain
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
                if (player.IsLiving && player.X > 480 && player.X < 1000)
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
                PersonalAttack();
                m_attackTurn++;
            }
            else
            {
                AllAttack();
                m_attackTurn = 0;
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
            Body.PlayMovie("stand", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }
        private void AllAttack()
        {
            ChangeDirection(3);
            Body.CurrentDamagePlus = 0.5f;
            Body.PlayMovie("stand", 1000, 0);
            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 4000, null);
        }
        private void PersonalAttack()
        {
            ChangeDirection(3);
            int dis = Game.Random.Next(550, 1200);
            int direction = Body.Direction;
            Body.MoveTo(dis, Body.Y, "walk", 1000, 3);
            Body.ChangeDirection(Game.FindlivingbyDir(Body), 9000);
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
