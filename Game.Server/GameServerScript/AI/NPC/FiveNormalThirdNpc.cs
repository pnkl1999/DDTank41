using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FiveNormalThirdNpc : ABrain
    {
        private int m_attackTurn = 0;

        protected Player m_targer;

        private PhysicalObj deadEffect;

        private int m_bloodReduce = 200;

        private static string[] AttackChat = new string[] {
                    ""
                };
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;

            if (deadEffect != null)
                Game.RemovePhysicalObj(deadEffect, true);
            deadEffect = null;

            if(m_targer != null)
                m_targer.SpeedMultX(3);
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            FindTarget();
        }

        private void FindTarget()
        {
            int minXLeft = int.MaxValue;
            int minXRight = int.MinValue;
            Player pLeft = null;
            Player pRight = null;

            foreach (Player player in Game.GetAllLivingPlayers())
            {
                if (player.X > 1000 && player.X > minXRight)
                {
                    minXRight = player.X;
                    pRight = player;
                }
                else if (player.X <= 1000 && player.X < minXLeft)
                {
                    minXLeft = player.X;
                    pLeft = player;
                }
            }

            if (pLeft == null && pRight != null)
                m_targer = pRight;
            else if (pRight == null && pLeft != null)
                m_targer = pLeft;
            else if(pRight != null && pLeft != null)
            {
                // find target near
                double disToLeft = Body.Distance(pLeft.X, pLeft.Y);
                double disToRight = Body.Distance(pRight.X, pRight.Y);

                if (disToLeft < disToRight)
                    m_targer = pLeft;
                else
                    m_targer = pRight;
            }
            else
            {
                m_targer = Game.FindRandomPlayer();
            }

            MoveAndAttack();
        }

        private void MoveAndAttack()
        {
            if(m_targer != null)
            {
                Body.MoveTo(m_targer.X, m_targer.Y, "fly", 1000, 6, AttackTarget);
            }
        }

        private void AttackTarget()
        {
            Body.MaxBeatDis = 500;
            m_targer.SpeedMultX(18);
            Body.PlayMovie("beatA", 500, 0);
            //Body.Beat(m_targer, "beatA", 100, 0, 500);
            Body.CallFuction(CreateDeadEffect, 1500);
            Body.BeatDirect(m_targer, "", 1600, 1, 1);
            Body.CallFuction(new LivingCallBack(StartMoveTarget), 1700);
            m_targer.AddEffect(new ContinueReduceBloodEffect(1, m_bloodReduce, Body), 3200);
            Body.CallFuction(MoveToUp, 2500);
        }

        private void MoveToUp()
        {
            Body.MoveTo(Body.X, Body.Y - 50, "fly", 0, 6);
        }

        private void StartMoveTarget()
        {
            if (m_targer.X > 1000)
            {
                // chay ve ben phai
                m_targer.StartSpeedMult(m_targer.X + 150, m_targer.Y, 0);
            }
            else
            {
                // chay ve ben trai
                m_targer.StartSpeedMult(m_targer.X - 150, m_targer.Y, 0);
            }
        }

        private void CreateDeadEffect()
        {
            deadEffect = ((PVEGame)Game).Createlayer(m_targer.X, m_targer.Y, "", "asset.game.4.tang", "", 1, 1);
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
            base.OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);
        }

    }
}
