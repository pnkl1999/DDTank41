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
    public class FourHardFrantCattleBoss : ABrain
    {
        private int m_attackTurn = 0;

        private Point m_pointMakeDamage;

        private bool m_isBorn = false;

        protected Player m_targer;
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
            m_isBorn = false;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();

            m_attackTurn++;
            switch (m_attackTurn)
            {
                case 1:

                    //if (!m_isBorn)
                    //{
                        //((PVEGame)Game).SendLivingActionMapping(Body, "stand", "stand");
                        //Body.PlayMovie("born", 1000, 0);
                        //Body.Say("<span class=\"red\">Thực sự là giận lắm rồi. Ta sẽ nghiền nát tất cả!</span>", 0, 1200);
                        Body.CallFuction(JumpAttack, 4000);
                        //m_isBorn = true;
                    //}
                    //else
                    //{
                        //Body.CallFuction(RunAttack, 1000);
                    //}
                    break;
                case 10:
                    Body.CallFuction(JumpAttack, 1000);
                    m_attackTurn = 0;
                    break;
                default:
                    Body.CallFuction(RunAttack, 1000);
                    break;
            }
        }

        private void JumpAttack()
        {
            m_targer = Game.FindRandomPlayer();
            if (m_targer != null)
            {
                int randAttack = Game.Random.Next(100);
                Body.PlayMovie("jump", 1000, 0);
                Body.BoltMove(m_targer.X, m_targer.Y, 3000);
                ((PVEGame)Game).SendObjectFocus(m_targer, 1, 3000, 0);
                if (randAttack < 50)
                {
                    Body.CurrentDamagePlus = 2f;
                    Body.PlayMovie("fallB", 4000, 0);
                }
                else
                {
                    Body.PlayMovie("fall", 4000, 0);
                }
                Body.RangeAttacking(m_targer.X - 50, m_targer.X + 50, "cry", 5000, true);
            }
        }

        private void RunAttack()
        {
            m_targer = Game.FindFarPlayer(Body.X, Body.Y);
            if (m_targer != null)
            {
                Body.ChangeDirection(m_targer, 100);

                if(m_targer.X + 200 >= Game.Map.Info.DeadWidth || m_targer.X - 200 <= 0)
                {
                    Body.CallFuction(JumpAttack, 1000);
                }
                // check it's current
                else if (Body.Distance(m_targer.X, m_targer.Y) <= 100)
                {
                    Body.CallFuction(NearAttack, 1000);
                }
                else
                {
                    Body.CallFuction(MoveAndAttack, 500);
                }
            }
        }

        private void MoveAndAttack()
        {
            m_pointMakeDamage = new Point(Body.X, Body.Y);
            if (Body.Direction == -1)
                Body.MoveTo(m_targer.X - 100, m_targer.Y, "walk", 1000, 12, AttackRangeRun);
            else
                Body.MoveTo(m_targer.X + 100, m_targer.Y, "walk", 1000, 12, AttackRangeRun);
        }

        private void NearAttack()
        {
            m_pointMakeDamage = new Point(Body.X, Body.Y);
            if (Body.Direction == -1)
            {
                Body.MoveTo(m_targer.X - 200, m_targer.Y, "walk", 500, 12, AttackRangeRun);
            }
            else
            {
                Body.MoveTo(m_targer.X + 200, m_targer.Y, "walk", 500,12, AttackRangeRun);
            }
        }

        private void AttackRangeRun()
        {
            Body.ChangeDirection(m_targer, 100);
            if (Body.X < m_pointMakeDamage.X)
            {
                Body.RangeAttacking(Body.X, m_pointMakeDamage.X, "cry", 0, true);
            }
            else
            {
                Body.RangeAttacking(m_pointMakeDamage.X, Body.X, "cry", 0, true);
            }
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }


    }
}
