using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SixTerrorThirdBoss : ABrain
    {
        private Player m_target = null;

        private int m_targetDis = 0;

        private int m_attackTurn = 0;

        private int npcId = 6332; // trong tai

        private SimpleBoss m_npc;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            if (m_npc == null)
            {
                m_npc = Game.FindLivingTurnBossWithID(npcId)[0];
            }

            if (m_npc.Config.CompleteStep == false)
            {
                m_npc.PlayMovie("stand", 0, 0);
                (Game as PVEGame).SendObjectFocus(m_npc, 1, 1000, 0);
                m_npc.PlayMovie("beida", 2000, 0);
                Body.CallFuction(CallBackUpdateMapping, 2000);
                m_npc.Config.CompleteStep = true;
                Body.CallFuction(CallAttackPlayer, 4000);
            }
            else
            {
                CallAttackPlayer();
            }
        }

        private void CallBackUpdateMapping()
        {
            (Game as PVEGame).SendLivingActionMapping(m_npc, "stand", "standB");
        }

        private void CallAttackPlayer()
        {
            m_target = Game.FindNearestPlayer(Body.X, Body.Y);
            m_targetDis = (int)m_target.Distance(Body.X, Body.Y);
            Body.Direction = Game.FindlivingbyDir(Body);
            if (m_attackTurn == 0)
            {
                MoveToPlayerA(m_target);
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                MoveToPlayerB(m_target);
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                MoveToPlayerC(m_target);
                m_attackTurn++;
            }
            else if (m_attackTurn == 3)
            {
                MoveToPlayerD(m_target);
                m_attackTurn++;
            }
            else if (m_attackTurn == 4)
            {
                MoveToPlayerE(m_target);
                m_attackTurn++;
            }
            else
            {
                MoveToPlayerF(m_target);
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public void MoveToPlayerA(Player player)
        {
            Body.PlayMovie("walk", 0, 0);
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            else
            {
                Body.JumpTo(player.X - 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            Body.CallFuction(new LivingCallBack(BeatA), 1000);
        }

        public void BeatA()
        {
            Body.PlayMovie("beatA", 0, 0);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 900, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1400, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1900, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 2300, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 2700, null);
        }

        public void MoveToPlayerB(Player player)
        {
            Body.PlayMovie("walk", 0, 0);
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            else
            {
                Body.JumpTo(player.X - 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            Body.CallFuction(new LivingCallBack(BeatB), 1000);
        }

        public void BeatB()
        {
            Body.PlayMovie("beatB", 0, 0);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 900, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1400, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1900, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 2300, null);
        }

        public void MoveToPlayerC(Player player)
        {
            Body.PlayMovie("walk", 0, 0);
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            else
            {
                Body.JumpTo(player.X - 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            Body.CallFuction(new LivingCallBack(BeatC), 1000);
        }

        public void BeatC()
        {
            Body.PlayMovie("beatC", 0, 0);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 900, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1400, null);
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1900, null);
        }

        public void MoveToPlayerD(Player player)
        {
            Body.PlayMovie("walk", 0, 0);
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            else
            {
                Body.JumpTo(player.X - 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            Body.CallFuction(new LivingCallBack(BeatD), 1000);
        }

        public void BeatD()
        {
            Body.PlayMovie("beatD", 0, 0);
            Body.CurrentDamagePlus = 2;
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1200, null);
        }

        public void MoveToPlayerE(Player player)
        {
            Body.PlayMovie("walk", 0, 0);
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            else
            {
                Body.JumpTo(player.X - 150, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }

            Body.CallFuction(new LivingCallBack(BeatE), 1000);
        }

        public void BeatE()
        {
            Body.PlayMovie("beatE", 0, 0);
            Body.CurrentDamagePlus = 2;
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1200, null);
        }

        public void MoveToPlayerF(Player player)
        {
            if (Body.X > player.X)
            {
                Body.JumpTo(player.X + 5, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }
            else
            {
                Body.JumpTo(player.X - 5, Body.Y - 475, "Jump", 1000, 0, 5, null, 1);
            }
            Body.CallFuction(new LivingCallBack(BeatF), 1000);
        }

        public void BeatF()
        {
            Body.PlayMovie("beatF", 0, 0);
            Body.CurrentDamagePlus = 2;
            Body.RangeAttacking(Body.X - 200, Body.X + 200, "cry", 1500, null);
        }
    }
}
