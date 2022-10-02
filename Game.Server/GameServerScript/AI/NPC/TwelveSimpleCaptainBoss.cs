using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class TwelveSimpleCaptainBoss : ABrain
    {
        private int m_attackTurn = 0;

        private Player m_target;

        private int m_dis;

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
            Body.MaxBeatDis = 190;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            if(m_attackTurn == 0)
            {
                SayToPlayer();
                m_attackTurn = 1;
            }
            else
            {
                MoveToPlayerAndAttack();
            }
            //Body.Direction = Game.FindlivingbyDir(Body);
        }

        private void SayToPlayer()
        {
            (Game as PVEGame).SendObjectFocus(Body, 0, 1000, 0);
            Body.FallFrom(Body.X, Body.Y, "", 2000, 0, 0, null);
            Body.SetThumbnailBoss(false);
            Body.Say("Sẽ cho các người biết thế nào là lợi hại của ta!", 1, 2500, 2000);
        }

        private void MoveToPlayerAndAttack()
        {
            m_target = Game.FindNearestPlayer(Body.X, Body.Y);
            Body.ChangeDirection(m_target, 500);

            if (m_target != null && m_target.IsLiving)
            {
                m_dis = (int)m_target.Distance(Body.X, Body.Y);

                if(m_dis > Body.MaxBeatDis)
                {
                    Body.CallFuction(MoveToTarget, 1000);
                }
                else
                {
                    Body.CallFuction(Beat, 1000);
                }
            }
        }

        private void MoveToTarget()
        {
            int ramdis = Game.Random.Next(((SimpleBoss)Body).NpcInfo.MoveMax, ((SimpleBoss)Body).NpcInfo.MoveMax);

            if (m_dis < ramdis)
                ramdis = m_dis;

            int moveX = Body.Direction == -1 ? Body.X - ramdis : Body.X + ramdis;

            Body.MoveTo(moveX, Body.Y, "walk", 1200, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(Beat));
        }

        private void Beat()
        {
            Body.Beat(m_target, "beatA", 100, 0, 500, 1, 1);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
