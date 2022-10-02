using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TwelveSimpleCrocodileBoss : ABrain
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
                if (player.IsLiving && player.X > 1280 )
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
            else if (m_attackTurn == 1)
            {
                AttackD();
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
        private void MoveBeatA()
        {
            Body.MoveTo(Game.Random.Next(641, 1110), 781, "walk", 500, "", 12, new LivingCallBack(AttackA));
        }

        private void AttackA()
        {
            Body.CurrentDamagePlus = 0.5f;
            Body.PlayMovie("beatA", 1000, 0);
            Body.CallFuction(RangeAttacking, 2000);
        }
        private void AttackB()
        {
            Body.CurrentDamagePlus = 0.8f;
            Body.PlayMovie("beatB", 1000, 0);
            Body.CallFuction(RangeAttacking, 4000);
        }

        private void AttackC()
        {
            Body.CurrentDamagePlus = 1.1f;
            Body.PlayMovie("beatC", 1000, 0);
            Body.CallFuction(RangeAttacking, 3500);
        }

        private void AttackD()
        {
            Body.CurrentDamagePlus = 1.1f;
            Body.PlayMovie("beatD", 1000, 0);
            Body.CallFuction(RangeAttacking, 3500);
        }

        private void RangeAttacking()
        {
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 0, null);
        }
    }
}
